#!/bin/sh

alias qsub="qsub -V -S /bin/sh -cwd -q gibbons.q"
export PATH="~/tools/java7/bin:$PATH"
alias java="~/tools/java7/bin/java"

#cat files_to_process.txt | while read i; do
#qsub -N fixmate -o /dev/null -e fixmate.err samtools fixmate "$i"_hg19.sort.PCR.bam "$i"_hg19_mate.bam;
#qsub -N fixmate -o /dev/null -e fixmate.err samtools fixmate "$i"_ASW.sort.PCR.bam "$i"_ASW_mate.bam;
#done

#qsub -sync y -hold_jid fixmate echo "fixmate done!";

#cat files_to_process.txt | while read i; do
#qsub -N mateindex -o /dev/null -e mateindex.err samtools index "$i"_hg19_mate.bam;
#qsub -N mateindex -o /dev/null -e mateindex.err samtools index "$i"_ASW_mate.bam;
#done

#qsub -sync y -hold_jid mateindex echo "mate index done!";

#qsub -sync y -hold_jid rg -b y echo "rg done!";

cat files_to_process.txt | while read i; do
qsub -N hg19_ug -l mem_free=8G -pe make-dedicated 2 -o /dev/null -e final_"$i"_hg19.err ./final_steps_piped.sh "$i" hg19 ~/references/hg19.fa; 
qsub -N ASW_ug -l mem_free=8G -pe make-dedicated 2 -o /dev/null -e final_"$i"_ASW.err ./final_steps_piped.sh "$i" ASW ~/new_ref_seq/alt_sequence2.fa;
done

# qsub -N targets -o /dev/null -e "$i"_hg19_targets.err \
# ~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -T RealignerTargetCreator \
   # -R ~/references/hg19.fa \
   # -I "$i"_hg19_mate.bam \
   # -o "$i"_hg19_mate.bam.intervals;
# qsub -N targets -o /dev/null -e "$i"_ASW_targets.err \
# ~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -T RealignerTargetCreator \
   # -R ~/new_ref_seq/alt_sequence2.fa \
   # -I "$i"_ASW_mate.bam \
   # -o "$i"_ASW_mate.bam.intervals;
# done

# qsub -sync y -hold_jid targets echo "target acquired";

# cat files_to_process.txt | while read i; do
# qsub -N realign -o /dev/null -e "$i"_hg19_realign.err \
# ~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
# -T IndelRealigner \
# -R ~/references/hg19.fa \
# -I "$i"_hg19_mate.bam \
# -o "$i"_hg19_realigned.bam \
# -targetIntervals "$i"_hg19_mate.bam.intervals;
# qsub -N realign -o /dev/null -e "$i"_ASW_realign.err \
# ~/tools/java7/bin/java -Xmx4g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
# -T IndelRealigner \
# -R ~/new_ref_seq/alt_sequence2.fa \
# -I "$i"_ASW_mate.bam \
# -o "$i"_ASW_realigned.bam \
# -targetIntervals "$i"_ASW_mate.bam.intervals;
# done

# qsub -sync y -hold_jid realign echo "there you are";

# cat files_to_process.txt | while read i; do
# qsub -N cave_johnson -o /dev/null -e "$i"_hg19_ug.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -R ~/references/hg19.fa \
   # -T UnifiedGenotyper \
   # -I "$i"_hg19_realigned.bam \
   # -o "$i"_hg19_snps.raw.vcf \
   # -stand_call_conf 50.0 \
   # -stand_emit_conf 10.0 \
   # -dcov 200;
# qsub -N cave_johnson -o /dev/null -e "$i"_ASW_ug.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -R ~/new_ref_seq/alt_sequence2.fa \
   # -T UnifiedGenotyper \
   # -I "$i"_ASW_realigned.bam \
   # -o "$i"_ASW_snps.raw.vcf \
   # -stand_call_conf 50.0 \
   # -stand_emit_conf 10.0 \
   # -dcov 200;
# qsub -N GLaDoS -o /dev/null -e "$i"_hg19_hc.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -R ~/references/hg19.fa \
   # -T HaplotypeCaller \
   # -I "$i"_hg19_realigned.bam \
   # -o "$i"_hg19_haplotypes.raw.vcf \
   # -stand_call_conf 50.0 \
   # -stand_emit_conf 10.0 \
   # -dcov 200;
# qsub -N GLaDoS -o /dev/null -e "$i"_ASW_hc.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
   # -R ~/new_ref_seq/alt_sequence2.fa \
   # -T HaplotypeCaller \
   # -I "$i"_ASW_realigned.bam \
   # -o "$i"_ASW_haplotypes.raw.vcf \
   # -stand_call_conf 50.0 \
   # -stand_emit_conf 10.0 \
   # -dcov 200;
# done

# qsub -sync y -hold_jid cave_johnson GLaDoS echo "combustible lemons."

# cat files_to_process.txt | while read i; do
# qsub -N clip_reads -o /dev/null -e "$i"_hg19_clip.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
# -T ClipReads \
# -R ~/references/hg19.fa \
# -I "$i"_hg19_realigned.bam \
# -o "$i"_hg19_clipped.bam \
# -CT "1-5,11-15" \
# -QT 10;
# qsub -N clip_reads -o /dev/null -e "$i"_ASW_clip.err \
# ~/tools/java7/bin/java -Xmx8g -jar ~/tools/gatk/GenomeAnalysisTK.jar \
# -T ClipReads \
# -R ~/new_ref_seq/alt_sequence2.fa \
# -I "$i"_ASW_realigned.bam \
# -o "$i"_ASW_clipped.bam \
# -CT "1-5,11-15" \
# -QT 10;
# done



