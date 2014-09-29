#!/bin/bash

echo $SHELL > /dev/stderr

#cat files_to_process_addl | while read i; do
#qsub -q gibbons.q -N hg38_m -cwd -l mem_free=32G -pe make-dedicated 4 -o /dev/null \
#-e "$i"_hg38_bwamem.qsub.err ./align_process.sh "$i";
#done

#cat files_to_process_addl | while read i; do
#qsub -q gibbons.q -S /bin/bash -N hg38_a -cwd -l mem_free=10G -o /dev/null -e "$i"_hg38_after3.qsub.err ./after_align_process.sh "$i";
#done

#qsub -hold_jid hg38_a -q gibbons.q -N wait_merge -b y -sync y "echo ready"
 
./merge_all_asw.sh

qsub -hold_jid merge -q gibbons.q -N wait_call -b y -sync y "echo ready"

./varcall_pipe2.sh
