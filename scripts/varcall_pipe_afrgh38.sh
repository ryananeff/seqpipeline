#!/bin/bash

for i in NA*afrgh38.bam; do
	qsub -q gibbons.q -N v_hc -o /dev/null -e v_hc."$i".err -pe make-dedicated 4 -S /bin/bash -cwd ./varcallhc_afrgh38.sh "$i"
done

