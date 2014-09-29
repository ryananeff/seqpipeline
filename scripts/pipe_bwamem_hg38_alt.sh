#!/bin/bash

echo $SHELL > /dev/stderr

for i in *1.filt.fastq ../1000g_2/*1.filt.fastq; do
i=${i:0:9};
qsub -q gibbons.q -N hg38_alt -cwd -l mem_free=32G -pe make-dedicated 4 -o /dev/null \
-e "$i"_hg38_bwamem.qsub.err ./align_process.sh "$i";
done

qsub -q gibbons.q -hold_jid hg38_alt -N wait_alt -b y -sync y "echo ready"

for i in *1.filt.fastq ../1000g_2/*1.filt.fastq; do
i=${i:0:9};
qsub -q gibbons.q -S /bin/bash -N hg38_a -cwd -l mem_free=10G -o /dev/null -e "$i"_hg38_after3.qsub.err ./after_align_process2.sh "$i";
done


