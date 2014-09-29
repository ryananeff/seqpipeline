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

pattern="$1"

###########################################

# collect the list of all VCFs in the current working directory matching the pattern

for i in *"`echo $pattern`"
do
  echo "$i"
done
	
    
  


