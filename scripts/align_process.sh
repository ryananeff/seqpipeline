#!/bin/sh

# run new bwamem alignment for hg38 reference
~/tools/bwa-0.7.8/bwa mem \
-t 4 -w 100 -M -T 30 \
-R '@RG\tID:1\tSM:"$1"\tLB:"$1"\tPL:Illumina\tPU:hs' \
~/hg38_ref_070814_173730/AFRG1_reference_h38_070814.fa \
"$1"_1.filt.fastq \
"$1"_2.filt.fastq > "$1"_bwamem_afrgh38.sam;

