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
name="$1"_merged.bam

###########################################

# index bam
echo "$(date): indexing merged BAM"
samtools index "$name";
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during indexing merged BAM"; exit 1; else echo "$(date): indexing merged BAM done."; fi

# redo read groups
# add back read groups
echo "$(date): adding back read groups..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $home/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$name" \
O="$name".rg.bam \
RGID="1" \
RGLB="$1" \
RGPL=Illumina \
RGSM="$1" \
RGPU="$1" \
VALIDATION_STRINGENCY=LENIENT;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during read group adding"; exit 1; else echo "$(date): adding readgroups done"; fi

echo "$(date): indexing merged BAM readgrouped"
samtools index "$name".rg.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during indexing merged BAM with rg"; exit 1; else echo "$(date): indexing merged rg BAM done."; fi


echo "$(date): GATK generating GVCF..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T HaplotypeCaller \
-I "$name".rg.bam \
-o "$name".HC.raw.gvcf \
-ERC GVCF \
--variant_index_type LINEAR \
--variant_index_parameter 128000;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during GVCF generation GATK"; exit 1; else echo "$(date): GVCF generation done"; fi

