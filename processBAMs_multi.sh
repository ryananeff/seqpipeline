#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo -ne "Detected environment file!\nRemember that this file defines the reference that should be used in later steps."       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
name=$1 # no BAM in the name here!
threads=$2

###########################################

echo "$(date): sorting BAM...";
sambamba sort -t $threads "$name".bam "$name".sort.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during sambamba sort"; exit 1; else echo "$(date): sorting bam done."; fi

# if all went well, remove the old files (we should only get here if there was zero exit statuses
if [ -s "$name".sort.bam ]
then echo "$(date): sorted BAM file found with non-zero size; continuing..."
else echo "$(date): unexpected error: sorted BAM file is missing; exiting"; exit 2; fi
echo "$(date): removing temporary files..."
rm "$name".bam
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during temporary file removal"; exit 1; else echo "$(date): removed temporary SAM and BAM."; fi

# remove duplicates (sambamba)
sambamba rmdup -t $threads "$name".sort.bam "$name".rmdup.bam
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during duplicate removal"; exit 1; else echo "$(date): sambamba markdup done."; fi

# index bam
echo "$(date): indexing duplicate-removed BAM..."
sambamba index -t $threads "$name".rmdup.bam;
if [ $? -ne 0 ]; then echo "$(date): exited with non-zero status ($?) during sambamba indexing post duplicate removal"; exit 1; else echo "$(date): indexing dup-rem BAM done."
