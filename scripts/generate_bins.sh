#!/bin/bash

set -e

THREADS=8

MIN_CONTIG_LENGTH=1500

CONTIG_FOLDER="data/temp/$1"

echo "= Filtering contigs (n>$MIN_CONTIG_LENGTH)"
seqkit seq -m "$MIN_CONTIG_LENGTH" "$CONTIG_FOLDER/final.contigs.fa" >"$CONTIG_FOLDER/filtered_contigs.fa"

echo "= Building contig index"
bowtie2-build "$CONTIG_FOLDER/filtered_contigs.fa" "$CONTIG_FOLDER/contigs_idx"

echo "= Mapping decontaminated reads to contigs"
bowtie2 -x "$CONTIG_FOLDER/contigs_idx" \
        -1 "data/cleaned/$1_1.fastq.gz" \
        -2 "data/cleaned/$1_2.fastq.gz" \
        --threads "$THREADS" \
    | samtools view -u - \
    | samtools sort -@ "$THREADS" -o "$CONTIG_FOLDER/mapped_reads.sorted.bam"

echo "= Indexing mapped reads"
samtools index "$CONTIG_FOLDER/mapped_reads.sorted.bam"

echo "= Calculating depth tables"
jgi_summarize_bam_contig_depths --outputDepth "$CONTIG_FOLDER/depth.txt" "$CONTIG_FOLDER/mapped_reads.sorted.bam"

echo "= Binning (saved to data/bins/$1)"
mkdir -p "data/bins/$1"
metabat2 \
    -i "$CONTIG_FOLDER/filtered_contigs.fa" \
    -a "$CONTIG_FOLDER/depth.txt" \
    -o "data/bins/$1/$1" \
    -m "$MIN_CONTIG_LENGTH" \
    -t "$THREADS"
