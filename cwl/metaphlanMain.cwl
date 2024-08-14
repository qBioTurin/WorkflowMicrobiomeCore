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
  meta_path: Directory
  chocophlan_DB: Directory
  uniref_DB:  Directory

outputs:
  count-zerothstep_output:
    type: File
    outputSource: genomemapper/count-zerothstep_output
  count-genome_hg38_output:
    type: File
    outputSource: genomemapper/count-genome_hg38_output
  count-genome_chm13_output:
    type: File
    outputSource: genomemapper/count-genome_chm13_output
  metaphlan4_bowtie2:
    type: File
    outputSource: metaphlan4_flow/bowtie2
  metaphlan4_report:
    type: File
    outputSource: metaphlan4_flow/report
  metaphlan4_vsc:
    type: File
    outputSource: metaphlan4_flow/vsc_out
  humann3_gene_families:
    type: File
    outputSource: metaphlan4_flow/gene_families
  humann3_path_coverage:
    type: File
    outputSource: metaphlan4_flow/path_coverage
  humann3_path_abundance:
    type: File
    outputSource: metaphlan4_flow/path_abundance
  humann3_normalized_families:
    type: File
    outputSource: metaphlan4_flow/normalized_families
    

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
  metaphlan4_flow:
    run: ./metaphlanFlow.cwl
    in:
      read_1: genomemapper/unmapped_R1_chm13_output
      read_2: genomemapper/unmapped_R2_chm13_output
      threads: threads
      meta_path: meta_path
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
    out: [bowtie2, report, vsc_out,gene_families, path_coverage, path_abundance, temp_dir, normalized_families]  
