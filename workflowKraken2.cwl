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
  count-zerothstep_output:
    type: File[]
    outputSource: kraken2/count-zerothstep_output
  count-genome_hg38_output:
    type: File[]
    outputSource: kraken2/count-genome_hg38_output
  count-genome_chm13_output:
    type: File[]
    outputSource: kraken2/count-genome_chm13_output

steps:
  zerothstep:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  kraken2:
    run: cwl/krakenMain.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in: 
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
      threads: threads
      threshold: threshold
      classification_level: classification_level
      db_path: db_path
      db_bracken: db_bracken
      index_chm13: index_chm13
      index_hg38: index_hg38
    out: [kraken2_output, kraken2_report, bracken_output, bracken_report_output, count-zerothstep_output, count-genome_hg38_output, count-genome_chm13_output]
