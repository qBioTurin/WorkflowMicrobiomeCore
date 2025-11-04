#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs: 
  read_fused: File
  threads: int?
  report: File
  chocophlan_DB: Directory
  uniref_DB:  Directory
  output_prefix: string?

outputs:
  humann3_gene_families:
    type: File
    outputSource: humann3/gene_families
  humann3_path_coverage:
    type: File
    outputSource: humann3/path_coverage
  humann3_path_abundance:
    type: File
    outputSource: humann3/path_abundance
  
steps:
  humann3:
    run: metaphlanFlow/humann3.cwl
    in:
      read_fused: read_fused
      report: report
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      threads: threads
      output_prefix: output_prefix
    out: [gene_families, path_coverage, path_abundance]