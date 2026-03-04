#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs: 
  read_1: File
  read_2: File?
  read_fused: File
  threads: int?
  meta_path: Directory
  chocophlan_DB: Directory
  uniref_DB:  Directory
  stat_q: float?
  algorithm:
    - type: enum
      symbols:
        - kraken
        - metaphlan
        - both

outputs:
  report:
    type: File
    outputSource: metaphlan4/report
  humann3_gene_families:
    type: File
    outputSource: wrapperHumann/humann3_gene_families
  humann3_path_coverage:
    type: File
    outputSource: wrapperHumann/humann3_path_coverage
  humann3_path_abundance:
    type: File
    outputSource: wrapperHumann/humann3_path_abundance
  
steps:
  metaphlan4:
    run: metaphlanFlow/metaphlan4.cwl
    in:
      read_1: read_1
      read_2: read_2
      threads: threads
      meta_path: meta_path
      stat_q: stat_q
    out: [report]
  wrapperHumann:
    run: wrapperHumann.cwl
    in:
      read_fused: read_fused
      threads: threads
      report: metaphlan4/report
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      output_prefix: 
        default: "metaphlan"
    out: [humann3_gene_families, humann3_path_coverage, humann3_path_abundance]