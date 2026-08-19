rule build_index:
    output:
        dir = directory(host_db_dir)
    input:
        "temp/all.fna.gz"
    threads: threads_count
    params:
        index = lambda wildcards, output: f"{output.dir}/{host_db_name}"
    conda: "../envs/index.yml"
    shell:
        """
        bowtie2-build -p '{threads}' '{input}' '{params.index}'
        """

rule aggregate_genome:
    output:
        temp("temp/all.fna.gz")
    input:
        expand("temp/{subject}.fna.gz", subject=indexed_subjects_fn)
    conda: "../envs/index.yml"
    shell:
        "cat '{input}' >'{output}'"

rule download_ncbi_genome:
    output:
        temp("temp/{subject}.zip")
    conda: "../envs/index.yml"
    shell:
        """
        datasets download genome taxon '{subject.replace('_', ' ')}' --reference --include genome --filename '{output}'
        """

rule unzip_ncbi_genome:
    output:
        temp(directory("temp/{subject}"))
    input:
        "temp/{subject}.zip"
    conda: "../envs/index.yml"
    shell:
        """
        unzip '{input}' -d '{output}'
        """

rule aggregate_ncbi_genome:
    output:
        temp("temp/{subject}.fna")
    input:
        "temp/{subject}"
    conda: "../envs/index.yml"
    shell:
        """
        cat {input}/**/*.fna >'{output}'
        """

rule recompress_host_genome:
    output:
        temp("temp/{subject}.fna.gz")
    input:
        "temp/{subject}.fna"
    threads: threads_count
    conda: "../envs/index.yml"
    shell:
        """
        pigz -p '{threads}' -c '{input}' >'{output}'
        """