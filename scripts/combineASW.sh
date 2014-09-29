#!/bin/bash
~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-R ~/references/GRCh38_noalt.fa \
-T CombineVariants \
-nt 12 \
-o final_asw.hg38.correctfiltered.vcf \
--filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED \
--genotypemergeoption UNIQUIFY \
--mergeInfoWithMaxAC \
--setKey "ASW_hapmap" \
--variant:vcf ASW_majority_correctfiltered.vcf  \
--variant:vcf 63samp_snps_correctfiltered.vcf \
--variant:vcf 63samp_indels_correctfiltered.vcf;
