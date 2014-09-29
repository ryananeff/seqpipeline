#!/data/projects_gibbons/home/neffra/anaconda2/bin/python

import sys, getopt
import time
import numpy as np
import scipy as sp
import pandas as pd
import pysam
import subprocess

def main(argv):
	orig_bam = ''
   	final_bam = ''
	liftover = ''
	sites_file = ''
   	try:
		opts, args = getopt.getopt(argv,"c:a:l:s:",["common=","alt=", "liftover=", "sites="])
   	except getopt.GetoptError:
      		print 'compare_aln_vcf.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -s <sites.tsv>'
      		sys.exit(2)
   	for opt, arg in opts:
      		if opt == '-h':
         		print 'compare_aln_vcf.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -s <sites.tsv>'
         		sys.exit()
      		elif opt in ("-c", "--common"):
         		orig_bam = arg
      		elif opt in ("-a", "--alt"):
         		final_bam = arg
		elif opt in ("-l", "--liftover"):
			liftover = arg
		elif opt in ("-s", "--sites"):
			sites_file = arg
		else:
			assert False, "unhandled option"
	idf = orig_bam.split("/")[-1].split("_")[0]
	compare_alignments_vcf(orig_bam, final_bam, liftover, sites_file, idf)

def compare_alignments_vcf(orig_bam, final_bam, liftover, sites_file, idf):

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
            statistics collection.
        idf (string)
            This id is appended at the beginning of the outfile name. The 
            orig_bam and final_bam should have the same id.
    
    Outputs:
        {id}-compare_d.arr
            A listing of the collected metrics by change in each BAM file.
    '''
    
    out_file = idf + "_compare_d.arr"
    
    # here for legacy
    metrics = [{'stepper':'all','mask':2}]        # this filters for secondary/non-primary alignments
    metrics.append({'stepper':'all','mask':3340}) # this filters for properly mapped reads
        
    # open BAM files given in input parameters
    assert pysam.Samfile(orig_bam, 'rb'), 'ERROR: Cannot open orig_bam file.'
    assert pysam.Samfile(final_bam, 'rb'), 'ERROR: Cannot open final_bam file.'
    orig_fp = pysam.Samfile(orig_bam, 'rb')
    final_fp = pysam.Samfile(final_bam, 'rb')
    
    # open sites and liftover files
    sites = pd.read_csv(sites_file, header=None, sep='\t')
    lifttable = pd.read_csv(liftover, header=None, sep='\t')
    
    #open output file
    out_fp = open(out_file, "wb")
    
    # for fast retrieval - assume the input is already sorted which it has to be
    lifttable = lifttable.set_index(lifttable[2])
    sites = sites.set_index(sites[0])
    
    # some more things to prep for traversal - get list of chromosomes
    chrom = sorted(set(lifttable.index))
    
    # okay, we're ready to do the comparison at the sites listed - progressbar shouldn't interfere
    
    for cur_chrom in chrom:
        out_arr = [] # this will hold the values until we're ready to print
        end_length = lifttable.loc[cur_chrom].iloc[0][3] # this is the length of the contig in common ref
        sl = list(sites.loc[cur_chrom][1])
        lift_til = 0
        delta = 0
	lt2 = lifttable.loc[cur_chrom] # help make things faster
        for pos in sl:
            orig_result = get_pileup_statistics(orig_fp, cur_chrom, pos) # get the result from the original BAM
            if pos > lift_til:
                try:
                    delta, lift_til = liftdelta(pos, lt2, cur_chrom) # converts position into alt ref pos
                except:
                    lift_til = pos # this shouldn't ever happen...
            newpos = pos+delta
            alt_result = get_pileup_statistics(final_fp, cur_chrom, newpos)
            final_result = []
            final_result.append([cur_chrom, pos])
            final_result.append([i for i in orig_result])
            final_result.append([i for i in alt_result])
            final_result = [item for sublist in final_result for item in sublist]
            out_arr.append(final_result)
        # once we're done with each chromosome, we can flush to disk (not the only solution...)
        for outstr in custom_write(out_arr):
            out_fp.write(outstr)
            
    # return if everything is happy
    return "Completed traversal for " + idf + "."

# used by compare_alignments - subroutine
# outputs - number of aligned reads, mean mapping quality, mean insert size, mean aligned length of reads

def get_pileup_statistics(samfile, chrom, start):
    result = (0, 0, 0, 0)
    reached = False
    for i in samfile.pileup(chrom, start, start+1):
        if i.pos == start:
            reached=True
            mapq = []
            insert = []
            aligned_score = []
            for p in i.pileups:
                mapq.append(p.alignment.mapq)
                insert.append(abs(p.alignment.tlen))
                # average alignment score
                tags = dict()
                for b in p.alignment.tags:
                    tags[b[0]] = b[1]
                aligned_score.append(tags['AS'])
            break
    if reached==True:
        result = (i.n, np.mean(mapq), np.mean(insert), np.mean(aligned_score))
    return result

def liftdelta(pos, liftover, chrom): # going in the hg19 --> AFRG1 direction
    match = liftover[(liftover.index == chrom) & (liftover[5] <= pos) & (liftover[6] > pos)].irow(0)
    return match[10] - match[5], match[6]

def custom_write(out_arr):
    for i in out_arr:
        result = ''
        for s in i:
            result += str(s) + "\t"
        result += "\n"
        yield result

# run the program if called from the command line
if __name__ == "__main__":
   main(sys.argv[1:])
