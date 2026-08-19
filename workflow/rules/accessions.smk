rule prefetch_accession:
    output:
        temp(directory("temp/{acc}"))
    conda: "../envs/accessions.yml"
    shell:
        """
        prefetch '{wildcards.acc}' -O 'temp' --type sra
        """

rule dump_shotgun_reads:
    input:
        "temp/{acc}"
    output:
        temp("temp/{acc}_1.fastq"),
        temp("temp/{acc}_2.fastq")
    threads: threads_count
    conda: "../envs/accessions.yml"
    shell:
        "fasterq-dump --split-files -e '{threads}' '{input}' -O temp"

rule zip_shotgun_reads:
    input:
        r1 = "temp/{acc}_1.fastq",
        r2 = "temp/{acc}_2.fastq"
    output:
        r1 = temp("temp/{acc}_1.fastq.gz"),
        r2 = temp("temp/{acc}_2.fastq.gz")
    threads: threads_count
    conda: "../envs/accessions.yml"
    shell:
        """
        pigz -p '{threads}' -c '{input.r1}' >'{output.r1}'
        pigz -p '{threads}' -c '{input.r2}' >'{output.r2}'
        """

rule filter_shotgun_reads:
    input:
        r1 = "temp/{acc}_1.fastq.gz",
        r2 = "temp/{acc}_2.fastq.gz"
    output:
        r1 = temp("temp/{acc}_1_trimmed.fastq.gz"),
        r2 = temp("temp/{acc}_2_trimmed.fastq.gz"),
        html = "reports/fastp/{acc}/report.html",
        json = "reports/fastp/{acc}/report.json"
    threads: threads_count
    conda: "../envs/accessions.yml"
    shell:
        """
        fastp \
            --in1 '{input.r1}' \
            --in2 '{input.r2}' \
            --out1 '{output.r1}' \
            --out2 '{output.r2}' \
            --detect_adapter_for_pe \
            --cut_right \
            --length_required 36 \
            --thread '{threads}' \
            --html '{output.html}' \
            --json '{output.json}'
        """