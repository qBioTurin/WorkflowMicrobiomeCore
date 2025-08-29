#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}

inputs:
  read: File
  threads: int?
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
  unmapped_chm13_output:
    type: File
    outputSource: genomemapper_chm13/unmapped
  
steps:
  genomemapper_hg38:
    run: genomeMapper/genomeMapperSingleEnd.cwl
    in:
      read_1: read
      index: index_hg38
      threads: threads
    out: [unmapped]
  genomemapper_chm13:
    run: genomeMapper/genomeMapper_chm13SingleEnd.cwl
    in:
      read: genomemapper_hg38/unmapped
      index: index_chm13
      threads: threads
    out: [unmapped]
