#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T SelectVariants \
-R ~/references/GRCh38_noalt.fa \
--variant "$1" \
-o "$1".snps.cleanedByVQSR.vcf \
-selectType SNP -selectType MNP \
--excludeFiltered \
-maxAltAlleles 1 \
-nt 16;
