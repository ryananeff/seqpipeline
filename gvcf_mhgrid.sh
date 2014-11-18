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
