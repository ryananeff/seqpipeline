#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo -ne "Detected environment file!\nRemember that this file defines the reference that should be used in later steps.\n"       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
alt="$1" # the alternate ref vcf file
common="$2" # the common ref vcf file
validation="$3" # validation SNPs
name="$4"

###########################################

echo "$(date): GATK comparing variant sets"
java -Xmx16g -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T VariantEval \
-o "$name".eval.gatkreport \
--sample "$name" \
--eval:alt "$alt" \
--eval:common "$common" \
--dbsnp "$validation";
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during GATK VariantEval"; exit 1; else echo "$(date): GATK VariantEval done"; fi

