#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}

inputs:
  read_1: File
  read_2: File
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
  unmapped_R1_chm13_output:
    type: File
    outputSource: genomemapper_chm13/unmapped_R1
  unmapped_R2_chm13_output:
    type: File
    outputSource: genomemapper_chm13/unmapped_R2
  count-zerothstep_output:
    type: File
    outputSource: count-zerothstep/count
  count-genome_hg38_output:
    type: File
    outputSource: count-genome_hg38/count
  count-genome_chm13_output:
    type: File
    outputSource: count-genome_chm13/count 
  
steps:
  count-zerothstep:
    run: genomeMapper/countFastq.cwl
    in:
      read_1: read_1
      read_2: read_2
    out: [count]
  genomemapper_hg38:
    run: genomeMapper/genomeMapper.cwl
    in:
      read_1: read_1
      read_2: read_2
      index: index_hg38
      threads: threads
    out: [unmapped_R1, unmapped_R2]
  count-genome_hg38:
    run: genomeMapper/countFastq.cwl
    in:
      read_1: genomemapper_hg38/unmapped_R1
      read_2: genomemapper_hg38/unmapped_R2
    out: [count]
  genomemapper_chm13:
    run: genomeMapper/genomeMapper_chm13.cwl
    in:
      read_1: genomemapper_hg38/unmapped_R1 
      read_2: genomemapper_hg38/unmapped_R2
      index: index_chm13
      threads: threads
    out: [unmapped_R1, unmapped_R2]
  count-genome_chm13:
    run: genomeMapper/countFastq.cwl
    in:
      read_1: genomemapper_chm13/unmapped_R1
      read_2: genomemapper_chm13/unmapped_R2
    out: [count]
