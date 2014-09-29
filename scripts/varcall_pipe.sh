#!/bin/sh

for i in NA*bam; do
	qsub -q gibbons.q -N sind -pe make-dedicated 4 -cwd ./varcall.sh "$i"
done

qsub -q gibbons.q -N final -cwd -b y -pe make-dedicated 16 ~/tools/pindel/pindel -T 16 \
	-f ~/references/hg38.fa \
	-i pindel_config_new1.txt \
	-c ALL \
	-o pindel_1_hg38;
qsub -q gibbons.q -N final -cwd -b y -pe make-dedicated 16 ~/tools/pindel/pindel -T 16 \
        -f ~/references/hg38.fa \
        -i pindel_config_new1a.txt \
        -c ALL \
        -o pindel_1a_hg38;
qsub -q	gibbons.q -N final -cwd -b y -pe make-dedicated 16 ~/tools/pindel/pindel -f ~/references/hg38.fa \
        -i pindel_config_new2.txt \
       	-c ALL \
	-T 16 \
        -o pindel_2_hg38;
qsub -q gibbons.q -N final -cwd -b y -pe make-dedicated 16 ~/tools/pindel/pindel -f ~/references/hg38.fa \
        -i pindel_config_new2a.txt \
        -c ALL \
        -T 16 \
        -o pindel_2a_hg38;

 


