#!/bin/bash

for i in *Hc.raw.vcf; do 
echo "$i";
ts -L selectindels ./selectindels.sh "$i";
done


