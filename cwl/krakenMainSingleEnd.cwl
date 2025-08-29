#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  read: File
  threads: int?
  threshold: int?
  classification_level: string?
  db_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  db_bracken: File
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
    type: File
    outputSource: kraken2/kraken2_output
  kraken2_report:
    type: File
    outputSource: kraken2/kraken2_report
  bracken_output:
    type: File
    outputSource: kraken2/bracken_output
  bracken_report_output:
    type: File
    outputSource: kraken2/bracken_report_output

steps:
  genomemapper:
    run: ./genomeMapperSingleEnd.cwl
    in:
      read: read
      threads: threads
      index_chm13: index_chm13
      index_hg38: index_hg38
    out: [unmapped_chm13_output] 
  kraken2:
    run: krakenFlowSingleEnd.cwl
    in:
      read: genomemapper/unmapped_chm13_output
      threads: threads
      threshold: threshold
      classification_level: classification_level
      db_path: db_path
      db_bracken: db_bracken
    out: [kraken2_output, kraken2_report, bracken_output, bracken_report_output]
