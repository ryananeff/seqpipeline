#!/bin/bash

cat files_to_process_addl | while read i; do
qsub -q gibbons.q -N afrgh38_m -cwd -l mem_free=32G -pe make-dedicated 4 -e "$i"_afrgh38_bwamem.qsub.err -b y -o /dev/null "./align_process_afrgh38.sh $i";
done

qsub -hold_jid afrgh38_m -sync y -b y -N wait -o /dev/null -e /dev/null "echo ready to merge"

cat files_to_process_addl | while read i; do
qsub -q gibbons.q -N afrgh38_a -cwd -l mem_free=8G -o /dev/null -e "$i"_afrgh38_after.qsub.err -b y "./after_align_process_afrgh38.sh $i";
done

qsub -hold_jid afrgh38_a -sync y -b y -N wait -o /dev/null -e /dev/null "echo ready to merge"

./merge_all_asw_afrgh38.sh

./varcall_pipe_afrgh38.sh
