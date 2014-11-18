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
name=$1
intervals=$2 #added in only at AFRG step right now

###########################################

# generate targets for indel realignment (to keep things consistent)
echo "$(date): GATK generating targets for indel realignment..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T RealignerTargetCreator \
   -R "$reference" \
   -I "$name" \
   -o "$name".intervals;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during target generation GATK"; exit 1; else echo "$(date): GATK target generation done"; fi

# indel realignment
echo "$(date): GATK realigning indels..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T IndelRealigner \
   -R "$reference" \
   -I "$name" \
   -targetIntervals "$name".intervals \
   -o "$name".realigned.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during indel realignment GATK"; exit 1; else echo "$(date): GATK indel realignment done"; fi

echo "$(date): removing input file!"
rm "$name" #be careful!!!
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during input file removal"; exit 1; else echo "$(date): input file removal done"; fi


echo "$(date): GATK generating GVCF..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T HaplotypeCaller \
-I "$name".realigned.bam \
-o "$name".HC.raw.gvcf \
-L "$intervals" \
-ERC GVCF \
--variant_index_type LINEAR \
--variant_index_parameter 128000;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during GVCF generation GATK"; exit 1; else echo "$(date): GVCF generation done"; fi
