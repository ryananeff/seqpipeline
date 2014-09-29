#!/bin/sh

cat files_to_process_addl | while read i; do
qsub -q gibbons.q -N hg38_m -cwd -l mem_free=32G -pe make-dedicated 4 -o /dev/null \
-e "$i"_hg38_bwamem.qsub.err ./align_process.sh "$i";
done

qsub -hold_jid hg38_m -sync y -b y -N wait -o /dev/null -e /dev/null "echo ready to merge"

cat files_to_process_addl | while read i; do
qsub -q gibbons.q -N hg38_a -cwd -l mem_free=8G -o /dev/null \
-e "$i"_hg38_after.qsub.err ./after_align_process.sh "$i";
done

qsub -hold_jid hg38_a -sync y -b y -N wait -o /dev/null -e /dev/null "echo ready to merge"

./merge_all_asw.sh

./varcall_pipe.sh
