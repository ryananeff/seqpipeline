#!/bin/bash

for i in NA*vcf; do 
./gatkworker.sh "$i";
done
