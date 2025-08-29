#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}

inputs:
  read: File
  threads: int?
  threshold: int?
  classification_level: string?
  db_path: 
    type:
      - Directory
      - File
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  db_bracken: File

outputs:
  kraken2_output:
    type: File
    outputSource: kraken2/kraken2
  kraken2_report:
    type: File
    outputSource: kraken2/report
  bracken_output:
    type: File
    outputSource: bracken/bracken
  bracken_report_output:
    type: File
    outputSource: bracken/report_bracken
  
steps:
  kraken2:
    run: krakenFlow/kraken2SingleEnd.cwl
    in:
      read: read
      db_path: db_path
      threads: threads
    out: [kraken2, report] 
  bracken:
    run: krakenFlow/bracken.cwl
    in:
      report: kraken2/report
      kmer_distrib: db_bracken
      classification_level: classification_level
      threshold: threshold  
    out: [bracken, report_bracken]
