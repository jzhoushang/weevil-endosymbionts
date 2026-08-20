rule run_gtdbtk:
    output:
        dir = directory("reports/gtdbtk/{subject}"),
        summary = "reports/gtdbtk/{subject}/gtdbtk.summary.tsv"
    input:
        bins = "data/bins/{subject}",
        db = "databases/gtdbtk"
    threads: workflow.cores
    conda: "../envs/gtdbtk.yml"
    shell:
        """
        mkdir -p '{output}'
        GTDB_PATH=$(find '{input.db}' -maxdepth 1 -type d -name 'release*' | head -n 1)
        export GTDBTK_DATA_PATH='$GTDB_PATH'

        gtdbtk classify_wf \
            --genome_dir '{input.bins}' \
            --out_dir '{output.dir}' \
            --extension fa \
            --cpus '{threads}'

        cat {output.dir}/gtdbtk.*.summary.tsv >'{output.summary}' 2>/dev/null || true
        """
    
rule download_gtdbtk_database:
    output:
        directory("databases/gtdbtk")
    conda: "../envs/gtdbtk.yml"
    shell:
        """
        mkdir -p '{output}'
        
        (cd '{output}' && download-db.sh)
        """

