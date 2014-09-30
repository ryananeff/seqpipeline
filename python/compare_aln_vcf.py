#!/data/projects_gibbons/home/neffra/anaconda2/bin/python

import sys, getopt
import time
import numpy as np
import scipy as sp
import pandas as pd
import pysam
import subprocess
import os
lifttable = ''
last_chr = ''
lift_til = 0
delta = 0

def main(argv):
	orig_bam = ''
   	final_bam = ''
	liftover = ''
	sites_file = ''
	idf = ''
   	try:
		opts, args = getopt.getopt(argv,"c:a:l:s:i:g",["common=","alt=", "liftover=", "sites=", "idf=","chrom="])
   	except getopt.GetoptError:
      		print 'compare_aln_vcf.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -s <sites.tsv> -i <id> -g <chrom>'
      		sys.exit(2)
   	for opt, arg in opts:
      		if opt == '-h':
         		print 'compare_aln_vcf.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -s <sites.tsv> -i <id> -g <chrom>'
         		sys.exit()
      		elif opt in ("-c", "--common"):
         		orig_bam = arg
      		elif opt in ("-a", "--alt"):
         		final_bam = arg
		elif opt in ("-l", "--liftover"):
			liftover = arg
		elif opt in ("-s", "--sites"):
			sites_file = arg
		elif opt in ("-i", "--idf"):
			idf = arg
                elif opt in ("-g", "--chrom"):
                        chrom = arg
		else:
			assert False, "unhandled option"
	if idf == '':
		idf = orig_bam.split("/")[-1].split("_")[0]
	compare_alignments_vcf(orig_bam, final_bam, idf, liftover, sites_file)

def compare_alignments_vcf(orig_bam, final_bam, idf, liftover, sites_file, chrom=None):
    print orig_bam
    print final_bam
    print idf
    print liftover
    print sites_file
    
    #index original BAM file
    #if os.path.isfile('.'.join(orig_bam.split('.')[0:-1]) + '.bai') == False:
    #subprocess.check_output('samtools index ' + orig_bam, shell=True)
    
    #index final BAM file
    #if os.path.isfile('.'.join(final_bam.split('.')[0:-1]) + '.bai') == False:
    #subprocess.check_output('samtools index ' + final_bam, shell=True)
    

    '''
    Usage: Compares detailed alignment statistics between two files. Should be
    a comparison of alignments between the same individual.                          
    
    Inputs:
        orig_bam (string)
            The filename of a bam file aligned to the original 
            (e.g. common) reference genome. 
        final_bam (string)
            The filename of a bam file aligned to the final 
            (e.g. pop-specific) reference.
            genome. 
        liftover (string)
            The filename of a liftover chain file generated during the 
            orig->final reference creation process.
        sites_file (string)
            The filename of the sites changed between references for 
            statistics collection. This will be formatted identical
	    to a VCF file.
        idf (string)
            This id is appended at the beginning of the outfile name. The 
            orig_bam and final_bam should have the same id. This also 
            needs to be identical to the sample name in the sites file.
    
    Outputs:
        {id}-compare_d.arr
            A listing of the collected metrics by change in each BAM file.
    '''
    if chrom != None:
        out_file = final_bam + "_" + chrom + "_compare_d.arr"
    else:
        out_file = final_bam + "_compare_d.arr"
    
    # here for legacy
    metrics = [{'stepper':'all','mask':2}]        # this filters for secondary/non-primary alignments
    metrics.append({'stepper':'all','mask':3340}) # this filters for properly mapped reads
        
    # open BAM files given in input parameters
    assert pysam.Samfile(orig_bam, 'rb'), 'ERROR: Cannot open orig_bam file.'
    assert pysam.Samfile(final_bam, 'rb'), 'ERROR: Cannot open final_bam file.'
    orig_fp = pysam.Samfile(orig_bam, 'rb')
    final_fp = pysam.Samfile(final_bam, 'rb')
    
    # open sites and liftover files
    headnum = int(subprocess.check_output('head -n 500 ' + sites_file + ' | grep "#" | wc -l', shell=True))# this gives us the number of lines in the header, minus the col titles
    sites = pd.read_csv(sites_file, sep='\t', skiprows=headnum-1)
    colnames=['chain','score','ref_chr','ref_len','ref_misc','ref_start','ref_end',
              'alt_chr','alt_len','alt_misc','alt_start','alt_end']
    
    chr_names=["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
               "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY"]
    
    lifttable = pd.read_csv(liftover,sep='\t',header=None, 
                       names=colnames)
    lifttable.set_index(['ref_chr', 'ref_start', 'ref_end'], inplace=True)
    
    #open output file
    out_fp = open(out_file, "wb")
    
    # for fast retrieval - assume the input is already sorted which it has to be
    sites = sites.set_index([sites['#CHROM'], sites['POS']])[['#CHROM','POS','REF','ALT','INFO','FORMAT',idf]]
    
    # some more things to prep for traversal - get list of chromosomes
    if chrom != None:
        chrom = [chrom]
    else:
        chrom = chr_names
    
    # okay, we're ready to do the comparison at the sites listed - progressbar shouldn't interfere
    
    for cur_chrom in chrom:
        out_arr = [] # this will hold the values until we're ready to print
	slx = sites.loc[cur_chrom]
        sl = list(slx['POS'])
        for pos in sl:
            orig_result = get_pileup_statistics(orig_fp, cur_chrom, pos-1) # get the result from the original BAM
	    try:
	    	newpos = lift_master(pos-1, lifttable, cur_chrom, False) # converts position into alt ref pos
            except:
	    	sys.stderr.write("WARN: couldn't lift position at " + str(cur_chrom) + ":" + str(pos-1) + "\n")
	    	continue
            if newpos==None:
		sys.stderr.write("WARN: couldn't lift position at " + str(cur_chrom) + ":" + str(pos-1) + "\n")
                continue
	    alt_result = get_pileup_statistics(final_fp, cur_chrom, newpos)
            final_result = []
            final_result.append([cur_chrom, pos-1])
            final_result.append(list(slx.loc[pos][['REF','ALT','INFO','FORMAT',idf]]))
            final_result.append(orig_result)
            final_result.append(alt_result)
            final_result = [item for sublist in final_result for item in sublist]
            # once we're done with each chromosome, we can flush to disk (not the only solution...)
            out_fp.write(custom_write(final_result))
            
    # return if everything is happy
    sys.stderr.write("Completed traversal for " + idf + ".\n")
    return 0

