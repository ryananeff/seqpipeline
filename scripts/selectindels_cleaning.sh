#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T VariantsToTable \
-R ~/references/GRCh38_noalt.fa \
--variant "$1" \
-o "$1".cleaned.tsv \
-SMA -AMD \
-F CHROM -F POS -F REF -F ALT -F ID -F QUAL -F MQ -F DP -F AF -F AN -F VQSLOD -F QD -GF GT -GF AD
