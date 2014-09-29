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
vcffile="$1"
bamfile_list="$2"
interval="$3"
name="$vcffile"_phased

###########################################

# Apply the phasing
echo "$(date): GATK attempting read backed phasing"
java -Xmx8g -Djava.io.tmpdir="/scratch" -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T ReadBackedPhasing \
`cat "$bamfile_list" | while read i; do echo -ne "-I $i "; done` \
--variant "$vcffile" \
-o "$name".vcf \
-L "$interval" \
--phaseQualityThresh 20.0;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during ReadBackedPhasing GATK"; exit 1; else echo "$(date): ReadBackedPhasing done."; fi

# done (yes!)