# used by compare_alignments - subroutine
# outputs - number of aligned reads, mean mapping quality, mean insert size, mean aligned length of reads
def get_pileup_statistics(samfile, chrom, start):
    import numpy as np
    result = [0, 0, 0, 0, 0]
    reached = False
    for i in samfile.pileup(chrom, start, start+1, truncate=True):
	if i.pos == start:
		reached=True
		mapq = []
		insert = []
		edit_dist = []
		aligned_score = []
		for p in i.pileups:
        		mapq.append(p.alignment.mapq)
        		insert.append(abs(p.alignment.tlen))
                	# average edit distance
        		tags = dict()
        		for b in p.alignment.tags:
                		tags[b[0]] = b[1]
			edit_dist.append(tags['NM'])
			aligned_score.append(tags['AS'])
		break
    if reached==True:
        result = [i.n, np.mean(mapq), np.mean(insert), np.mean(edit_dist), np.mean(aligned_score)]
    return result

def custom_write(i):
    result = ''
    for s in i:
        result += str(s) + "\t"
    result += "\n"
    return result

# this is the code to make liftovers work going in the hg## --> AFRG1 direction
def lift_master(ref_pos, liftover, chrom, reverse):
    global lifttable
    global start_idx
    global end_idx
    global last_chr
    global lift_til
    global delta
    if reverse==False:
        if last_chr != chrom:
            # this is where we subset the liftover array
            lifttable = liftover.loc[chrom]
            start_idx = lifttable.index.get_level_values('ref_start')
            end_idx = lifttable.index.get_level_values('ref_end')
            last_chr = chrom
            delta = 0
        if ref_pos > lift_til: # check if cached?
            try:
                delta, lift_til = liftdelta(ref_pos, lifttable, start_idx, end_idx, reverse) # converts position into alt ref pos
            except:
                return None
    elif reverse==True:
        if last_chr != chrom:
            # this is where we subset the liftover array
            lifttable = liftover.loc[chrom]
            start_idx = lifttable.index.get_level_values('alt_start')
            end_idx = lifttable.index.get_level_values('alt_end')
            last_chr = chrom
        if ref_pos > lift_til: # check if cached?
            try:
                delta, lift_til = liftdelta(ref_pos, lifttable, reverse) # converts position into alt ref pos
            except:
                return None
    else:
        assert False, "unhandled command"
    return ref_pos + delta
    

def liftdelta(pos, liftover, start_idx, end_idx, reverse):
    match = liftover.loc[(start_idx <= pos) & (end_idx > pos)].reset_index().irow(0)
    if reverse==False:
        return match['alt_start'] - match['ref_start'], match['ref_end']
    if reverse==True:
        return match['ref_start'] - match['alt_start'], match['alt_end']

# run the program if called from the command line
if __name__ == "__main__":
   main(sys.argv[1:])
