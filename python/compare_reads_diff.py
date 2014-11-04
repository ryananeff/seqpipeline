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
      		print 'compare_reads.py -c <common.bam> -a <alt.bam> -l <liftover.chain> -s <sites.tsv> -i <id> -g <chrom>'
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
			sitesf = arg
		elif opt in ("-i", "--idf"):
			idf = arg
                elif opt in ("-g", "--chrom"):
                        chrom = arg
		else:
			assert False, "unhandled option"
	if idf == '':
		idf = orig_bam.split("/")[-1].split("_")[0]
	compare_alignments_vcf(orig_bam, final_bam, liftover, sitesf, idf, chrom)

def compare_reads(orig_bam, final_bam, liftover, sitesf, idf, chrom=None):
    print orig_bam
    print final_bam
    print sites_file
    print liftover
    print sitesf
    
   #TODO: Add a reverse option in this program
    

    '''
    Usage: Compares reads from the original file and sees where they have moved in the final file.
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
	sitesf (string)
	    This is the file of positions in the original file you would 
	    like to extract reads from to see where they have gone.
        idf (string)
            This id is appended at the beginning of the outfile name. The 
            orig_bam and final_bam should have the same id. This also 
            needs to be identical to the sample name in the sites file.
	chrom (string) - DISABLED
	    Only look at a particular chromosome. TODO to reenable it.
    
    Outputs:
        {id}-compare_d.arr
            A listing of the collected metrics by change in each BAM file.

    '''
    
    if chrom != None:
        out_file = final_bam + "_" + chrom + "_compare_reads.b2b"
    else:
        out_file = final_bam + "_compare_reads.b2b"
    
    # open BAM files given in input parameters
    assert pysam.Samfile(orig_bam, 'rb'), 'ERROR: Cannot open orig_bam file.'
    assert pysam.Samfile(final_bam, 'rb'), 'ERROR: Cannot open final_bam file.'
    orig_fp = pysam.Samfile(orig_bam, 'rb')
    final_fp = pysam.Samfile(final_bam, 'rb')
    
    # open sites file
    num = subprocess.check_output('head -n 1000 ' + sitesf + ' | grep "#" | wc -l', shell=True)
    sitesarr = pd.read_csv(sites_file, header=None, sep='\t', skiprows=num) # this is a VCF file
    sitesarr = sitesarr[[0,1,3,4]] # only keep the chromosome, position, ref, alt columns, drop everything else
    
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

    sys.stderr.write("Initialization complete. Starting processing...\n")

    #TODO: get the region list
    # let's define the region as all the reads containing the position
    # this should mean the pileup command includes start and start+len

    # the sites file should be the unique variants in hg38
    regionlist = zip(sitesarr[0], sitesarr[1], sitesarr[4].map(lambda x: len(x)))

    sys.stderr.write("Region list loaded (" + str(len(regionlist)) + " variants).\n")

    # get the reads... this will take a LONG TIME
    orig_reads = retrieveReads_regions(orig_fp, 0, regionlist)
    sys.stderr.write("Collected " + str(len(orig_reads)) + " reads from 1st BAM file. Finding in 2nd BAM file...\n")

    alt_reads = retrieveReads_filter(final_fp, 0, set(orig_reads[0]))
    sys.stderr.write("Found " + str(len(alt_reads)) + " reads matching 1st BAM file in 2nd BAM file. Printing statistics...\n")

    # now let's do the comparison... hope this doesn't go on forever
    for a,i in orig_reads.iterrows():
        read_name = i[0]
	read_chr = i[1]
	read_pos = i[2]
        try:
            res = alt_reads.loc[alt_read_name]
        except:
            outarr = [read_name, read_chr, read_pos, None, None, None, "read not aligned in 2nd BAM (e.g. final BAM)"]
            out_fp.write(custom_write(outarr))
        # if the read exists in alt ref, lift it over to com ref and check its position
        com_pos = lift_master(res[2], lifttable, 'chr' + str(res[1]+1), reverse=True)
        if ((com_pos != read_pos) | (res[1] != read_chr)):
		outarr = [read_name, read_chr, read_pos, res[0], res[1], com_pos, "new position in 2nd BAM (e.g. final BAM)"]
		out_fp.write(custom_write(out_arr))

    # return if everything is happy
    sys.stderr.write("Completed traversal for " + idf + ".\n")
    return 0

# used by compare_alignments - subroutine
# outputs - number of aligned reads, mean mapping quality, mean insert size, mean aligned length of reads

# now let's make the two arrays for cross comparison - this will take up a LOT of RAM
def retrieveReads_filter(bam_fp, sort_col, filter_set):
	# this sub only outputs the reads included in filter_set
	tmparray = []
        for i in bam_fp.fetch():
	    if i.qname in filter_set:
            	tmparray.append((int(str(i.qname).split('.')[1]), int(i.tid), int(i.pos)))
	    else:
		continue
	outarr = pd.Dataframe(tmparray).sort(columns=[sort_col])
	outarr = outarr.set_index(outarr[0])
	return outarr

def retrieveReads_regions(bam_fp, sort_col, regions):
	# regions is an array of tuples of the shape (chrom, start, end)
        tmparray = []
	for r in regions:
        	for i in bam_fp.pileup(r[0], r[1],r[2]):
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
	    delta = 0
        if ref_pos > lift_til: # check if cached?
            try:
                delta, lift_til = liftdelta(ref_pos, lifttable, start_idx, end_idx, reverse) # converts position into alt ref pos
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
