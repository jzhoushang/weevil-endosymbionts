rule calculate_depth_tables:
    output:
        temp("temp/{subject}_depth.txt")
    input:
        bai = "temp/{subject}_mapped_reads.sorted.bam.bai",
        bam = "temp/{subject}_mapped_reads.sorted.bam"
    conda: "../envs/bins.yml"
    shell:
        """
        jgi_summarize_bam_contig_depths --outputDepth '{output}' '{input.bam}'
        """

rule bins_metabat2:
    output:
        temp(directory("temp/{subject}_metabat2"))
    input:
        contigs = "temp/{subject}_filtered.fa",
        depth_table = "temp/{subject}_depth.txt"
    threads: threads_count
    params:
        min = min_contig_length
    conda: "../envs/bins.yml"
    shell:
        """
        mkdir -p '{output}'
        metabat2 \
            -i '{input.contigs}' \
            -a '{input.depth_table}'\
            -o '{output}/{wildcards.subject}' \
            -m '{params.min}' \
            -t '{threads}'
        """

rule bins_maxbin2:
    output:
        temp(directory("temp/{subject}_maxbin2"))
    input:
        contigs = "temp/{subject}_filtered.fa",
        depth_table = "temp/{subject}_depth.txt"
    params:
        min = min_contig_length
    threads: threads_count
    conda: "../envs/bins.yml"
    shell:
        """
        mkdir -p '{output}'
        run_MaxBin.pl \
            -contig '{input.contigs}' \
            -abund '{input.depth_table}' \
            -out '{output}/bin' \
            -min_contig_length '{params.min}' \
            -thread '{threads}'
        """

rule bins_semibin2:
    output:
        temp(directory("temp/{subject}_semibin2"))
    input:
        contigs = "temp/{subject}_filtered.fa",
        bam = "temp/{subject}_mapped_reads.sorted.bam"
    params:
        min_length = min_contig_length,
        min_lower_length = min_contig_length - 500
    threads: threads_count
    conda: "../envs/bins.yml"
    shell:
        """
        SemiBin2 single_easy_bin \
            --self-supervised \
            -i '{input.contigs}' \
            -b '{input.bam}' \
            -o '{output}' \
            --min-len '{params.min_length}' \
            -t '{threads}' \
        || SemiBin2 single_easy_bin \
            -i '{input.contigs}' \
            -b '{input.bam}' \
            -o '{output}' \
            --min-len '{params.min_lower_length}' \
            --ml-threshold '{params.min_length}' \
            -t '{threads}'
        """

rule das_tool:
    output:
        bins = directory("data/bins/{subject}"),
        metabat2_data = temp("temp/{subject}_metabat2.tsv"),
        maxbin2_data = temp("temp/{subject}_maxbin2.tsv"),
        semibin2_data = temp("temp/{subject}_semibin2.tsv")
    input:
        contigs = "temp/{subject}_filtered.fa",
        metabat2_dir = "temp/{subject}_metabat2",
        maxbin2_dir = "temp/{subject}_maxbin2",
        semibin2_dir = "temp/{subject}_semibin2"
    threads: threads_count
    conda: "../envs/bins.yml"
    shell:
        """
        mkdir -p '{output.bins}'

        Fasta_to_Contig2Bin.sh -i '{input.metabat2_dir}' -e fa > '{output.metabat2_data}'
        Fasta_to_Contig2Bin.sh -i '{input.maxbin2_dir}' -e fasta > '{output.maxbin2_data}'

        for f in {input.semibin2_dir}/output_bins/*.fa.gz; do
            [ -f '$f' ] && gunzip '$f'
        done
        Fasta_to_Contig2Bin.sh -i '{input.semibin2_dir}/output_bins' -e fa > '{output.semibin2_data}'

        DAS_Tool \
            -i '{output.metabat2_data},{output.maxbin2_data},{output.semibin2_data}' \
            -l metabat2,maxbin2,semibin2 \
            -c '{input.contigs}' \
            -o '{output.bins}/{wildcards.subject}' \
            --write_bins \
            -t '{threads}' \
            --score_threshold 0.0
        """