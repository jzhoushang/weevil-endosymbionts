# Metagenome-Assembled Genome (MAG) Isolation Pipeline

Computational decontamination pipeline for the isolation of MAGs from publically available shotgun reads.

## Pipeline

### Pre-requisites and Environment

This pipeline was run on an Ubuntu virtual machine with 24 GB of RAM and 400 GB of storage and able to process relatively small datasets in a few days. It's recommended to use a more powerful machine for any real use cases.

GTDB-Tk and DRAM were run after the pipeline completed via KBase.

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
