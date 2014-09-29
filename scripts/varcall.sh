#!/bin/sh

samtools index "$1"

# UnifiedGenotyper SNPs and indels - recalibrated on HapMap
~/tools/java7/bin/java -Xmx30g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/hg38.fa \
   -T UnifiedGenotyper \
   -I "$1" \
   -o "$1".snps.indels.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 \
   -glm BOTH \
   -nt 4;



