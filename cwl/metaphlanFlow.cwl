#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}

inputs:
    read_1: File
    read_2: File
    threads: int?
    meta_path: Directory
    chocophlan_DB: Directory    
    uniref_DB: Directory

outputs:
    bowtie2: 
        type: File
        outputSource: metaphlan4/bowtie2
    report:
        type: File
        outputSource: metaphlan4/report
    vsc_out:   
        type: File
        outputSource: metaphlan4/vsc_out
    gene_families: 
        type: File
        outputSource: humann3/gene_families
    path_coverage: 
        type: File
        outputSource: humann3/path_coverage
    path_abundance: 
        type: File
        outputSource: humann3/path_abundance
    temp_dir: 
        type: Directory
        outputSource: humann3/temp_dir
    normalized_families:
        type: File
        outputSource: normalization/normalized_families
  
  
steps:
  metaphlan4:
    run: metaphlanFlow/metaphlan4.cwl
    in:
      read_1: read_1
      read_2: read_2
      threads: threads
      meta_path: meta_path
    out: [bowtie2, report, vsc_out]
  fuse_reads:
    run: metaphlanFlow/fuseReads.cwl
    in:
      read_1: read_1
      read_2: read_2
      threads: threads
    out: [read_fused]
  humann3:
    run: metaphlanFlow/humann3.cwl
    in:
      read_fused: fuse_reads/read_fused
      report: metaphlan4/report
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      threads: threads
    out: [gene_families, path_coverage, path_abundance, temp_dir]
  normalization:
    run: metaphlanFlow/humann3_normalization.cwl
    in:
      gene_families: humann3/gene_families
    out: [normalized_families]
