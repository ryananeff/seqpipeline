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
vcffile2="$2"
intersect="$3"

###########################################

echo "$(date): GATK generating union set"
java -Xmx16g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T CombineVariants \
--variant:hg38 "$vcffile" \
--variant:afrg "$vcffile2" \
-o union.vcf;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during CombineVariants GATK"; exit 1; else echo "$(date): CombineVariants done."; fi

echo "$(date): GATK selecting intersection"
java -Xmx16g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T SelectVariants \
--variant union.vcf \
-select 'set == "Intersection"' \
-o "$intersect".vcf;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SelectVariants GATK"; exit 1; else echo "$(date): SelectVariants done."; fi

# done (yes!)


