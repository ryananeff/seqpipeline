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
snpfile="$1"
indelfile="$2"
out="$3"

###########################################

# combine SNP and indel calls into single set
echo "$(date): GATK combining SNPs from VQSR..."
java -Xmx8g -Djava.io.tmpdir="/scratch" -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T CombineVariants \
--filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED \
--assumeIdenticalSamples \
--variant "$snpfile" \
--variant "$indelfile" \
-o "$out".vcf;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during CombineVariants GATK"; exit 1; else echo "$(date): CombineVariants done."; fi

# done (yes!)


