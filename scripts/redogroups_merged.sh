#!/bin/sh

# add back read groups to merged file
java -Xmx30g -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$1"_merged.bam \
O="$1"_merged.regrouped.bam \
RGID=1 \
RGLB="$1" \
RGPL=Illumina \
RGSM="$1" \
RGPU=merged_hs \
VALIDATION_STRINGENCY=LENIENT;
	 

