#!/bin/sh

# no .bashrc :(

alias qsub="qsub -V -S /bin/sh -cwd -b y -q gibbons.q"

# Add RG
cat files_to_process.txt | while read i; do
qsub -N rg -o "$i"_hg19_mate.rg.bam java -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$i"_hg19_mate.bam \
O=/dev/stdout \
RGID=1 \
RGPL=Illumina \
RGPU=hs \
RGSM="$i" \
RGLB="$i" \
VALIDATION_STRINGENCY=LENIENT ;

qsub -N rg -o "$i"_ASW_mate.rg.bam java -jar ~/tools/picard-tools/AddOrReplaceReadGroups.jar \
I="$i"_ASW_mate.bam \
O=/dev/stdout \
RGID=1 \
RGPL=Illumina \
RGPU=hs \
RGSM="$i" \
RGLB="$i" \
VALIDATION_STRINGENCY=LENIENT;
done

qsub -sync y -hold_jid rg echo "rg done!";

cat files_to_process.txt | while read i; do
qsub -N rgindex -o /dev/null -e rgindex.err samtools index "$i"_hg19_mate.rg.bam;
qsub -N rgindex -o /dev/null -e rgindex.err samtools index "$i"_hg19_mate.rg.bam;
done


