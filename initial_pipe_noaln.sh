#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo "Detected environment file!\nRemember that this file defines the reference that should be used in later steps."       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
#left=$1
#right=$2
#sample=$3
#lane=$4
#study=$5
name=$1

###########################################

# run new bwamem alignment for hg38 reference: use two threads and 8g of RAM (we're being hopeful here...)
#echo "$(date): starting bwamem alignment...";
#bwa mem -t 2 -w 100 -k 20 -M \
#	-R '@RG\tID:1\tSM:"$1"\LB:"$1"\tPL:Illumina\tPU:hs' \
#	"$reference" "$left" "$right" > "$name".sam;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during bwa-mem      "; exit 1; else echo "$(date): bwamem alignment done."; fi

# create bam file and sort it before writing
#echo "$(date): starting conversion to BAM...";
#samtools view -bS "$name".sam -o "$name".bam;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during samtools view"; exit 1; else echo "$(date): BAM conversion done."; fi

#echo "$(date): sorting BAM...";
#samtools sort "$name".bam "$name".sort;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during samtools sort"; exit 1; else echo "$(date): sorting bam done."; fi

# if all went well, remove the old files (we should only get here if there was zero exit statuses
#if [ -s "$name".sort.bam ]
#then echo "$(date): sorted BAM file found with non-zero size; continuing..."
#else echo "$(date): unexpected error: sorted BAM file is missing; exiting"; exit 2; fi
#echo "$(date): removing temporary files..."
#rm "$name".sam "$name".bam
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during temporary file removal"; exit 1; else echo "$(date): removed temporary SAM and BAM."; fi

# remove duplicates (picard)
#echo "$(date): starting duplicate marking..."
#java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $home/tools/picard-tools/MarkDuplicates.jar \
#I="$name".sort.bam \
#O="$name".rmdup.bam \
#M="$name".dupmetrics.txt \
#ASSUME_SORTED=true REMOVE_DUPLICATES=false \
#MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=60 \
#VALIDATION_STRINGENCY=LENIENT;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during duplicate removal"; exit 1; else echo "$(date): markduplicates done."; fi

# index bam
#echo "$(date): indexing duplicate-removed BAM..."
#samtools index "$name".rmdup.bam;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during samtools indexing post duplicate removal"; exit 1; else echo "$(date): indexing dup-rem BAM done."; fi

# picard fixmate to write coordinates
#echo "$(date): starting picardtools fixmateinfo..."
#java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $home/tools/picard-tools/FixMateInformation.jar \
#I="$name".rmdup.bam \
#O="$name".mated.bam \
#SO=coordinate \
#VALIDATION_STRINGENCY=LENIENT;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during picard fixmateinfo"; exit 1; else echo "$(date): fixmate done."; fi

# index bam
#echo "$(date): indexing mate-fixed BAM..."
#samtools index "$name".mated.bam;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during samtools indexing post fixmate"; exit 1; else echo "$(date): indexing fixmate BAM done."; fi

# add back read groups
#echo "$(date): adding back read groups..."
#java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $home/tools/picard-tools/AddOrReplaceReadGroups.jar \
#I="$name".mated.bam \
#O="$name".mated.rg.bam \
#RGID="$lane" \
#RGLB="$sample" \
#RGPL=Illumina \
#RGSM="$sample" \
#RGPU="$study" \
#VALIDATION_STRINGENCY=LENIENT;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during read group adding"; exit 1; else echo "$(date): adding readgroups done"; fi

# index bam again
#echo "$(date): indexing mate-rg BAM..."
#samtools index "$name".mated.rg.bam;
#if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during samtools index mate-rg"; exit 1; else echo "$(date): indexing mate-rg done."; fi

# generate targets for indel realignment (to keep things consistent)
echo "$(date): GATK generating targets for indel realignment..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R "$reference" \
   -I "$name".mated.rg.bam \
   -o "$name".mated.rg.bam.intervals;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during target generation GATK"; exit 1; else echo "$(date): GATK target generation done"; fi

# indel realignment
echo "$(date): GATK realigning indels..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T IndelRealigner \
   -R "$reference" \
   -I "$name".mated.rg.bam \
   -targetIntervals "$name".mated.rg.bam.intervals \
   -o "$name".realigned.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during indel realignment GATK"; exit 1; else echo "$(date): GATK indel realignment done"; fi

# now we need to merge by lane (can't be handled inside this program)

