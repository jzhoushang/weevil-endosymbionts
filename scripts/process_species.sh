#!/bin/bash

set -e

SUBJECT="$1"
SUBJECT_FN="${SUBJECT// /_}"

while IFS= read -r acc || [ -n "$acc" ]; do 
    ./scripts/download_accession.sh $acc
    ./scripts/filter_accession.sh $acc
done <"data/accessions/$SUBJECT_FN.txt"

cat data/temp/*_1-cleaned.fastq.gz >"data/temp/${SUBJECT_FN}_1.fastq.gz"
cat data/temp/*_2-cleaned.fastq.gz >"data/temp/${SUBJECT_FN}_2.fastq.gz"
rm data/temp/*_1-cleaned.fastq.gz data/temp/*_2-cleaned.fastq.gz

./scripts/generate_contigs.sh "$SUBJECT_FN"

./scripts/generate_bins.sh "$SUBJECT_FN"
rm -r "data/temp"