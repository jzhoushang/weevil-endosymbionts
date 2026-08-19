#!/bin/bash

THREADS=8

echo "Running CheckM2 (quality report saved to reports/$1/)"
checkm2 predict \
    --input "data/bins/$1" \
    --output-directory "data/bins/$1/checkm2/" \
    --threads "$THREADS" \
    -x ".fa"

cp "data/bins/$1/checkm2/quality_report.tsv" "reports/$1/quality_report.tsv"
rm -rf "data/bins/$1/checkm2/"