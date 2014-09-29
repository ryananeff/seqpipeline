#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo "Detected environment file!\nRemember that this file defines the reference that should be used in later steps."       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
filename=$1
outname=$2

#########################################

echo "$(date): sorting paired-end fastq by query order"
samtools sort -n "$filename" "$outname".qsort
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during sort by query"; exit 1; else echo "$(date): sorting by query done"; fi

echo "$(date): unaligning bam files..."
bedtools bamtofastq -i "$outname".qsort.bam -fq "$outname"_1.fastq -fq2 "$outname"_2.fastq
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during unalign"; exit 1; else echo "$(date): unaligning BAMs done"; fi


