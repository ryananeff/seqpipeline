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
sampfile="$2"
threads="$3"
name="$vcffile"_selectsamp

###########################################

# select SNPs only for future analysis
echo "$(date): GATK selecting SNPs..."
java -Xmx16g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T SelectVariants \
--variant "$vcffile" \
`cat $sampfile | while read i; do echo -ne "-sn $i "; done` \
-nt "$threads" \
-o "$name".vcf;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SelectVariants GATK"; exit 1; else echo "$(date): SelectVariants done."; fi

# done (yes!)


