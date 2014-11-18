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
combfile="$1"
memory="$2"
name="$3"
interval="$4"

###########################################

# combine passed set of GVCF files together for easier analysis
echo "$(date): GATK combining GVCFs; name: $name..."
java -Xmx"$memory" -Djava.io.tmpdir="$scratchdir" -jar $GATK_HOME/GenomeAnalysisTK.jar \
--disable_auto_index_creation_and_locking_when_reading_rods \
--sample_rename_mapping_file "$combfile" \
-R "$reference" \
-T CombineGVCFs \
`cat "$combfile" | while read i a; do echo -ne "-V:$a $i "; done` \
-L "$interval" \
-o "$name".gvcf.gz;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during CombineGVCFs GATK; name $name"; exit 1; else echo "$(date): CombineGVCFs done; name $name"; fi

# done (yes!)


