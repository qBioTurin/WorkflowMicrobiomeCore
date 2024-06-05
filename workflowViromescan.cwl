#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  fastq_directory: Directory
  threads: int?
  scan_type: string
  viro_db: Directory

outputs: 
  viromescan_output: 
    type: Directory[]
    outputSource: viromescan/output

steps:
  zerothstep:
    run: cwl/zerothStepPairedEnd.cwl
    in:
      dir: fastq_directory
    out: [reads_1, reads_2]
  viromescan:
    run: cwl/viromescan.cwl
    scatter: [read_1, read_2]
    scatterMethod: dotproduct
    in:
      threads: threads
      viro_db: viro_db
      scan_type: scan_type
      read_1: zerothstep/reads_1
      read_2: zerothstep/reads_2
    out: [output]
