#!/bin/bash

java -Xmx16g -jar ~/tools/picard-tools/CollectMultipleMetrics.jar \
REFERENCE_SEQUENCE=~/references/GRCh38_noalt.fa \
ASSUME_SORTED=TRUE \
INPUT="$1" \
OUTPUT="$1".metrics;

