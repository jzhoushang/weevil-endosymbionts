#!/bin/bash

set -e

THREADS=8

R1="data/temp/$1_1"
R2="data/temp/$1_2"

echo "= Downloading accession $1"
mkdir -p "data/temp"

echo "= Downloading .sra files"
prefetch "$1" -O "temp-sra/"

echo "= Dumping files"
fasterq-dump --split-files -e 8 "$1" -O "data/temp"
rm -r "temp-sra/"

echo "= Compressing files"
pigz -p 8 -c "$R1.fastq" >"$R1.fastq.gz"
pigz -p 8 -c "$R2.fastq" >"$R2.fastq.gz"
rm "$R1.fastq" "$R2.fastq"
