#!/bin/bash

# initialize
ENV="environment.sh"
if [ -f $ENV ];
then
    echo "Detected environment file!\nRemember that this file defines the reference that should be used in later steps."       
else
    echo "No environment file detected.	The program will now stop!"
    exit 1
fi
source environment.sh

# set variables
varlist="$1"
memory="$2"
name="$3"
intervals_list="$4"

###########################################

cat "$intervals_list" | while read i; do 
echo "$scripthome/vcf_biowulf_intervals.sh "$varlist" 1 "$memory" "$name"_"$i" "$home"/ipython_notebooks/"$i" 2>"$name"_"$i"_genogvcf.err 1>"$name"_"$i"_genogvcf.out"
done 

