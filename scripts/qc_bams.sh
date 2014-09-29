#!/bin/sh

for i in *merged*bam; do
qsub -N flags -o "$i"_flagstat.txt -e /dev/null -q gibbons.q -b y -cwd \
"samtools flagstat $i"
done
