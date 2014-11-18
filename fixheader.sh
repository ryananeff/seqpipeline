#!/bin/sh

i=$1
path=$2

# quit on error
set -e
name=`echo $i | rev | cut -d "." -f 6-12 | rev`
samtools view -H "$path/$i" | sed "s/__/\t/g" | sed "s/_AC/\tAC/g" | sed "s/_//g" | sed "s/\"\$1\"/$name/g" > "$path/$i".newheader
samtools reheader "$path/$i".newheader "$path/$i" > "$path/$i".nh.bam
rm "$path/$i"
samtools index "$path/$i".nh.bam
