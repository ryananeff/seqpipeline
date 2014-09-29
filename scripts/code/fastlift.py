#!/bin/sh

import numpy as np
import pandas as pd
import scipy as sp
import sys

import HTSeq as ht
import itertools
import time

from mrjob.job import MRJob

ref_dir = '/media/ryan/RyanNeffBioinformatics/phenom/Data/references/'
changevcf_dir = '/media/ryan/RyanNeffBioinformatics/updated_tools/'
vcf_pattern = "_ASW_complete.vcf"

class LiftOverToAlternate(MRJob):
	
	def steps(self):
		# the steps in the map-reduce process
			thesteps = [ self.mr(mapper=self.sequence_mapper, reducer=self.sequence_collector) ]
			return thesteps
	
	def sequence_mapper(self,_,chr_name):
		vcfr = ht.VCF_Reader(changevcf_dir + chr_name + vcf_pattern)
		vcfr.parse_meta()
		vcfr.make_info_dict()
		
		refwalker = ht.FastaReader(ref_dir + chr_name + "_hg19.fa")
		for seq in refwalker:
			chr1=seq
			break
		sequence = list(str(chr1.seq))
		
		# let's make a new reference sequence
		chr_size = len(sequence)
		score = 4900 # totally arbitrary
		current_delta = 0
		liftover_info = []
		last_lift_ref = 1
		last_lift_alt = 1
		num_chains = 1
		totaldone = 0
		totallift = 0
		error_count = 0
		for vc in vcfr:
			if str(vc.chrom) != chr_name:
				break
			totaldone += 1
			delta = len(vc.alt) - len(vc.ref) #did we move the sequence?
			vcpos = int(vc.pos.start)
			refpos = vcpos + current_delta - 1 #let's calculate where we need to go to match the ref position
			if vc.ref[0] == '.':
				delta += 1
			if vc.alt[0] == '.':
				delta -= 1
			if vc.ref[0].lower() != sequence[refpos][0].lower():
				#sys.stderr.write(str(chr_name) + ": Error at variant # " + str(totaldone) +"\n")
            			#sys.stderr.write("\ttotal lifted: " +str(len(liftover_info))+"\n")
           			#sys.stderr.write("\texpect: " + str(sequence[refpos][0])+"\n")
            			#sys.stderr.write("\tgot: " + str(vc.ref[0])+"\n")
            			#sys.stderr.flush()
            			error_count += 1
			if delta == 0: # if we have a 1:1 substitution
				if len(vc.ref) == 1: # if we are only dealing with a one base substitution
					sequence[refpos] = vc.alt[0]
				else:
					sequence[refpos:(refpos+len(vc.ref))] = list(vc.alt)
			else: # if we are dealing with net addition / subtraction: do it the slow way
				sequence[refpos:(refpos+len(vc.ref))] = list(vc.alt)
				newpos = delta + current_delta + vcpos
				line_info = {'id':num_chains, 'chain':[score,chr_name,chr_size,'.',last_lift_ref, vcpos, chr_name, chr_size,'.',last_lift_alt,newpos]}
				liftover_info.append(line_info)
				last_lift_ref = vcpos
				last_lift_alt = newpos
				num_chains += 1
				current_delta += delta
				totallift += 1
		sys.stderr.write(str(chr_name) + ": Error count: " + str(error_count) + "\n")
	    	sys.stderr.write(str(chr_name) + ": Total variants: " + str(totaldone) + "\n")
	    	sys.stderr.flush()
	    	new_chr_size = len(sequence)
		sequence = ''.join(sequence)
		yield "hg19", (chr_name, sequence, liftover_info, new_chr_size)
		
	def sequence_collector(self, align, values):
		alt_file = open(changevcf_dir + "alt_sequence" + time.strftime("%m%d%y_%H%M%S") ,"w")
		lift_file = open(changevcf_dir + "liftover-" + time.strftime("%m%d%y_%H%M%S") ,"w")
		for value in values:
			(chr_name, seq_string, liftover_info, new_chr_size) = value
			fasta_seq = ht.Sequence(seq_string, name=chr_name)
			fasta_seq.write_to_fasta_file(alt_file)
			for line in liftover_info:
				line['chain'][7] = new_chr_size
				liftstr = '\t'.join(['chain', '\t'.join(str(e) for e in line['chain'])]) + "\n"
				lift_file.write(liftstr)
		alt_file.close()
		lift_file.close()
		yield "Success"
			
#Below MUST be there for things to work
if __name__ == '__main__':
    LiftOverToAlternate.run()
			
			
			
		
		
