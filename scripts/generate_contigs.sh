#!/bin/bash

set -e

THREADS=8
CPU_MAX=0.8

R1="data/temp/$1_1.fastq.gz"
R2="data/temp/$1_2.fastq.gz"

OUT="data/temp/$1"

echo "= Generating contigs (saved to $OUT/)"

megahit \
    -1 "$R1" \
    -2 "$R2" \
    -t "$THREADS" \
    -m "$CPU_MAX" \
    -o "$OUT"