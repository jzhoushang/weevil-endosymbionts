rule run_dram:
    output:
        annos = directory("reports/dram/annotations/{subject}"),
        dists = directory("reports/dram/distillations/{subject}")
    input:
        bins = "data/bins/{subject}",
        gtdbtk = "reports/gtdbtk/{subject}/gtdbtk.summary.tsv",
        checkm2 = "reports/checkm2/{subject}",
        db = "databases/dram"
    threads: workflow.cores
    conda: "../envs/dram.yml"
    shell:
        """
        mkdir -p '{output.annos}'
        mkdir -p '{output.dists}'

        DRAM.py annotate \
            --input_fasta '{input.bins}' \
            --outdir '{output.annos}' \
            --taxa '{input.gtdbtk}' \
            --bin_quality '{input.checkm2}/quality_report.tsv' \
            --threads '{threads}'
        DRAM.py distill \
            -i '{output.annos}/annotations.tsv' \
            -o '{output.dists}' \
            --rrna_path '{output.annos}/rrnas.tsv' \
            --trna_path '{output.annos}/trnas.tsv'
        """

rule download_dram_databases:
    output:
        directory("databases/dram")
    conda: "../envs/dram.yml"
    shell:
        """
        mkdir -p '{output}'
        DRAM-setup.py prepare_databases --output_dir '{output}' --skip_uniref
        """
