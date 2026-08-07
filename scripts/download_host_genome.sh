#!/bin/bash

set -e

datasets download genome taxon "$1" --reference --include genome --filename "$2.zip"
unzip "$2.zip" -d "../data/host_genomes/$2"
rm "$2.zip"

FASTA_PATH=$(find "../data/host_genomes/$2" -name "*.fna" | head -n 1)
pigz -p 8 -c "$FASTA_PATH" > "../data/host_genomes/$2.fna.gz"
rm -rf "../data/host_genomes/$2"