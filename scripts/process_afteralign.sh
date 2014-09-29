#!/bin/sh
#qsub -V -b y -sync y -hold_jid align -cwd -S /bin/sh echo "alignment done";

#cat files_to_process.txt | while read i; do
#qsub -V -N sampe -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_hg19_sampe.sam -e sampe.err ~/tools/bwa/bwa sampe -a 508 -P ~/references/hg19.fa "$i"_hg19_1.sai 
#"$i"_hg19_2.sai "$i"_1.filt.fastq "$i"_2.filt.fastq;
#qsub -V -N sampe -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_ASW_sampe.sam -e sampe.err ~/tools/bwa/bwa sampe -a 508 -P ~/new_ref_seq/alt_sequence2.fa "$i"_ASW_1.sai 
#"$i"_ASW_2.sai "$i"_1.filt.fastq "$i"_2.filt.fastq;
#done

#qsub -V -b y -sync y -hold_jid sampe -cwd -S /bin/sh echo "sampe done";

#cat files_to_process.txt | while read i; do
#qsub -V -N view -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_hg19.bam -e view.err samtools view -bS "$i"_hg19_sampe.sam;
#qsub -V -N view -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_ASW.bam -e view.err samtools view -bS "$i"_ASW_sampe.sam;
#done

#qsub -V -b y -sync y -hold_jid view -cwd -S /bin/sh echo "samtools view done";

#cat files_to_process.txt | while read i; do
#qsub -V -N sort -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_hg19.sort.bam -e sort.err samtools sort -o "$i"_hg19.bam "$i"_hg19.sort;
#qsub -V -N sort -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_ASW.sort.bam -e sort.err samtools sort -o "$i"_ASW.bam "$i"_ASW.sort;
#done

#qsub -V -b y -sync y -hold_jid sort -cwd -S /bin/sh echo "samtools sort done";

cat files_to_process.txt | while read i; do
qsub -V -N dup -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_ASW.sort.PCR.bam -e dup.err java -Xmx4g -jar ~/tools/picard-tools/MarkDuplicates.jar \
I=""$i"_ASW.sort.bam" \
O="/dev/stdout" \
M=PCRinfo"$i"_ASW \
ASSUME_SORTED=true REMOVE_DUPLICATES=true \
VALIDATION_STRINGENCY=LENIENT;
qsub -V -N dup -b y -cwd -S /bin/sh -q gibbons.q -o "$i"_hg19.sort.PCR.bam -e dup.err java -Xmx4g -jar ~/tools/picard-tools/MarkDuplicates.jar \
I=""$i"_hg19.sort.bam" \
O="/dev/stdout" \
M=PCRinfo"$i"_hg19 \
ASSUME_SORTED=true REMOVE_DUPLICATES=true \
VALIDATION_STRINGENCY=LENIENT;
done

qsub -V -b y -sync y -hold_jid dup -cwd -S /bin/sh echo "markduplicates done";

cat files_to_process.txt | while read i; do
qsub -V -N index -b y -cwd -S /bin/sh -q gibbons.q -o /dev/null -e index.err samtools index "$i"_ASW.sort.PCR.bam;
qsub -V -N index -b y -cwd -S /bin/sh -q gibbons.q -o /dev/null -e index.err samtools index "$i"_hg19.sort.PCR.bam;
done






