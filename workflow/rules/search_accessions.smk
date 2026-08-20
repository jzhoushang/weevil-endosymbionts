checkpoint search_accessions:
    output:
        accs = directory("data/accessions"),
        accs_fn = expand("data/accessions/{subject}.txt", subject=subjects_fn),
        metadata = "data/accessions/sra_metadata.csv"
    params:
        subs = subjects_fn
    conda: "../envs/accessions.yml"
    script:
        "../scripts/retrieve_accessions.py"

