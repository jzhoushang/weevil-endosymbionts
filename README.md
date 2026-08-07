# In silico identification and metabolic modeling of novel endosymbionts across diverse niches in weevils (Coleoptera: Curculionidae)

Computational decontamination pipeline for identification and analysis of endosymbionts from whole-genome sequencing reads.

## Pipeline

### Running

To start, activate the [conda](https://conda.org/) environment in [environment.yml](./environment.yml)

```sh
$ conda env create -f environment.yml
$ conda activate weevil-endosymbionts
```

Then, run the Jupyter Notebooks in [notebooks/](./notebooks/).

### Species

This pipeline analyzes the following species:

- Curculionidae (True weevils), by diet
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