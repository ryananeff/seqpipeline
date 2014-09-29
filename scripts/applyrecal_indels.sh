#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx512g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T ApplyRecalibration \
-R ~/references/GRCh38_noalt.fa \
-input 63samples_combinedgenotyping.vcf.only_indels.vcf \
--ts_filter_level 99.0 \
-o 63samples_combinedgenotyping.vcf.only_indels.VQSRed.vcf \
-nt 16 \
--mode INDEL \
-recalFile recal_63gvcfs.indel.recal \
-tranchesFile tranches_63gvcfs.indel.tranches;
