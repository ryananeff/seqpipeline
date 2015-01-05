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
threads=$3
intlist=$4
name=$5

###########################################

echo "$(date): GATK generating genotyped VCF..."
java -Xmx"$memory" -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
--disable_auto_index_creation_and_locking_when_reading_rods \
--sample_rename_mapping_file "$varlist" \
-R "$reference" \
-T UnifiedGenotyper \
-o "$name".UG.discov.SNPs.vcf \
-nt "$threads" \
-L "$intlist" \
-gt_mode DISCOVERY \
`cat "$varlist" | while read i a; do echo -ne "-I:$a $i "; done`;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VCF genotyping"; exit 1; else echo "$(date): VCF genotyping done"; fi

