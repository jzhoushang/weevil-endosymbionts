#!/bin/bash

set -e

echo "= Downloading host genome"
datasets download genome taxon "$1" --reference --include genome --filename "$2.zip"

echo "= Extracting host genome"
unzip "$2.zip" -d "../data/host_genomes/$2"
rm "$2.zip"

echo "= Re-compressing without auxilliary files"
FASTA_PATH=$(find "../data/host_genomes/$2" -name "*.fna" | head -n 1)
pigz -p 8 -c "$FASTA_PATH" > "../data/host_genomes/$2.fna.gz"

echo "= Cleaning up"
rm -rf "../data/host_genomes/$2"