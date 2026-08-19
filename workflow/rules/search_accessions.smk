checkpoint search_accessions:
    output:
        accs = "data/accessions/{subject}.txt",
        metadata = temp("data/accessions/{subject}_sra_metadata.csv")
    params:
        sub = "{subject}"
    conda: "../envs/accessions.yml"
    script:
        "../scripts/retrieve_accessions.py"

rule aggregate_metadata:
    output:
        "data/accessions/sra_metadata.csv"
    input:
        expand("data/accessions/{subject}_sra_metadata.csv", subject=subjects_fn)
    conda: "../envs/accessions.yml"
    shell:
        "cat {input} >'{output}'"