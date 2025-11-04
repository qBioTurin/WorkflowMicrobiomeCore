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
  db_bracken: File
  chocophlan_DB: Directory
  uniref_DB:  Directory
  db_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  algorithm:
    - type: enum
      symbols:
        - kraken
        - metaphlan
        - both

outputs:
  kraken2_output:
    type: File
    outputSource: kraken2/kraken2
  kraken2_report:
    type: File
    outputSource: kraken2/report
  bracken_output:
    type: File
    outputSource: bracken/bracken
  bracken_report:
    type: File
    outputSource: bracken/report_bracken
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
  kraken2:
    run: krakenFlow/kraken2.cwl
    in:
      read_1: read_1
      read_2: read_2
      db_path: db_path
      threads: threads
    out: [kraken2, report]
  bracken:
    run: krakenFlow/bracken.cwl
    in:
      report: kraken2/report
      kmer_distrib: db_bracken
    out: [bracken, report_bracken]
  report_to_metaphlan:
    run: krakenFlow/reportToMetaphlan.cwl
    in:
      report: kraken2/report
    out: [mid_report]
  report_count_abound:
    run: krakenFlow/reportCountAbound.cwl
    in:
      report: report_to_metaphlan/mid_report
    out: [final_report]
  wrapperHumann:
    run: wrapperHumann.cwl
    in:
      read_fused: read_fused
      threads: threads
      report: report_count_abound/final_report
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      output_prefix: 
        default: "kraken"
    out: [humann3_gene_families, humann3_path_coverage, humann3_path_abundance]
