#!/bin/sh

#samtools index "$1"_"$2"_mate.rg.bam;
#~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
#   -T RealignerTargetCreator \
#   -R "$3" \
#   -I "$1"_"$2"_mate.rg.bam \
#   -o "$1"_"$2"_mate.bam.intervals;
   
#~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
#-T IndelRealigner \
#-R "$3" \
#-I "$1"_"$2"_mate.rg.bam \
#-o "$1"_"$2"_realigned.bam \
#-targetIntervals "$1"_"$2"_mate.bam.intervals;

#~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
#   -R "$3" \
#   -T UnifiedGenotyper \
#   -I "$1"_"$2"_realigned.bam \
#   -o "$1"_"$2"_snps.raw.vcf \
#   -stand_call_conf 50.0 \
#   -stand_emit_conf 10.0 \
#   -dcov 200 \
#   -nt 2;

~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R ~/references/"$2".fa \
   -T HaplotypeCaller \
   -I "$1"_"$2"_realigned.bam \
   -o "$1"_"$2"_haplotypes.raw.vcf \
   -stand_call_conf 50.0 \
   -stand_emit_conf 10.0 \
   -dcov 200 &

#~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
#-T ClipReads \
#-R ~/references/"$2".fa \
#-I "$1"_"$2"_realigned.bam \
#-o "$1"_"$2"_clipped.bam \
#-CT "1-5,11-15" \
#-QT 10 &
