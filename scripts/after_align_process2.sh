#!/bin/bash

echo $SHELL > /dev/stderr

# create bam file and sort it before writing
samtools view -bS "$1"_bwamem_hg38_ALLalign.sam -o "$1"_bwamem_hg38_ALLalign.bam;
samtools sort "$1"_bwamem_hg38_ALLalign.bam "$1"_bwamem_hg38_ALLalign.sort;

if [ -f "$1"_bwamem_hg38_ALLalign.sort.bam ]
then
	rm "$1"_bwamem_hg38_ALLalign.sam "$1"_bwamem_hg38_ALLalign.bam
fi
