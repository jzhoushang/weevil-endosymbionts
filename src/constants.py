SUBJECTS = [
    "Sitophilus granarius",
    "Sitophilus oryzae",
    "Sitophilus zeamais",
    
    "Dendroctonus ponderosae",
    "Dendroctonus valens",
    "Ips typographus",
    "Orthorhinus cylindrirostris",
    "Xyleborus affinis",
    
    "Anthonomus grandis",
    "Elaeidobius kamerunicus",
    
    "Curculio glandium",
    "Hypothenemus hampei",
    
    "Diaprepes abbreviatus",
    "Rhynchophorus ferrugineus",

    # "Tribolium castaneum",
    # "Acyrthosiphon pisum"
]

RESTRICTED_SUBJECTS = [
    "Sitophilus oryzae",
    "Dendroctonus ponderosae",
    "Anthonomus grandis",
    "Hypothenemus hampei",
    "Rhynchophorus ferrugineus",
    "Diaprepes abbreviatus",
]

ESEARCH_DTYPES = {
    "Run": str,
    "ScientificName": str,
    
    "size_MB": int,
    
    "Experiment": str,
    "SRAStudy": str
}