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
hapmap="$2"
omni="$3"
name="$vcffile"_snps

###########################################

# select SNPs only for future analysis
echo "$(date): GATK selecting SNPs..."
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T SelectVariants \
--variant "$vcffile" \
-o "$name".vcf \
-selectType SNP -selectType MNP;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SelectVariants GATK"; exit 1; else echo "$(date): SelectVariants done."; fi

# generate the error model for variant quality score recalibration
echo "$(date): GATK generating error model for recalibration of SNPs"
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T VariantRecalibrator \
-input "$name".vcf \
-resource:hapmap,known=true,training=true,truth=true,prior=15.0 "$hapmap" \
-resource:omni,known=false,training=true,truth=true,prior=12.0 "$omni" \
--mode SNP -an QD -an MQRankSum -an ReadPosRankSum -an FS -an InbreedingCoeff \
-recalFile "$name".recal \
-tranchesFile "$name".tranches;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VariantRecalibrator GATK"; exit 1; else echo "$(date): VariantRecalibrator done."; fi

# Apply the recalibration
echo "$(date): GATK applying VQSR to SNPs and filtering by tranches"
java -Xmx8g -Djava.io.tmpdir=$scratchdir -jar $GATK_HOME/GenomeAnalysisTK.jar \
-R "$reference" \
-T ApplyRecalibration \
-input "$name".vcf \
-o "$name".VQSR.vcf \
--mode SNP \
--ts_filter_level 99.0 \
-recalFile "$name".recal \
-tranchesFile "$name".tranches;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during VariantRecalibrator GATK"; exit 1; else echo "$(date): VariantRecalibrator done."; fi

# done (yes!)


