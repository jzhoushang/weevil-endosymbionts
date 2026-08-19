#!/bin/bash

THREADS=8
HOST_GENOME_LOCATION="data/host_genomes"
HOST_DB_LOCATION="data/host_db"

echo "Aggregating host genomes"
cat "$HOST_GENOME_LOCATION/*.fna.gz" > "$HOST_GENOME_LOCATION/all_weevil_host.fna.gz"

echo "Building index"
bowtie2-build -p "$THREADS" "$HOST_GENOME_LOCATION/all_weevil_host.fna.gz" "$HOST_DB_LOCATION/weevil_idx"

echo "Cleaning up"
rm -rf "$HOST_GENOME_LOCATION"