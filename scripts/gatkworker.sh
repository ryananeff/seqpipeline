#!/bin/bash

shopt -s expand_aliases

alias gatk="~/tools/java7/bin/java -Xmx512g -jar ~/tools/gatk3/GenomeAnalysisTK.jar"

gatk -T VariantRecalibrator \
-R ~/references/GRCh38_noalt.fa \
-input NA19625_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19700_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19703_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19704_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19707_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19711_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19712_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19713_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19818_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19819_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19834_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19835_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19900_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19901_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19904_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19908_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19916_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19917_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19920_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19921_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19982_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA19985_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20126_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20127_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20276_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20278_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20282_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20287_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20289_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20291_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20294_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20296_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20298_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20299_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20314_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20317_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20322_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20332_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20336_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20340_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20341_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20344_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20346_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20348_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-input NA20356_merged.bam_rg.bam.HC.raw.vcf.only_indels.vcf \
-nt 32 \
-resource:mills,known=true,training=true,truth=true,prior=12.0 ~/training/mills_hg38_noalt.vcf \
-resource:omni,known=false,training=true,truth=true,prior=12.0 ~/training/omni_hg38_noalt.vcf \
--mode INDEL -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ -an BaseQRankSum \
-recalFile recal_50vcfs.indel.recal \
-tranchesFile tranches_50vcfs.indel.tranches;
