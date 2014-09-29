#!/bin/sh

# run new bwamem alignment for hg38 reference
~/tools/bwa-0.7.8/bwa mem -t 4 -w 100 -k 20 -P -M \
-R '@RG\tID:1\tSM:"$1"\tLB:"$1"\tPL:Illumina\tPU:hs' \
~/references/hg38.fa \
"$1"_1.filt.fastq \
"$1"_2.filt.fastq > "$1"_bwamem_hg38.sam;

# create bam file and sort it before writing
samtools view -bS "$1"_bwamem_hg38.sam -o "$1"_bwamem_hg38.bam;
samtools sort "$1"_bwamem_hg38.bam "$1"_bwamem_hg38.sort;

# remove duplicates (picard)
java -Xmx8g -jar ~/tools/picard-tools/MarkDuplicates.jar \
I="$1"_bwamem_hg38.sort.bam \
O="$1"_bwamem_hg38.rmdup.bam \
M=PCRinfohg38_bwamem \
ASSUME_SORTED=true REMOVE_DUPLICATES=true \
VALIDATION_STRINGENCY=LENIENT;

# index bam
samtools index "$1"_bwamem_hg38.rmdup.bam;

# fixmate to write coordinates
samtools fixmate "$1"_bwamem_hg38.rmdup.bam "$1"_bwamem_hg38.mate.bam;

# add back read groups
java -Xmx8g -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$1"_bwamem_hg38.mate.bam \
O="$1"_bwamem_hg38.mate_rg.bam \
RGID=1 \
RGLB="$1" \
RGPL=Illumina \
RGSM="$1" \
RGPU=hs \
VALIDATION_STRINGENCY=LENIENT ;

# index bam again
samtools index "$1"_bwamem_hg38.mate_rg.bam;

# gatk steps

# generate targets for indel realignment (to keep things consistent)
~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R ~/references/hg38.fa \
   -I "$1"_bwamem_hg38.mate_rg.bam \
   -o "$1"_bwamem_hg38.mate_rg.bam.intervals;

# indel realignment
~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R ~/references/hg38.fa \
-I "$1"_bwamem_hg38.mate_rg.bam \
-targetIntervals "$1"_bwamem_hg38.mate_rg.bam.intervals \
-o "$1"_bwamem_hg38.realigned.bam;

# now things need to be merged with samtools merge (will provide file to do this)


