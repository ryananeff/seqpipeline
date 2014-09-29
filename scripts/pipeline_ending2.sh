
# moving on... let's call variants with UnifiedGenotyper and HaplotypeCaller
java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/hg19.fa \
   -T UnifiedGenotyper \
   -I NA19914_hg19_realigned.bam \
   -o NA19914_hg19_snps.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/new_ref_seq/alt_sequence2.fa \
   -T UnifiedGenotyper \
   -I NA19914_ASW_realigned.bam \
   -o NA19914_ASW_snps.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/hg19.fa \
   -T HaplotypeCaller \
   -I NA19914_hg19_realigned.bam \
   -o NA19914_hg19_haplotypes.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/new_ref_seq/alt_sequence2.fa \
   -T HaplotypeCaller \
   -I NA19914_ASW_realigned.bam \
   -o NA19914_ASW_haplotypes.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 &






