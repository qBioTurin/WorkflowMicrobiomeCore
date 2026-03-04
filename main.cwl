#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  fastq_directory: Directory
  paired_end: boolean
  threads: int?
  chocophlan_DB: Directory
  uniref_DB:  Directory
  db_bracken: File
  indexes: File[]
  kraken_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  meta_path: Directory
  confidence: float?
  stat_q: float?
  algorithm:
    - type: enum
      symbols:
        - kraken
        - metaphlan
        - both

outputs: 
  humann3_gene_families_kraken:
    type: File[]?
    outputSource: wrapperCore/humann3_gene_families_kraken
  humann3_path_coverage_kraken:
    type: File[]?
    outputSource: wrapperCore/humann3_path_coverage_kraken
  humann3_path_abundance_kraken:
    type: File[]?
    outputSource: wrapperCore/humann3_path_abundance_kraken
  humann3_gene_families_metaphlan:
    type: File[]?
    outputSource: wrapperCore/humann3_gene_families_metaphlan
  humann3_path_coverage_metaphlan:
    type: File[]?
    outputSource: wrapperCore/humann3_path_coverage_metaphlan
  humann3_path_abundance_metaphlan:
    type: File[]?
    outputSource: wrapperCore/humann3_path_abundance_metaphlan
  kraken2_output:
    type: File[]?
    outputSource: wrapperCore/kraken2_output
  kraken2_report:
    type: File[]?
    outputSource: wrapperCore/kraken2_report
#   unmapped_R1:
#     type: File[]
#     outputSource: wrapperCore/unmapped_R1
#   unmapped_R2:
#     type: File[]?
#     outputSource: wrapperCore/unmapped_R2
  bracken_output:
    type: File[]?
    outputSource: wrapperCore/bracken_output
  bracken_report:
    type: File[]?
    outputSource: wrapperCore/bracken_report
  metaphlan_report:
    type: File[]?
    outputSource: wrapperCore/metaphlan_report

steps:
  zerothstep:
    run: cwl/zerothStep.cwl
    in:
      dir: fastq_directory
      paired_end: paired_end
    out: [reads_1, reads_2]
  wrapperCore:
    run: cwl/wrapper.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
      threads: threads
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      db_bracken: db_bracken
      indexes: indexes
      kraken_path: kraken_path
      meta_path: meta_path
      algorithm: algorithm
      confidence: confidence
      stat_q: stat_q  
    out: [humann3_gene_families_kraken, humann3_path_coverage_kraken, humann3_path_abundance_kraken, kraken2_output, kraken2_report, unmapped_R1, unmapped_R2, bracken_output, bracken_report, humann3_gene_families_metaphlan, humann3_path_coverage_metaphlan, humann3_path_abundance_metaphlan, metaphlan_report]