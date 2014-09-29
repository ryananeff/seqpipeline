#!/bin/bash
~/tools/java7/bin/java -Xmx96g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-R ~/old_analysis/new_ref_seq/alt_sequence2.fa \
-T GenotypeGVCFs \
-nt 32 \
-o S1304120MHM_HC_combined_genotypes_350_samples.raw.vcf \

