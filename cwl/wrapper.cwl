#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  read_1: File
  read_2: File?
  threads: int?
  chocophlan_DB: Directory
  uniref_DB:  Directory
  db_bracken: File
  indexes: 
    type: File[]
  kraken_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  meta_path: Directory
  algorithm:
    - type: enum
      symbols:
        - kraken
        - metaphlan
        - both

outputs: 
  unmapped_R1:
    type: File
    outputSource: genomemapper/unmapped_R1
  unmapped_R2:
    type: File?
    outputSource: genomemapper/unmapped_R2
  kraken2_output:
    type: File?
    outputSource: wrapperKraken/kraken2_output
  kraken2_report:
    type: File?
    outputSource: wrapperKraken/kraken2_report
  bracken_output:
    type: File?
    outputSource: wrapperKraken/bracken_output
  bracken_report:
    type: File?
    outputSource: wrapperKraken/bracken_report
  humann3_gene_families_kraken:
    type: File?
    outputSource: wrapperKraken/humann3_gene_families
  humann3_path_coverage_kraken:
    type: File?
    outputSource: wrapperKraken/humann3_path_coverage
  humann3_path_abundance_kraken:
    type: File?
    outputSource: wrapperKraken/humann3_path_abundance
  humann3_gene_families_metaphlan:
    type: File?
    outputSource: wrapperMetaphlan/humann3_gene_families
  humann3_path_coverage_metaphlan:
    type: File?
    outputSource: wrapperMetaphlan/humann3_path_coverage
  humann3_path_abundance_metaphlan:
    type: File?
    outputSource: wrapperMetaphlan/humann3_path_abundance
  metaphlan_report:
    type: File?
    outputSource: wrapperMetaphlan/report

steps:
  genomemapper:
    run: ./genomeMapper/genomeMapper.cwl
    in:
      read_1: read_1
      read_2: read_2
      threads: threads
      index: indexes
    out: [unmapped_R1, unmapped_R2, read_fused] 
  wrapperKraken:
    run: wrapperKraken.cwl
    in:
      read_1: genomemapper/unmapped_R1
      read_2: genomemapper/unmapped_R2
      read_fused: genomemapper/read_fused
      threads: threads
      db_path: kraken_path
      algorithm: algorithm
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      db_bracken: db_bracken
    when: $(inputs.algorithm === "kraken" || inputs.algorithm === "both")
    out: [kraken2_output, kraken2_report, humann3_gene_families, humann3_path_coverage, humann3_path_abundance, bracken_output, bracken_report]
  wrapperMetaphlan:
    run: wrapperMetaphlan.cwl
    in:
      read_1: genomemapper/unmapped_R1
      read_2: genomemapper/unmapped_R2
      read_fused: genomemapper/read_fused
      threads: threads
      meta_path: meta_path
      algorithm: algorithm
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
    when: $(inputs.algorithm === "metaphlan" || inputs.algorithm === "both")
    out: [report, humann3_gene_families, humann3_path_coverage, humann3_path_abundance]
