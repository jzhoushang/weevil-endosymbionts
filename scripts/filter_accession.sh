#!/bin/bash

set -e

THREADS=8

HOST_INDEX="data/host_db/weevil_idx"

CLEAN_R1="data/temp/$1_1-cleaned.fastq.gz"
CLEAN_R2="data/temp/$1_2-cleaned.fastq.gz"
R1="data/temp/$1_1"
R2="data/temp/$1_2"

echo "= Processing accession $1"
mkdir -p "reports/$1"

echo "= Quality control and trimming (report saved to reports/$1/)"
fastp \
    --in1 "$R1.fastq.gz" \
    --in2 "$R2.fastq.gz" \
    --out1 "$R1-trimmed.fastq.gz" \
    --out2 "$R2-trimmed.fastq.gz" \
    --detect_adapter_for_pe \
    --cut_right \
    --length_required 36 \
    --thread "$THREADS" \
    --html "reports/$1/fastp.html" \
    --json "reports/$1/fastp.json"

rm "$R1.fastq.gz" "$R2.fastq.gz"

echo "= Decontaminating (cleaned reads saved to clean/)"
bowtie2 -x "$HOST_INDEX" \
        -1 "$R1-trimmed.fastq.gz" \
        -2 "$R2-trimmed.fastq.gz" \
        --threads "$THREADS" \
        --very-sensitive-local \
    | samtools fastq -f 12 \
                     -1 "$CLEAN_R1" \
                     -2 "$CLEAN_R2" \
                     -0 /dev/null \
                     -s /dev/null \
                     --threads "$THREADS" -
                     
rm "$R1-trimmed.fastq.gz" "$R2-trimmed.fastq.gz"