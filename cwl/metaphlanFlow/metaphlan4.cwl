#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)

baseCommand: ["bash", "/scripts/metaphlan4.sh"]

inputs: 
  read_1:
    doc: ""
    type: File
    inputBinding:
      position: 1  
      prefix: "--read1"
  read_2:
    doc: ""
    type: File?
    inputBinding:
      position: 2 
      prefix: "--read2"
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 4
    inputBinding:
      position: 3
      prefix: "--threads"
  meta_path:
    type: Directory
    inputBinding:
      position: 4
      prefix: "--bowtie2_db"
  stat_q:
    type: float?
    default: 0.2
    inputBinding:
      position: 5
      prefix: "--stat_q"

outputs:
  bowtie2:
    type: File
    outputBinding:
      glob: "*.bowtie2.bz2" 
  report:
    type: File
    outputBinding:
      glob: "*_output.txt"
