#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T SelectVariants \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
--variant "$1" \
-o "$1".indels.vcf \
-selectType INDEL \
-nt 16;
