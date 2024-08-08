#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  read_1: File
  read_2: File
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
  count-zerothstep_output:
    type: File
    outputSource: genomemapper/count-zerothstep_output
  count-genome_hg38_output:
    type: File
    outputSource: genomemapper/count-genome_hg38_output
  count-genome_chm13_output:
    type: File
    outputSource: genomemapper/count-genome_chm13_output

steps:
  genomemapper:
    run: ./genomeMapper.cwl
    in:
      read_1: read_1
      read_2: read_2
      threads: threads
      index_chm13: index_chm13
      index_hg38: index_hg38
    out: [unmapped_R1_chm13_output, unmapped_R2_chm13_output, count-zerothstep_output, count-genome_hg38_output, count-genome_chm13_output] 
  kraken2:
    run: krakenFlow.cwl
    in:
      read_1: genomemapper/unmapped_R1_chm13_output
      read_2: genomemapper/unmapped_R2_chm13_output
      threads: threads
      threshold: threshold
      classification_level: classification_level
      db_path: db_path
      db_bracken: db_bracken
    out: [kraken2_output, kraken2_report, bracken_output, bracken_report_output]
