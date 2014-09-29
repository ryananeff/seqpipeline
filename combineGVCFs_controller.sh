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

max_t="$1"
max_fp="$2"
prefix="$3"
pattern="$4"

###########################################

# collect the list of all GVCFs in the current working directory and creates:
#	1. combine files with the list of GVCFs, and a name for the output file it is paired with.
# This combining step is influenced by the number of threads that will be used in GenotypeGVCFs, as well as the number of GVCF files.

# first, some math in a nice one-liner
num_files=`ls -1 *.gvcf | grep .gvcf | wc -l`
files_per_comb=`python -c "from math import ceil; print int(ceil(( $num_files * $max_t )/float( $max_fp )))"`

#now that we've established that, let's start iterating
declare -i count
totalcount=1
count=1
filecount=1
cur_file="$prefix"_"$filecount".comb
for i in *"`echo $pattern`"
do
  echo "$i" >> $cur_file
  echo -e "$totalcount\t$i\t$count\t$cur_file" >> "$prefix"_combined_master_sheet.txt
  ((totalcount++))
  ((count++))
  if [ "$count" -gt "$files_per_comb" ]
    then
      count=1
      ((filecount++))
      cur_file="$prefix"_"$filecount".comb
    fi
done

# now that we have all of the files ready and our master list ready, we're ready to combine!
	
    
  


