#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f ENV ];
then
    echo "Detected environment file!\nRemember that this file defines the reference that should be used in later steps."       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
sample=$1
name="$sample"_merged

#########################################

for i in "$sample"_*.realigned.bam; do echo $i; done > "$sample"_to_merge

echo "$(date): merging BAM files..."
java -Xmx8g -Djava.io.tmpdir="$scratchdir" -jar $home/tools/picard-tools/MergeSamFiles.jar \
`cat "$sample"_to_merge | while read i; do echo -ne "INPUT=$i "; done` \
OUTPUT="$name".bam \
ASSUME_SORTED=TRUE MERGE_SEQUENCE_DICTIONARIES=TRUE VALIDATION_STRINGENCY=LENIENT;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during merge"; exit 1; else echo "$(date): merging BAMs done"; fi


