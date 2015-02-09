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
interval="$2"
name="$vcffile"_selected.out

###########################################

# select SNPs only for future analysis
echo "$(date): GATK selecting SNPs..."
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T SelectVariants \
--variant "$vcffile" \
-o "$name".vcf \
-L "$interval";
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SelectVariants GATK"; exit 1; else echo "$(date): SelectVariants done."; fi

# done (yes!)


