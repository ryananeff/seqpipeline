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
mills="$2"
name="$vcffile"_indels

###########################################

# select INDELs only for future analysis
echo "$(date): GATK selecting INDELs..."
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T SelectVariants \
--variant "$vcffile" \
-o "$name".vcf \
-selectType INDEL;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SelectVariants GATK"; exit 1; else echo "$(date): SelectVariants done."; fi

# generate the error model for variant quality score recalibration
echo "$(date): GATK generating error model for recalibration of INDELs"
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T VariantRecalibrator \
--maxGaussians 4 \
-input "$name".vcf \
-resource:mills,known=true,training=true,truth=true,prior=12.0 "$mills" \
--mode INDEL -an QD -an MQRankSum -an ReadPosRankSum -an FS -an DP -an InbreedingCoeff \
-recalFile "$name".recal \
-tranchesFile "$name".tranches;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VariantRecalibrator GATK"; exit 1; else echo "$(date): VariantRecalibrator done."; fi

# Apply the recalibration
echo "$(date): GATK applying VQSR to INDELs and filtering by tranches"
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T ApplyRecalibration \
-input "$name".vcf \
-o "$name".VQSR.vcf \
--mode INDEL \
--ts_filter_level 90.0 \
-recalFile "$name".recal \
-tranchesFile "$name".tranches;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VariantRecalibrator GATK"; exit 1; else echo "$(date): VariantRecalibrator done."; fi

# done (yes!)


