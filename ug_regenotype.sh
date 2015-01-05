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
varlist=$1
memory=$2
sitesf=$3
name=$4

###########################################

echo "$(date): GATK generating regenotyped VCF..."
java -Xmx"$memory" -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
--disable_auto_index_creation_and_locking_when_reading_rods \
--sample_rename_mapping_file "$varlist" \
-R "$reference" \
-T UnifiedGenotyper \
-o "$name".UG.regen.SNPs.vcf \
-L "$sitesf" \
--alleles "$sitesf" \
-gt_mode GENOTYPE_GIVEN_ALLELES \
`cat "$varlist" | while read i a; do echo -ne "-I:$a $i "; done`;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VCF regenotyping"; exit 1; else echo "$(date): VCF regenotyping done"; fi

