#!/bin/sh
~/tools/bwa/bwa sampe -a 486 -P ~/new_ref_seq/alt_sequence2.fa \
~/na19914/NA19914_ASW_1_new.sai ~/na19914/NA19914_ASW_2_new.sai \
~/na19914/SRR350098_1.filt.fastq ~/na19914/SRR350098_2.filt.fastq > ~/na19914/NA19914_ASW_sampe_new.sam;

samtools view -bS ~/na19914/NA19914_ASW_sampe_new.sam > ~/na19914/NA19914_ASW_sampe_new.bam;

samtools sort ~/na19914/NA19914_ASW_sampe_new.bam ~/NA19914_ASW_sampe_new.sort;

java -Xmx8g -jar ~/tools/picard-tools/MarkDuplicates.jar \
I=~/na19914/NA19914_ASW_sampe_new.sort.bam \
O=~/na19914/NA19914_ASW_sampe_new_sort.PCR.bam \
M=PCRinfoASW_new \
ASSUME_SORTED=true REMOVE_DUPLICATES=true \
VALIDATION_STRINGENCY=LENIENT;


