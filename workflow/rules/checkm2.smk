rule use_checkm2:
    output:
        directory('reports/checkm2/{subject}')
    input:
        'data/bins/{subject}'
    params:
        bins = lambda wildcards, input: f"{input}/{wildcards.subject}_DASTool_bins"
    threads: threads_count
    conda: "../envs/checkm2.yml"
    shell:
        """
        checkm2 predict \
            --input '{params.bins}' \
            --output-directory '{output}' \
            --threads '{threads}' \
            -x fa
        """