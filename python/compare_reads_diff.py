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
		opts, args = getopt.getopt(argv,"c:a:l:i:g",["common=","alt=", "liftover=", "sites=", "idf=","chrom="])
   	except getopt.GetoptError:
      		print 'compare_reads.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -i <id> -g <chrom>'
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
		elif opt in ("-i", "--idf"):
			idf = arg
                elif opt in ("-g", "--chrom"):
                        chrom = arg
		else:
			assert False, "unhandled option"
	if idf == '':
		idf = orig_bam.split("/")[-1].split("_")[0]
	compare_alignments_vcf(orig_bam, final_bam, idf, liftover, sites_file)

def compare_reads(orig_bam, final_bam, idf, liftover, chrom=None):
    print orig_bam
    print final_bam
    print idf
    print liftover
    
    #index original BAM file
    #if os.path.isfile('.'.join(orig_bam.split('.')[0:-1]) + '.bai') == False:
    #subprocess.check_output('samtools index ' + orig_bam, shell=True)
    
    #index final BAM file
    #if os.path.isfile('.'.join(final_bam.split('.')[0:-1]) + '.bai') == False:
    #subprocess.check_output('samtools index ' + final_bam, shell=True)
    

    '''
    Usage: Compares every single read between two BAM files and checks if they have moved position and to where.
	Outputs reads which have changed position in a special format.                          
    
    Inputs:
        orig_bam (string)
            The filename of a bam file aligned to the original 
            (e.g. common) reference genome. 
        final_bam (string)
            The filename of a bam file aligned to the final 
            (e.g. pop-specific) reference genome. 
        liftover (string)
            The filename of a liftover chain file generated during the 
            orig->final reference creation process.
        idf (string)
            This id is appended at the beginning of the outfile name. The 
            orig_bam and final_bam should have the same id. This also 
            needs to be identical to the sample name in the sites file.
    
    Outputs:
        {id}-compare_d.arr
            A listing of the collected metrics by change in each BAM file.
    '''
    if chrom != None:
        out_file = final_bam + "_" + chrom + "_compare_reads.b2b"
    else:
        out_file = final_bam + "_compare_reads.b2b"
    
    # here for legacy
    metrics = [{'stepper':'all','mask':2}]        # this filters for secondary/non-primary alignments
    metrics.append({'stepper':'all','mask':3340}) # this filters for properly mapped reads
        
    # open BAM files given in input parameters
    assert pysam.Samfile(orig_bam, 'rb'), 'ERROR: Cannot open orig_bam file.'
    assert pysam.Samfile(final_bam, 'rb'), 'ERROR: Cannot open final_bam file.'
    orig_fp = pysam.Samfile(orig_bam, 'rb')
    final_fp = pysam.Samfile(final_bam, 'rb')
    
    # open liftover file

    colnames=['chain','score','ref_chr','ref_len','ref_misc','ref_start','ref_end',
              'alt_chr','alt_len','alt_misc','alt_start','alt_end']
    
    chr_names=["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
               "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY"]
    
    lifttable = pd.read_csv(liftover,sep='\t',header=None, 
                       names=colnames)

    lifttable.set_index(['ref_chr', 'ref_start', 'ref_end'], inplace=True)
    
    #open output file
    out_fp = open(out_file, "wb")

    # get the reads... this will take a LONG TIME
    orig_reads = retrieveReads(orig_fp, 0)
    alt_reads = retrieveReads(final_fp, 2)

    # now let's do the comparison... hope this doesn't go on forever
    for a,i in alt_reads.iterrows():
        alt_read_name = i[0]
	alt_read_chr = i[1]
	alt_read_pos = i[2]
        try:
            res = orig_reads.loc[alt_read_name]
        except:
            outarr = [alt_read_name, alt_read_chr, alt_read_pos, None, None, None, "read not aligned in common ref"]
            out_fp.write(custom_write(outarr))
        # if the read exists in common ref, lift it over to alt ref and check its position
        afr_pos = lift_master(res[2], lifttable, 'chr' + str(res[1]+1), reverse=False) # going in the hgXX -> AFRGhxx direction
        if ((afr_pos != alt_read_pos) | (res[1] != alt_read_chr)):
		outarr = [alt_read_name, alt_read_chr, alt_read_pos, res[0], res[1], afr_pos, "new position in pop ref"]
		out_fp.write(custom_write(out_arr))
     # one last thing - check for reads only aligned in common ref
     orig_idx = set(orig_reads.index)
     alt_idx = set(alt_reads.index)
     common_idx = orig_idx.difference(alt_idx)
     common_only = orig_reads.loc[list(common_idx)]
     for a,i in common_only.iterrows():
	outarr = outarr = [None, None, None, i[0], i[1], i[2], "read not aligned in pop ref"]
	out_fp.write(custom_write(outarr))
     
    # return if everything is happy
    sys.stderr.write("Completed traversal for " + idf + ".\n")
    return 0

# used by compare_alignments - subroutine
# outputs - number of aligned reads, mean mapping quality, mean insert size, mean aligned length of reads

# now let's make the two arrays for cross comparison - this will take up a LOT of RAM
def retrieveReads(bam_fp, sort_col):
	tmparray = []
        for i in bam_fp.fetch():
            tmparray.append((int(str(i.qname).split('.')[1]), int(i.tid), int(i.pos)))
	outarr = pd.Dataframe(tmparray).sort(columns=[sort_col])
	outarr = outarr.set_index(outarr[0])
	return outarr


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
