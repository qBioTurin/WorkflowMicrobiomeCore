#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Metaphlan4 mapping 

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
  read_2:
    doc: ""
    type: File
    inputBinding:
      position: 2 
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 1
    inputBinding:
      position: 3
  meta_path:
    type: Directory
    inputBinding:
      position: 4

outputs:
  bowtie2:
    type: File
    outputBinding:
      glob: "*.bowtie2.bz2" 
  report:
    type: File
    outputBinding:
      glob: "*_output.txt"
  vsc_out:
    type: File
    outputBinding:
      glob: "*.vsc.txt"
