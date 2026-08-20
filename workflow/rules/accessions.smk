rule prefetch_accession:
    output:
        temp(directory("temp/{acc}")),
        temp("temp/{acc}/{acc}.sra")
    conda: "../envs/accessions.yml"
    resources:
        sra_lock = 1
    shell:
        """
        prefetch '{wildcards.acc}' \
             -O 'temp' \
            --type sra \
            --max-size 100g \
            --resume yes
        """

rule dump_shotgun_reads:
    input:
        dir = "temp/{acc}",
        archive = "temp/{acc}/{acc}.sra"
    output:
        r1_unzipped = temp("temp/{acc}_1.fastq"),
        r2_unzipped = temp("temp/{acc}_2.fastq"),
        r1 = temp("temp/{acc}_1.fastq.gz"),
        r2 = temp("temp/{acc}_2.fastq.gz")
    threads: workflow.cores
    conda: "../envs/accessions.yml"
    shell:
        """        
        fasterq-dump --split-files -e '{threads}' '{input.archive}' -O temp
        pigz -p '{threads}' -c '{output.r1_unzipped}' >'{output.r1}'
        pigz -p '{threads}' -c '{output.r2_unzipped}' >'{output.r2}'
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
    threads: workflow.cores
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
