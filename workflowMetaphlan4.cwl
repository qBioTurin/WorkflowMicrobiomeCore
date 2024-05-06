#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  fastq_directory: Directory
  threads: int?
  index_hg38:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
  index_chm13:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  meta_path:
    type: Directory

outputs: 
  bowtie2:
    type: File[]
    outputSource: metaphlan4/bowtie2
  report:
    type: File[]
    outputSource: metaphlan4/report
  biom_output:
    type: File[]
    outputSource: metaphlan4/biom_output
  final_table:
    type: File
    outputSource: merge_bioms/final_table
  count-zerothstep_output:
    type: File[]
    outputSource: count-zerothstep/count
  count-genome_hg38_output:
    type: File[]
    outputSource: count-genome_hg38/count
  count-genome_chm13_output:
    type: File[]
    outputSource: count-genome_chm13/count

steps:
  zerothstep:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  count-zerothstep:
    run: cwl/countFastq.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
    out: [count]
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
  count-genome_hg38:
    run: cwl/countFastq.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_hg38/unmapped_R1
      read_2: genomemapper_hg38/unmapped_R2
    out: [count]
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
  count-genome_chm13:
    run: cwl/countFastq.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_chm13/unmapped_R1
      read_2: genomemapper_chm13/unmapped_R2
    out: [count]
  metaphlan4:
    run: cwl/metaphlan4.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_chm13/unmapped_R1
      read_2: genomemapper_chm13/unmapped_R2
      threads: threads
      meta_path: meta_path
    out: [bowtie2, report, biom_output] 
  merge_bioms:
    run: cwl/merge_bioms.cwl
    in: 
      biom_output: metaphlan4/biom_output
    out: [final_table]
