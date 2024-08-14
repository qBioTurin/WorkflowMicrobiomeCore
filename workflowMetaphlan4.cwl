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
  meta_path: Directory
  chocophlan_DB: Directory
  uniref_DB:  Directory


outputs: 
  report_meta:
    type: File[]
    outputSource: metaphlan_humann/metaphlan4_report
  vsc_out: 
    type: File[]
    outputSource: metaphlan_humann/metaphlan4_vsc
  gene_families:  
    type: File[]
    outputSource: metaphlan_humann/humann3_gene_families
  path_coverage:  
    type: File[]
    outputSource: metaphlan_humann/humann3_path_coverage
  path_abundance:
    type: File[]
    outputSource: metaphlan_humann/humann3_path_abundance
  normalized_families:
    type: File[]
    outputSource: metaphlan_humann/humann3_normalized_families
  count-zerothstep_output:
    type: File[]
    outputSource: metaphlan_humann/count-zerothstep_output
  count-genome_hg38_output:
    type: File[]
    outputSource: metaphlan_humann/count-genome_hg38_output
  count-genome_chm13_output:
    type: File[]
    outputSource: metaphlan_humann/count-genome_chm13_output

steps:
  zerothstep:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  metaphlan_humann: 
    run: cwl/metaphlanMain.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in: 
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
      threads: threads
      index_chm13: index_chm13
      index_hg38: index_hg38
      meta_path: meta_path
      chocophlan_DB: chocophlan_DB
      uniref_DB:  uniref_DB
    out: [count-zerothstep_output, count-genome_hg38_output, count-genome_chm13_output, metaphlan4_bowtie2, metaphlan4_report, metaphlan4_vsc, humann3_gene_families, humann3_path_coverage, humann3_path_abundance, humann3_normalized_families]
