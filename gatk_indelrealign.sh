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
left=$1
right=$2
sample=$3
lane=$4
name="$sample"_"$lane"

###########################################

# generate targets for indel realignment (to keep things consistent)
echo "$(date): GATK generating targets for indel realignment..."
java -Xmx8g -Djava.io.tmpdir="/scratch" -jar $home/tools/gatk32/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R "$reference" \
   -I "$name".sort.bam \
   -o "$name".mated.bam.intervals;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during target generation GATK"; exit $?; else echo "$(date): GATK target generation done"; fi

# indel realignment
echo "$(date): GATK realigning indels..."
java -Xmx8g -Djava.io.tmpdir="/scratch" -jar $home/tools/gatk32/GenomeAnalysisTK.jar \
   -T IndelRealigner \
   -R "$reference" \
   -I "$name".sort.bam \
   -targetIntervals "$name".mated.bam.intervals \
   -o "$name".realigned.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during indel realignment GATK"; exit $?; else echo "$(date): GATK indel realignment done"; fi

# now we need to merge by lane (can't be handled inside this program)

