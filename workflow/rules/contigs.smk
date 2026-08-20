def get_cleaned_r1(wildcards):
    accs = checkpoints.search_accessions.get().output["accs"]
    with open(f"{accs}/{wildcards.subject}.txt") as f:
        accessions = [line.strip() for line in f if line.strip()]
    return expand("temp/{acc}_1_cleaned.fastq.gz", acc=accessions)

def get_cleaned_r2(wildcards):
    accs = checkpoints.search_accessions.get(**wildcards).output["accs"]
    with open(f"{accs}/{wildcards.subject}.txt") as f:
        accessions = [line.strip() for line in f if line.strip()]
    return expand("temp/{acc}_2_cleaned.fastq.gz", acc=accessions)

rule decontaminate_host_reads:
    input:
        r1 = "temp/{acc}_1_trimmed.fastq.gz",
        r2 = "temp/{acc}_2_trimmed.fastq.gz",
        index_dir = host_db_dir
    output:
        r1 = temp("temp/{acc}_1_cleaned.fastq.gz"),
        r2 = temp("temp/{acc}_2_cleaned.fastq.gz")
    threads: workflow.cores
    params:
        index = lambda wildcards, input: f"{input.index_dir}/{host_db_name}"
    conda: "../envs/contigs.yml"
    priority: 100
    shell:
        """
        bowtie2 -x '{params.index}' \
            -1 '{input.r1}' \
            -2 '{input.r2}' \
            --threads '{threads}' \
            --very-sensitive-local \
        | samtools fastq -f 12 \
                         -1 '{output.r1}' \
                         -2 '{output.r2}' \
                         -0 /dev/null \
                         -s /dev/null \
                         --threads '{threads}' -
        """

rule aggregate_shotgun_reads:
    output:
        r1 = "data/cleaned/{subject}_1.fastq.gz",
        r2 = "data/cleaned/{subject}_2.fastq.gz"
    input:
        accs = "data/accessions/{subject}.txt",
        r1 = get_cleaned_r1,
        r2 = get_cleaned_r2
    conda: "../envs/contigs.yml"
    shell:
        """
        cat {input.r1} >'{output.r1}'
        cat {input.r2} >'{output.r2}'
        """

rule generate_contigs:
    output:
        temp(directory("temp/{subject}_contigs"))
    input:
        r1 = "data/cleaned/{subject}_1.fastq.gz",
        r2 = "data/cleaned/{subject}_2.fastq.gz"
    threads: workflow.cores
    conda: "../envs/contigs.yml"
    shell:
        """
        megahit \
            -1 '{input.r1}' \
            -2 '{input.r2}' \
            -t '{threads}' \
            -m '{cpu_limit}' \
            -o '{output}'
        """

rule filter_contigs:
    output:
        temp("temp/{subject}_filtered.fa")
    input:
        "temp/{subject}_contigs"
    params:
        min = min_contig_length
    conda: "../envs/contigs.yml"
    shell:
        """
        seqkit seq -m '{params.min}' '{input}/final.contigs.fa' >'{output}'
        """

rule build_contig_index:
    output:
        dir = temp(directory("temp/{subject}_index"))
    input:
        "temp/{subject}_filtered.fa"
    params:
        index = lambda wildcards, output: f"{output.dir}/index"
    conda: "../envs/contigs.yml"
    shell:
        """
        mkdir -p '{output.dir}'
        bowtie2-build '{input}' '{params.index}'
        """

rule map_cleaned_reads_to_contigs:
    output:
        temp("temp/{subject}_mapped_reads.sorted.bam")
    input:
        contig_index_dir = "temp/{subject}_index",
        r1 = "data/cleaned/{subject}_1.fastq.gz",
        r2 = "data/cleaned/{subject}_2.fastq.gz"
    params:
        index = lambda wildcards, input: f"{input.contig_index_dir}/index"
    threads: workflow.cores
    conda: "../envs/contigs.yml"
    shell:
        """
        bowtie2 -x '{params.index}' \
                -1 '{input.r1}' \
                -2 '{input.r2}' \
                --threads '{threads}' \
            | samtools view -u - \
            | samtools sort -@ '{threads}' -o '{output}'
        """

rule index_mapped_reads:
    output:
        temp("temp/{subject}_mapped_reads.sorted.bam.bai")
    input:
        "temp/{subject}_mapped_reads.sorted.bam"
    conda: "../envs/contigs.yml"
    shell:
        """
        samtools index '{input}'
        """
