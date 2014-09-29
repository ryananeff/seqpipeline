#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T ApplyRecalibration \
-R ~/references/GRCh38_noalt.fa \
-input 63samples_combinedgenotyping.vcf.only_snps.vcf \
--ts_filter_level 99.0 \
-nt 16 \
--mode SNP \
-recalFile recal_63gvcfs.only_snps.recal \
-tranchesFile tranches_63gvcfs.only_snps.tranches \
-o 63samples_combinedgenotyping.vcf.only_snps.VQSRed.vcf;
