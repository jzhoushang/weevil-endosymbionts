import io
import os
import subprocess
import sys

import numpy as np
import pandas as pd

ESEARCH_DTYPES = {
    "Run": str,
    "ScientificName": str,
    
    "size_MB": int,
    
    "Experiment": str,
    "SRAStudy": str
}

def run_esearch(species_name: str) -> pd.DataFrame:
    query = f'\\"{species_name}\\"[Organism] AND WGS[Strategy] AND ILLUMINA[Platform] AND PAIRED[Layout]'
    cmd = f'esearch -db sra -query "{query}" | efetch -format runinfo'

    # print("$", cmd)
    result = subprocess.run(
        cmd, 
        shell=True, 
        capture_output=True, 
        text=True, 
        check=True
    )

    if not result.stdout:
        return pd.DataFrame()

    df = pd.read_csv(
        io.StringIO(result.stdout),
        dtype=ESEARCH_DTYPES,
        usecols=ESEARCH_DTYPES.keys()
    )
    
    return df

os.makedirs(snakemake.output.accs, exist_ok=True)
with open(snakemake.output.metadata, "w") as f:
    f.write("Run,size_MB,Experiment,SRAStudy,ScientificName\n")

for subject in snakemake.params.subs:
    df = run_esearch(subject.replace('_', ' '))
    df_sorted = df.sort_values(by="size_MB", ascending=False).head(3)

    with open(f"{snakemake.output.accs}/{subject}.txt", "w") as f:
        f.write("\n".join(df_sorted["Run"].values.tolist()))

    df_sorted.to_csv(snakemake.output.metadata, mode="a", index=False, header=False)
