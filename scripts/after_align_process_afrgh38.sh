#!/bin/bash

echo $SHELL > /dev/stderr

# create bam file and sort it before writing
samtools view -bS "$1"_bwamem_afrgh38.sam -o "$1"_bwamem_afrgh38.bam;
samtools sort "$1"_bwamem_afrgh38.bam "$1"_bwamem_afrgh38.sort;

samtools flagstat "$1"_bwamem_afrgh38.sort.bam > "$1"_flags_initial_afrgh38.txt;

# delete unnecessary files
rm "$1"_bwamem_afrgh38.sam "$1"_bwamem_afrgh38.bam; 

# remove duplicates (picard)
#if [ -f "$1"_bwamem_afrgh38.rmdup.bam ]
#then
#	echo "rmdup file exists, continuing..."
#else
	java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/tools/picard-tools/MarkDuplicates.jar \
	I="$1"_bwamem_afrgh38.sort.bam \
	O="$1"_bwamem_afrgh38.rmdup.bam \
	M="$1"_dupmetrics_bwamem_afrgh38 \
	TMP_DIR="/data/projects_gibbons/scratch/test/" \
	ASSUME_SORTED=true REMOVE_DUPLICATES=false \
	MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=60 \
	VALIDATION_STRINGENCY=LENIENT;
#fi

set -e;

# Picard's FixMate tool
java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/tools/picard-tools/FixMateInformation.jar \
I="$1"_bwamem_afrgh38.rmdup.bam \
O="$1"_bwamem_afrgh38.pfm.bam \
SO=coordinate \
TMP_DIR="/data/projects_gibbons/scratch/test/" \
VALIDATION_STRINGENCY=LENIENT;

# index bam
samtools index "$1"_bwamem_afrgh38.pfm.bam;

# fixmate to write coordinates - does NOT work!!!
# samtools fixmate "$1"_bwamem_afrgh38.rmdup.bam "$1"_bwamem_afrgh38.mate.bam;

# add back read groups
java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$1"_bwamem_afrgh38.pfm.bam \
O="$1"_bwamem_afrgh38.mate_rg.bam \
RGID=1 \
RGLB="$1" \
RGPL=Illumina \
RGSM="$1" \
RGPU=hs \
TMP_DIR="/data/projects_gibbons/scratch/test/"\
VALIDATION_STRINGENCY=LENIENT;

# index bam again
samtools index "$1"_bwamem_afrgh38.mate_rg.bam;

# gatk steps

# generate targets for indel realignment (to keep things consistent)
~/tools/java7/bin/java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir="/data/projects_gibbons/scratch/test/" \
   -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R /data/projects_gibbons/home/neffra/references/alt_sequence-071114_192603_compiled.fa \
   -I "$1"_bwamem_afrgh38.mate_rg.bam \
   -o "$1"_bwamem_afrgh38.mate_rg.bam.intervals;

# indel realignment
~/tools/java7/bin/java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir="/data/projects_gibbons/scratch/test/"  \
-jar ~/tools/gatk/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R /data/projects_gibbons/home/neffra/references/alt_sequence-071114_192603_compiled.fa \
-I "$1"_bwamem_afrgh38.mate_rg.bam \
-targetIntervals "$1"_bwamem_afrgh38.mate_rg.bam.intervals \
-o "$1"_bwamem_afrgh38.realigned.bam;

# now things need to be merged with samtools merge (will provide file to do this)


