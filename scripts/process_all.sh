#!/bin/sh
cat files_to_process.txt | while read i; do
echo "$i"
qsub -V -N align -b y -cwd -S /bin/sh -q all.q -pe make 8 -o "$i"_hg19_1.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 8 ~/references/hg19.fa "$i"_1.filt.fastq;
qsub -V -N align -b y -cwd -S /bin/sh -q all.q -pe make 8 -o "$i"_hg19_2.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 8 ~/references/hg19.fa "$i"_2.filt.fastq;
qsub -V -N align -b y -cwd -S /bin/sh -q all.q -pe make 8 -o "$i"_ASW_1.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 8 ~/new_ref_seq/alt_reference2.fa "$i"_1.filt.fastq;
qsub -V -N align -b y -cwd -S /bin/sh -q all.q -pe make 8 -o "$i"_ASW_2.sai -e errorlog.log ~/tools/bwa/bwa aln -R 100 -t 8 ~/new_ref_seq/alt_reference2.fa "$i"_2.filt.fastq;
done

qsub -V -b y -sync y -hold_jid align -cwd -S /bin/sh echo "alignment done";

cat files_to_process.txt | while read i; do
qsub -V -N sampe -b y -cwd -S /bin/sh -o "$i"_hg19_sampe.sam -e errorlog.log ~/tools/bwa/bwa sampe -a 508 -P ~/references/hg19.fa "$i"_hg19_1.sai "$i"_hg19_2.sai "$i"_1.filt.fastq "$i"_2.filt.fastq;
qsub -V -N sampe -b y -cwd -S /bin/sh -o "$i"_ASW_sampe.sam -e errorlog.log ~/tools/bwa/bwa sampe -a 508 -P ~/new_ref_seq/alt_reference2.fa "$i"_ASW_1.sai "$i"_ASW_2.sai "$i"_1.filt.fastq "$i"_2.filt.fastq;
done
