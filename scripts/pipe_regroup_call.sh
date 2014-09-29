#!/bin/sh

for i in *_merged.bam; do \
NAME=$(echo $i | awk "{sub(/_merged.bam/,\"\"); print;}"); \
qsub -q gibbons.q -N regr -o regr.out -e regr.err -cwd -l mem_free=32G ./redogroups_merged.sh $NAME; \
done

qsub -hold_jid regr -sync y -b y -N wait -o /dev/null -e /dev/null "echo rgdone"

for i in *_merged.regrouped.bam; do \
qsub -q gibbons.q -N ug_regr -o ug_rgr.out -e ug_rgr.err -cwd -l mem_free=32G -pe make-dedicated 4 ./varcall.sh $i; \
done

qsub -hold_jid ug_regr -sync y -b y -N wait -o /dev/null -e /dev/null "echo ugdone"

for i in *_merged.regrouped.bam; do \
qsub -q gibbons.q -N hc_regr -o hc_rgr.out -e hc_rgr.err -cwd -l mem_free=32G -pe make-dedicated 4 ./varcallhc.sh $i; \
done





