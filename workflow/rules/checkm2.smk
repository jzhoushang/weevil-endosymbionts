rule run_checkm2:
    output:
        temp(directory('temp/{subject}_checkm2'))
    input:
        bins = 'temp/{subject}_bins',
        db = 'databases/checkm2'
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
            --database_path '{input.db}/CheckM2_database/uniref100.KO.1.dmnd' \
            -x fa
        """

rule filter_bins:
    output:
        bins = directory('data/bins/{subject}')
    input:
        bins = 'temp/{subject}_bins',
        checkm2 = 'temp/{subject}_checkm2'
    shell:
        """
        mkdir -p '{output.bins}'

        awk -F'\t' 'NR>1 && $2 >= 90 && $3 < 5 {print $1}' '{input.checkm2}/quality_report.tsv' | while read bin; do
            cp '{input.bins}/$bin'* '{output.bins}' 2>/dev/null || true
        done
        """

rule download_checkm2_database:
    output: 
        directory('databases/checkm2')
    conda: "../envs/checkm2.yml"
    shell:
        """
        mkdir -p '{output}'
        checkm2 database --download --path '{output}'
        """"
