#!/data/projects_gibbons/home/neffra/anaconda2/bin/python

import sys, getopt
import time
import numpy as np
import scipy as sp
import pandas as pd
import pysam
import subprocess

def main(argv):
	liftover = ''
	chrom = ''
	pos = ''
	reverse = False
   	try:
		opts, args = getopt.getopt(argv,"c:p:l:r",["chrom=","pos=","liftover=", "reverse"])
   	except getopt.GetoptError:
      		print 'liftquery.py -c <chrom> -p <pos> -l <liftover.chain> [--reverse]'
      		sys.exit(2)
   	for opt, arg in opts:
      		if opt == '-h':
	      		print 'liftquery.py -c <chrom> -p <pos> -l <liftover.chain> [--reverse]'
         		sys.exit()
      		elif opt in ("-c", "--chrom"):
         		chrom = arg
      		elif opt in ("-p", "--pos"):
         		pos = int(arg)
		elif opt in ("-l", "--liftover"):
			liftover = arg
		elif opt in ("-r", "--reverse"):
			reverse=True
		else:
			assert False, "unhandled option"
	# init
	liftoverquery(chrom, pos, liftover, reverse)

def liftoverquery(chrom, pos, liftover_file, reverse=False): # this goes from hg## --> AFRG1 direction
    outarr = []
    
    colnames=['chain','score','ref_chr','ref_len','ref_misc','ref_start','ref_end',
              'alt_chr','alt_len','alt_misc','alt_start','alt_end']
    
    chr_names=["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
               "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY"]
    
    liftover = pd.read_csv(liftover_file,sep='\t',header=None, 
                       names=colnames)
    if reverse==False:
    	liftover.set_index(['ref_chr', 'ref_start', 'ref_end'], inplace=True)
    elif reverse==True:
	liftover.set_index(['alt_chr', 'alt_start', 'alt_end'], inplace=True)
    
    # now that we're init'd, let's start
    newpos = lift_master(pos, liftover, chrom, reverse)
    print newpos

# this is the code to make liftovers work going in the hg## --> AFRG1 direction
lifttable = ''
last_chr = ''
lift_til = 0
delta = 0
    
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
	    lift_til = 0 #important!
	    delta = 0 #important!
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
	    lift_til = 0 #important!
	    delta = 0 #important!
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
    elif reverse==True:
        return match['ref_start'] - match['alt_start'], match['alt_end']

# run the program if called from the command line
if __name__ == "__main__":
   main(sys.argv[1:])
