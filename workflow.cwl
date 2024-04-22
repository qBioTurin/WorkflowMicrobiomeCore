#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  fastq_directory: Directory
  threads: int?
  index:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa

outputs: 
  genomemapper_unmapped_hg38_R1:
    type: File[]
    outputSource: genomemapper_hg38/unmapped_R1
  genomemapper_unmapped_hg38_R2:
    type: File[]
    outputSource: genomemapper_hg38/unmapped_R2

steps:
  zerothstep:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  genomemapper_hg38:
    run: cwl/genomeMapper.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
      index: index
      threads: threads
    out: [unmapped_R1, unmapped_R2]
