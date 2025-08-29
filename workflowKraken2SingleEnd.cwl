#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  fastq_directory: Directory
  threads: int?
  db_bracken: File
  classification_level: string?
  threshold: int?
  db_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  index_chm13:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  index_hg38:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa

outputs: 
  kraken2_output:
    type: File[]
    outputSource: kraken2/kraken2_output
  kraken2_report:
    type: File[]
    outputSource: kraken2/kraken2_report
  bracken_output:
    type: File[]
    outputSource: kraken2/bracken_output
  bracken_report_output:
    type: File[]
    outputSource: kraken2/bracken_report_output

steps:
  zerothstep:
    run: cwl/zerothStepSingleEnd.cwl
    in:
      dir: fastq_directory
    out: [reads]
  kraken2:
    run: cwl/krakenMainSingleEnd.cwl
    scatter: [read]
    scatterMethod: dotproduct
    in: 
      read: zerothstep/reads
      threads: threads
      threshold: threshold
      classification_level: classification_level
      db_path: db_path
      db_bracken: db_bracken
      index_chm13: index_chm13
      index_hg38: index_hg38
    out: [kraken2_output, kraken2_report, bracken_output, bracken_report_output]
