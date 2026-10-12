rule run_checkm2:
    output:
        directory('reports/checkm2/{subject}')
    input:
        bins = 'temp/{subject}_bins'
    params:
        bins = lambda wildcards, input: f"{input.bins}/{wildcards.subject}_DASTool_bins"
    threads: workflow.cores
    conda: "../envs/checkm2.yml"
    shell:
        """
        checkm2 predict \
            --input '{params.bins}' \
            --output-directory '{output}' \
            --threads '{threads}' \
            -x fa
        """

rule filter_bins:
    output:
        bins = directory('data/bins/{subject}')
    input:
        bins = 'temp/{subject}_bins',
        checkm2 = 'reports/checkm2/{subject}'
    params:
        bins = lambda wildcards, input: f"{input.bins}/{wildcards.subject}_DASTool_bins"
    shell:
        """
        mkdir -p '{output.bins}'

        awk -F'\t' 'NR>1 && $2 >= 90 && $3 < 5 {{print $1}}' '{input.checkm2}/quality_report.tsv' | while read bin; do
            echo "Copying" '{params.bins}'/"$bin"*
            cp '{params.bins}'/"$bin"* '{output.bins}' 2>/dev/null || true
        done
        """

