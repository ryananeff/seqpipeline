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
varlist="$1"
threads="$2"
memory="$3"
name="$4"
interval="$5"

###########################################

echo "$(date): GATK genotyping all GVCFs; This may take some time..."
java -Xmx"$memory" -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
--disable_auto_index_creation_and_locking_when_reading_rods \
--sample_rename_mapping_file "$varlist" \
-R "$reference" \
-T GenotypeGVCFs \
-L "$interval" \
-o "$name".genotypes.vcf \
`cat "$varlist" | while read i a; do echo -ne "-V:$a $i "; done`;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during GenotypeGVCFs GATK"; exit 1; else echo "$(date): VCF creation done! Huzzah!"; fi

