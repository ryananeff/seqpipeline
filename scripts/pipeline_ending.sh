java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R ~/references/hg19.fa \
   -I NA19914_hg19_rg_mate.bam \
   -o NA19914_hg19_mate.forIndelRealigner.intervals &

sleep 60;

java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R ~/new_ref_seq/alt_sequence2.fa \
   -I NA19914_ASW_rg_mate.bam \
   -o NA19914_ASW_mate.forIndelRealigner.intervals;

java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R ~/references/hg19.fa \
-I NA19914_hg19_rg_mate.bam \
-o NA19914_hg19_realigned.bam \
-targetIntervals NA19914_hg19_mate.forIndelRealigner.intervals &

sleep 60;

java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R ~/new_ref_seq/alt_sequence2.fa \
-I NA19914_ASW_rg_mate.bam \
-o NA19914_ASW_realigned.bam \
-targetIntervals NA19914_ASW_mate.forIndelRealigner.intervals ;

# let's see what this does

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T ClipReads \
-R ~/references/hg19.fa \
-I NA19914_hg19_realigned.bam \
-o NA19914_hg19_clipped.bam \
-CT "1-5,11-15" \
-QT 10 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T ClipReads \
-R ~/new_ref_seq/alt_sequence2.fa \
-I NA19914_ASW_realigned.bam \
-o NA19914_ASW_clipped.bam \
-CT "1-5,11-15" \
-QT 10 &

# moving on... let's call variants with UnifiedGenotyper and HaplotypeCaller
java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/hg19.fa \
   -T UnifiedGenotyper \
   -I NA19914_hg19_realigned.bam \
   -o NA19914_hg19_snps.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 100 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/new_ref_seq/alt_sequence2.fa \
   -T UnifiedGenotyper \
   -I NA19914_ASW_realigned.bam \
   -o NA19914_ASW_snps.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 100 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/hg19.fa \
   -T HaplotypeCaller \
   -I NA19914_hg19_realigned.bam \
   -o NA19914_hg19_haplotypes.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 100 &

java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/new_ref_seq/alt_sequence2.fa \
   -T HaplotypeCaller \
   -I NA19914_ASW_realigned.bam \
   -o NA19914_ASW_haplotypes.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 100 &






