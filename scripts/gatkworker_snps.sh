#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar"

gatk -T VariantRecalibrator \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
-input $1 \
-nt 16 \
-resource:hapmap,known=true,training=true,truth=true,prior=15.0 ~/training/hapmap_3.3.afrgh19.vcf \
-resource:omni,known=false,training=true,truth=true,prior=12.0 ~/training/omni.afrgh19.vcf \
--mode SNP -an QD -an MQRankSum -an ReadPosRankSum -an FS -an InbreedingCoeff \
-recalFile $1.recal \
-tranchesFile $1.tranches;

gatk -T ApplyRecalibration \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
-input $1 \
--ts_filter_level 99.0 \
-nt 16 \
--mode SNP \
-recalFile $1.recal \
-tranchesFile $1.tranches \
-o $1.VQSRed.vcf;

