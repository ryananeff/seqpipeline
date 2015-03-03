#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo -ne "Detected environment file!\nRemember that this file defines the reference that should be used in later steps.\n"       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
left=$1
right=$2
sample=$3
lane=$4
study=$5
name="$sample"_"$lane"

###########################################

# run SNAP alignment for reference; environment file requires the index-dir to be specified for SNAP to run
# since we have 256 GB of RAM on each machine, let's run 16 threads on 
each machine with 64G RAM
echo "$(date): starting SNAP alignment...";
$snapbeta paired "$snapindex" "$left" "$right" -o "$name".sort.bam \
-h 2000 -H 300000 -d 20 -t 16 -mcp 2000000 \
-R '@RG\tID:1\tSM:"$1"\tLB:"$1"\tPL:Illumina\tPU:hs';
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during SNAP alignment"; exit 1; else echo "$(date): SNAP alignment done."; fi

# now we need to merge by lane (can't be handled inside this program)

