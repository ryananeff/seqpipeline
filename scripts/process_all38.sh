#!/bin/sh

alias qsub="qsub"

#qsub -V -b y -sync y -cwd -S /bin/sh ~/tools/bwa/bwa index ~/references/hg38.fa;

#cat files_to_process.txt | while read i; do
#echo "$i"
#qsub -V -N align -b y -cwd -S /bin/sh -q gibbons.q -pe make 6 -o "$i"_hg38_1.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 6 ~/references/hg38.fa "$i"_1.filt.fastq;
#qsub -V -N align -b y -cwd -S /bin/sh -q gibbons.q -pe make 6 -o "$i"_hg38_2.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 6 ~/references/hg38.fa "$i"_2.filt.fastq;
#done

#qsub -V -b y -sync y -hold_jid align -cwd -S /bin/sh echo "alignment done";

cat files_to_process.txt | while read i; do
qsub -V -N sampe -b y -cwd -S /bin/sh -o "$i"_hg38_sampe.sam -e errorlog.log ~/tools/bwa/bwa sampe -a 508 -P ~/references/hg38.fa "$i"_hg38_1.sai "$i"_hg38_2.sai "$i"_1.filt.fastq "$i"_2.filt.fastq;
done
