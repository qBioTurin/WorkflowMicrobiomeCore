cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
inputs:
  fastq_directory: Directory 
  threads: int?
  kraken_folder:
    type: Directory
  chocophlan_DB:
    type: Directory
  uniref_DB:
    type: Directory

  

outputs:
  path_abundance: 
      type: File[]
      outputSource: KHumann/path_abundance
  gene_families:
    type: File[]
    outputSource: KHumann/gene_families
  path_coverage:
    type: File[]
    outputSource: KHumann/path_coverage

steps:
  check-input:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  KHumann:
    run: cwl/humannKFlow.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      threads: threads
      read_1: check-input/reads_1
      read_2: check-input/reads_2
      kraken_folder: kraken_folder
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
    out: [gene_families,path_coverage,path_abundance]