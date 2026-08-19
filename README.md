# In silico identification and metabolic modeling of novel endosymbionts across diverse niches in weevils (Coleoptera: Curculionidae)

Computational decontamination pipeline for identification and analysis of endosymbionts from whole-genome sequencing reads.

## Pipeline

### Pre-requisites and Environment

Because of the heavy computational load (GTDB-Tk, for instance, requires ~100 GB of storage and ~140 GB of mmeory), it's recommended to use a machine with >256 GB of storage and >256 GB or memory.

To start, activate the conda environment in [environment.yml](./environment.yml)

```sh
$ conda env create -f environment.yml
$ conda activate weevil-endosymbionts
```

#### Databases

Ensure all required databases are downloaded.

<details>
    
<summary>CheckM2</summary>

See [CheckM2's GitHub's "Database" section](https://github.com/chklovski/CheckM2#Database). Verify the installation like so.

```sh
$ checkm2 database --version
# and, optionally,
$ checkm2 testrun
```

</details>

<details>

<summary>GTDB-Tk</summary>

See [GTDB-Tk's installation guide's "Reference Data" section](https://ecogenomics.github.io/GTDBTk/installing/index.html#gtdb-tk-reference-data). Verify the installation like so.

```sh
$ gtdbtk check_install
```

</details>


### Species

This pipeline analyzes the following species:

- Curculionidae (True weevils), grouped by diet
    - Stored grain (_Sitophilus_ spp.)
        - _S. granarius_ (grain weevil)
        - _S. oryzae_ (rice weevil)
        - _S. zeamais_ (maize weevil)
    - Cambiun and wood
        - _Dendroctonus ponderosae_ (mountain pine beetle)
        - _Dendroctonus valens_ (red turpentine beetle)
        - _Ips typographus_ (Eurasian spruce bark beetle)
        - _Orthorhinus cylindrirostris_ (elephant weevil)
        - _Xyleborus affinis_ (sugarcane shot-hole borer)
    - Plant reproductive organs
        - _Anthonomus grandis_ (boll weevil)
        - _Elaeidobius kamerunicus_ (African oil palm weevil)
    - Fruits, seeds, and nuts
        - _Curculio glandium_ (acorn weevil)
        - _Hypothenemus hampei_ (coffee berry borer)
    - Vascular and structural tissue
        - _Diaprepes abbreviatus_ (citrus root weevil)
        - _Rhynchophorus ferrugineus_ (red palm weevil)
- Other insects
    - _Tribolium castaneum_ (red flour beetle)
    - _Acyrthosiphon pisum_ (pea aphid)