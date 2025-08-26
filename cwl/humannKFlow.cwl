#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  kraken_folder: Directory
  threads: int
  read_1: File
  read_2: File
  chocophlan_DB: Directory
  uniref_DB:  Directory

outputs:
  gene_families:
    type: File
    outputSource: humann3/gene_families
  path_coverage:
    type: File
    outputSource: humann3/path_coverage
  path_abundance:
    type: File
    outputSource: humann3/path_abundance

steps:
  find_report:
    run: krakenFlow/findReport.cwl
    in:
      read_1: read_1
      kraken_folder: kraken_folder
    out: [report]
  report_to_metaphlan:
    run: krakenFlow/reportToMetaphlan.cwl
    in:
      report: find_report/report
    out: [mid_report]
  report_count_abound:
    run: krakenFlow/reportCountAbound.cwl
    in:
      report: report_to_metaphlan/mid_report
    out: [final_report]
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
      report: report_count_abound/final_report
      chocophlan_DB: chocophlan_DB
      uniref_DB: uniref_DB
      threads: threads
    out: [gene_families, path_coverage, path_abundance]