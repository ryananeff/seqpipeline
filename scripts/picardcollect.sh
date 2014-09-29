for i in 1000g/NA*rg.bam 1000g_2/NA*rg.bam; do 
echo "$i"
	qsub -q gibbons.q -N mmetrics -o /dev/null -e mmetrics.err -S /bin/bash -cwd ./picardhelper.sh "$i"
done
