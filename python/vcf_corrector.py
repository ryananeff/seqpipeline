#!/usr/bin/env python
"""Fix GenomeStudio VCF files. Adapted from public scripts by Ryan Neff

Requires:

bx-python: https://bitbucket.org/james_taylor/bx-python/wiki/Home

You also need the genome reference file in 2bit format:
http://genome.ucsc.edu/FAQ/FAQformat.html#format7
using faToTwoBit:
http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/

Usage:
  vcf_corrector.py vcf_file <UCSC reference file in 2bit format>

"""
import os
import sys
import subprocess

from bx.seq import twobit

def main(vcf_file, ref_file):
    base_dir = os.getcwd()
    fix_nonref_positions(vcf_file, ref_file)

def fix_line_problems(parts):
    """Fix problem alleles and reference/variant bases in VCF line.
    """
    varinfo = parts[:9]
    genotypes = []
    # replace haploid calls
    for x in parts[9:]:
        if len(x) == 1:
            x = "./."
        genotypes.append(x)
    if varinfo[3] == "0": varinfo[3] = "N"
    if varinfo[4] == "0": varinfo[4] = "N"
    return varinfo, genotypes

def fix_vcf_line(parts, ref_base):
    """Orient VCF allele calls with respect to reference base.

    Handles cases with ref and variant swaps. strand complements.
    """
    swap = {"1/1": "0/0", "0/1": "0/1", "0/0": "1/1", "./.": "./."}
    complements = {"G": "C", "A": "T", "C": "G", "T": "A", "N": "N"}
    acceptable_keys = ['G','C','A','T','N','0']
    varinfo, genotypes = fix_line_problems(parts)
    ref, var = varinfo[3:5]
    # print ref, var
    # non-reference regions or non-informative, can't do anything
    if (ref not in acceptable_keys) | (var not in acceptable_keys):
	print "Could not convert keys ref: " + ref + ", var: " + var
        return None
    if ref_base in [None, "N"] or set(genotypes) == set(["./."]):
        varinfo = None
    # matching reference, all good
    elif ref_base == ref:
        assert ref_base == ref, (ref_base, parts)
    # swapped reference and alternate regions
    elif ref_base == var or ref in ["N", "0"]:
        varinfo[3] = var
        varinfo[4] = ref
        genotypes = [swap[x] for x in genotypes]
    # reference is on alternate strand
    elif ref_base != ref and complements[ref] == ref_base:
        varinfo[3] = complements[ref]
        varinfo[4] = complements[var]
    # unspecified alternative base
    elif ref_base != ref and var in ["N", "0"]:
        varinfo[3] = ref_base
        varinfo[4] = ref
        genotypes = [swap[x] for x in genotypes]
    # swapped and on alternate strand
    elif ref_base != ref and complements[var] == ref_base:
        varinfo[3] = complements[var]
        varinfo[4] = complements[ref]
        genotypes = [swap[x] for x in genotypes]
    else:
       print "Did not associate ref {0} with line: {1}".format(
           ref_base, varinfo)
    if varinfo is not None:
    	if varinfo[4] == 'N': #swap genotypes if the alternate allele is N
		genotypes = [swap[x] for x in genotypes]
   	return varinfo + genotypes

def fix_nonref_positions(in_file, ref_file):
    """Fix Genotyping VCF positions where the bases are all variants.

    The plink/pseq output does not handle these correctly, and
    has all reference/variant bases reversed.
    """
    ignore_chrs = ["23", "24", "25"]
    ref2bit = twobit.TwoBitFile(open(ref_file))
    out_file = apply("{0}-fix{1}".format, os.path.splitext(in_file))

    with open(in_file) as in_handle:
        with open(out_file, "w") as out_handle:
            for line in in_handle:
                if line.startswith("#"):
                    out_handle.write(line)
                else:
                    parts = line.rstrip("\r\n").split("\t")
                    pos = int(parts[1])
                    # handle chr/non-chr naming
                    if parts[0] not in ref2bit.keys():
                        parts[0] = parts[0].replace("chr", "")
                    ref_base = None
                    if parts[0] not in ignore_chrs:
                        try:
                            ref_base = ref2bit[parts[0]].get(pos-1, pos).upper()
                        except Exception, msg:
                            # off the end of the chromosome
                            if str(msg).startswith("end before start"):
                                print msg
                            else:
                                print parts
                                raise
                    parts = fix_vcf_line(parts, ref_base)
                    if parts is not None:
                        out_handle.write("\t".join(parts) + "\n")
        return out_file

if __name__ == "__main__":
    if len(sys.argv) != 3: #hack on the part of the author
        print "Incorrect arguments"
        print __doc__
        sys.exit(1)
    main(*sys.argv[1:])

