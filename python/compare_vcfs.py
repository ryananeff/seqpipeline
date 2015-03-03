#!/data/projects_gibbons/home/neffra/anaconda2/bin/python

import sys, getopt
import time
import numpy as np
import scipy as sp
import pandas as pd
import pysam
import subprocess
import os

def main(argv):
   	v_com = ''
	v_alt = ''
	v_ref = ''
	
	try:
		opts, args = getopt.getopt(argv,"c:a:r:",["common=","alt=", "ref="])
   	except getopt.GetoptError:
      		print 'compare_vcfs.py -c <common.vcf> -a <alt.vcf> -r <ref.vcf>'
      		sys.exit(2)
   	for opt, arg in opts:
      		if opt == '-h':
         		print 'compare_vcfs.py -c <common.vcf> -a <alt.vcf> -r <ref.vcf>'
         		sys.exit()
      		elif opt in ("-c", "--common"):
         		v_com = arg
      		elif opt in ("-a", "--alt"):
         		v_alt = arg
		elif opt in ("-r", "--ref"):
			v_ref = arg
		else:
			assert False, "unhandled option"
	makeVCFvenn(v_com, v_alt, v_ref)

def makeVCFvenn(v_com, v_alt, v_ref):
	
	# MakeVCFvenn
	#
	# takes in the common, alternate, and patch vcf file and creates a venn diagram of the overlap, as well
	# as gives the numbers of each overlap. Returns the lines in each vcf file for the overlaps.

	print v_com 
	print v_alt 
	print v_ref

	# subset files with only important columns
	import os.path
	if False == os.path.isfile(v_com + '.sites'):
		subprocess.check_output('cat ' + v_com + ' | grep -v "#" | cut -f1-2,4-5 > ' + v_com + '.sites', shell=True)
	if False == os.path.isfile(v_alt + '.sites'):
		subprocess.check_output('cat ' + v_alt + ' | grep -v "#" | cut -f1-2,4-5 > ' + v_alt + '.sites', shell=True)
	if False == os.path.isfile(v_ref + '.sites'):
		subprocess.check_output('cat ' + v_ref + ' | grep -v "#" | cut -f1-2,4-5 > ' + v_ref + '.sites', shell=True)
	
	print "Opened files. Now reading in..."
	
	#open vcf files into RAM as dataframes - only keep certain columns
	com_df = pd.read_csv(v_com + ".sites", sep="\t", header=None)
	alt_df = pd.read_csv(v_alt + ".sites", sep="\t", header=None)
	ref_df = pd.read_csv(v_ref + ".sites", sep="\t", header=None)

	print "Doing the comparisons."

	#do the comparisons
	alt_s = frozenset(zip(alt_df[0],alt_df[1]))
	com_s = frozenset(zip(com_df[0],com_df[1]))
	ref_s = frozenset(zip(ref_df[0],ref_df[1]))

	results = dict()
	results['alt_com_noref'] = pd.DataFrame(list(alt_s.intersection(com_s).difference(ref_s)))
	results['ref_com_alt'] = pd.DataFrame(list(ref_s.intersection(com_s).intersection(alt_s)))
	results['alt_only'] = pd.DataFrame(list(alt_s.difference(com_s).difference(ref_s)))
	results['com_only'] = pd.DataFrame(list(com_s.difference(alt_s).difference(ref_s)))
	
	print "Comparisons done. Now getting original files back."

	#now, let's get the original files back
	alt_df.reset_index(inplace=True)
	alt_df.set_index([alt_df[0], alt_df[1]], inplace=True)
	alt_only_list = frozenset(alt_df.loc[zip(results['alt_only'][0], results['alt_only'][1])]['index'])
	alt_all_list = frozenset(alt_df.loc[zip(results['ref_com_alt'][0], results['ref_com_alt'][1])]['index'])
	alt_noref_list = frozenset(alt_df.loc[zip(results['alt_com_noref'][0], results['alt_com_noref'][1])]['index'])
	
	com_df.reset_index(inplace=True)
	com_df.set_index([com_df[0], com_df[1]], inplace=True)
	com_only_list = frozenset(com_df.loc[zip(results['com_only'][0], results['com_only'][1])]['index'])
	com_all_list = frozenset(com_df.loc[zip(results['ref_com_alt'][0], results['ref_com_alt'][1])]['index'])
	com_noref_list = frozenset(com_df.loc[zip(results['alt_com_noref'][0], results['alt_com_noref'][1])]['index'])
	
	print "Writing alt files."

	alt_file = open(v_alt, 'rb')
	alt_only_file = open(v_alt + ".alt_only.vcf", "wb")
	alt_all_file = open(v_alt + ".alt_all.vcf", "wb")
	alt_noref_file = open(v_alt + ".alt_com_noref.vcf", "wb")
	count = 0
	for i in alt_file:
	    if "#" in i: 
	        continue
	    if count in alt_only_list:
	        alt_only_file.write(i)
	    if count in alt_all_list:
		alt_all_file.write(i)
	    if count in alt_noref_list:
		alt_noref_file.write(i)
	    if (count % 1000) == 0:
		print "Read %s lines." % (str(count))
	    count += 1
	alt_only_file.close()
	alt_all_file.close()
	alt_noref_file.close()
	alt_file.close()
	
	print "Writing com files."

	com_file = open(v_com, 'rb')
	com_only_file = open(v_com + ".com_only.vcf", "wb")
	com_all_file = open(v_com + ".com_all.vcf", "wb")
	com_noref_file = open(v_com + ".com_alt_noref.vcf", "wb")
	count = 0
	for i in com_file:
	    if "#" in i: 
	        continue
	    if count in com_only_list:
	        com_only_file.write(i)
	    if count in com_all_list:
		com_all_file.write(i)
	    if count in com_noref_list:
		com_noref_file.write(i)
	    count += 1
	com_only_file.close()
	com_all_file.close()
	com_noref_file.close()
	com_file.close()
	
	print "Done!"	
	# we're done!

# run the program if called from the command line
if __name__ == "__main__":
   main(sys.argv[1:])
