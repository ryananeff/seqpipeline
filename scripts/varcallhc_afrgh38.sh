#!/bin/bash

name=$1

# redo the readgroups... yes again
java -Xmx16g -XX:ParallelGCThreads=4 -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$1" \
O="$1"_rg.bam \
RGID=1 \
RGLB="${name:0:7}" \
RGPL=Illumina \
RGSM="${name:0:7}" \
RGPU=hs \
TMP_DIR="/data/projects_gibbons/scratch/test/"\
VALIDATION_STRINGENCY=LENIENT;

# index new bam
samtools index "$1"_rg.bam

# HaplotypeCaller SNPs and indels - recalibrated on HapMap
~/tools/java7/bin/java -Xmx30g -Djava.io.tmpdir="/data/projects_gibbons/scratch/test/" -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -R /data/projects_gibbons/home/neffra/references/alt_sequence-071114_192603_compiled.fa \
   -T HaplotypeCaller \
   -I "$1" \
   -o "$1".HC.afrgh38.raw.gvcf \
   -ERC GVCF \
   --variant_index_type LINEAR\
   --variant_index_parameter 128000\
   -nct 4;


