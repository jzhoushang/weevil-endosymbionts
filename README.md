# Metagenome-Assembled Genome (MAG) Isolation Pipeline

Computational decontamination pipeline for the isolation of MAGs from publicly available shotgun reads. This project was originally intended to identify endosymbionts in weevils.

## Pipeline

### Pre-requisites and Environment

This pipeline was run on an Ubuntu virtual machine with 24 GB of RAM and 400 GB of storage and able to process relatively small datasets in a few days. It's recommended to use a more powerful machine for any real use cases.

GTDB-Tk and DRAM were run after the pipeline completed via KBase.

### Tools

This pipeline uses the following tools:

- [NCBI ESearch](https://dataguide.nlm.nih.gov/edirect/esearch.html), part of the NCBI E-Utilities
- [NCBI SRA Toolkit](https://github.com/ncbi/sra-tools) to download shotgun reads
- [NCBI Datasets](https://github.com/ncbi/datasets) to download genomes
- [fastp](https://github.com/opengene/fastp) for preprocessing and quality filtering
- [Bowtie 2](https://github.com/benlangmead/bowtie2) for read alignment
- [MEGAHIT](https://github.com/voutcn/MEGAHIT) for forming contigs
- [MetaBAT 2](https://pmc.ncbi.nlm.nih.gov/articles/PMC6662567/) for bins
- [MaxBin 2](https://academic.oup.com/bioinformatics/article/32/4/605/1744462) for bins
- [SemiBin2](https://academic.oup.com/bioinformatics/article/39/Supplement_1/i21/7210480) for bins
- [DAS Tool](https://github.com/cmks/DAS_Tool) to merge bins
- [CheckM2](https://github.com/chklovski/CheckM2) for quality assessment
- [CoverM](https://github.com/wwood/CoverM) to calculate coverage

As well as utilities like [SeqKit](https://github.com/shenwei356/seqkit), [pigz](https://github.com/madler/pigz), and [samtools](https://github.com/samtools/samtools).
