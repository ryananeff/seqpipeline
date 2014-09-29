#!/bin/sh
# ~/tools/bwa/bwa sampe -a 486 -P ~/new_ref_seq/alt_sequence2.fa \
# ~/na19914/NA19914_ASW_1_new.sai ~/na19914/NA19914_ASW_2_new.sai \
# ~/na19914/SRR350098_1.filt.fastq ~/na19914/SRR350098_2.filt.fastq > ~/na19914/NA19914_ASW_sampe_new.sam;

# samtools view -bS ~/na19914/NA19914_ASW_sampe_new.sam > ~/na19914/NA19914_ASW_sampe_new.bam;

# samtools sort ~/na19914/NA19914_ASW_sampe_new.bam ~/NA19914_ASW_sampe_new.sort;

#java -Xmx8g -jar ~/tools/picard-tools/MarkDuplicates.jar \
#I=NA19914_ASW_sampe_new.sort.bam \
#O=NA19914_ASW_sampe_new.sort.PCR.bam \
#M=PCRinfoASW_new \
#ASSUME_SORTED=true REMOVE_DUPLICATES=true \
#VALIDATION_STRINGENCY=LENIENT;

samtools index NA19914_ASW_sampe_new.sort.PCR.bam;

samtools fixmate NA19914_ASW_sampe_new.sort.PCR.bam NA19914_ASW_mate.bam &
samtools fixmate NA19914_hg19_pe.sort.bam.PCR.bam NA19914_hg19_mate.bam;

java -Xmx8g -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I=~/na19914/NA19914_ASW_mate.bam \
O=~/na19914/NA19914_ASW_mate_rg.bam \
RGID=1 \
RGLB=NA19914_1000g_ASW \
RGPL=Illumina \
RGSM=NA19914 \
RGPU=A \
VALIDATION_STRINGENCY=LENIENT &

java -Xmx8g -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I=~/na19914/NA19914_hg19_mate.bam \
O=~/na19914/NA19914_hg19_mate_rg.bam \
RGID=1 \
RGLB=NA19914_1000g_hg19 \
RGPL=Illumina \
RGSM=NA19914 \
RGPU=A \
VALIDATION_STRINGENCY=LENIENT &
