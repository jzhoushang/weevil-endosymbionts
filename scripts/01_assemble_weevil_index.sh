#!/bin/bash

set -xe

cat data/host_genomes/*.fna.gz > data/host_genomes/all_weevil_host.fna.gz

bowtie2-build --bmax 100000000 data/host_genomes/all_weevil_host.fna.gz data/host_db/weevil_idx

rm -rf data/host_genomes/