rule run_coverm:
    output:
        directory("reports/coverm/{subject}")
    input:
        bins = "data/bins/{subject}",
        r1 = "data/cleaned/{subject}_1.fastq.gz",
        r2 = "data/cleaned/{subject}_2.fastq.gz"
    threads: workflow.cores
    conda: "../envs/coverm.yml"
    shell:
        """
        mkdir -p '{output}'
        
        coverm genome \
            --genome-fasta-files '{input.bins}/'*'.fa' \
            --couples '{input.r1}' '{input.r2}' \
            --out-raw-counts '{output}/coverage_summary.tsv' \
            --threads '{threads}'
        """
