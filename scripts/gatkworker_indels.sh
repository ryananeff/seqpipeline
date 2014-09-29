#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx512g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T VariantRecalibrator \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
-input $1 \
-nt 16 \
--maxGaussians 4 \
-resource:mills,known=true,training=true,truth=true,prior=12.0 ~/training/mills.afrgh19.vcf \
--mode INDEL -an QD -an MQRankSum -an ReadPosRankSum -an FS -an DP -an InbreedingCoeff \
-recalFile $1.recal \
-tranchesFile $1.tranches;

gatk -T ApplyRecalibration \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
-input $1 \
--ts_filter_level 99.0 \
-nt 16 \
--mode INDEL \
-recalFile $1.recal \
-tranchesFile $1.tranches \
-o $1.VQSRed.vcf;
