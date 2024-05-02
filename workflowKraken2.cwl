#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  fastq_directory: Directory
  threads: int?
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
    outputSource: kraken2/kraken2
  kraken2_report:
    type: File[]
    outputSource: kraken2/report
  kraken-biom_output:
    type: File
    outputSource: kraken-biom/biom

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
      index: index_hg38
      threads: threads
    out: [unmapped_R1, unmapped_R2]
  genomemapper_chm13:
    run: cwl/genomeMapper_chm13.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_hg38/unmapped_R1 
      read_2: genomemapper_hg38/unmapped_R2
      index: index_chm13
      threads: threads
    out: [unmapped_R1, unmapped_R2]
  kraken2:
    run: cwl/kraken2.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_chm13/unmapped_R1
      read_2: genomemapper_chm13/unmapped_R2
      db_path: db_path
      threads: threads
    out: [kraken2, report] 
  kraken-biom:
    run: cwl/kraken-biom.cwl
    in:
      kraken_report: kraken2/report
    out: [biom] 
