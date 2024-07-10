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
  meta_path:
    type: Directory
  chocophlan_DB: Directory
  uniref_DB:  Directory


outputs: 
  report_meta:
    type: File[]
    outputSource: metaphlan4_flow/report
  vsc_out: 
    type: File[]
    outputSource: metaphlan4_flow/vsc_out
  gene_families:  
    type: File[]
    outputSource: metaphlan4_flow/gene_families
  path_coverage:  
    type: File[]
    outputSource: metaphlan4_flow/path_coverage
  path_abundance:
    type: File[]
    outputSource: metaphlan4_flow/path_abundance
  normalized_families:
    type: File[]
    outputSource: metaphlan4_flow/normalized_families
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
  metaphlan4_flow:
    run: cwl/metaphlan_flow.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      read_1: genomemapper_chm13/unmapped_R1
      read_2: genomemapper_chm13/unmapped_R2
      threads: threads
      meta_path: meta_path
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
    out: [bowtie2, report, vsc_out,gene_families, path_coverage, path_abundance, temp_dir, normalized_families]
