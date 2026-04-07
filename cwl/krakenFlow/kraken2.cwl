#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: qbioturin/kraken2:0.1.10


baseCommand: ["bash", "/scripts/Kraken2.sh"]

inputs: 
  read_1:
    type: File
    inputBinding:
      position: 1  
      prefix: "--read1"
  read_2:
    type: File?
    inputBinding:
      position: 2
      prefix: "--read2"
  db_path:
    type: 
      - Directory
      - File
    inputBinding:
      position: 3
      prefix: "--database"
      valueFrom: |
        ${ return (self.class == "File") ? self.dirname : self.path }
    secondaryFiles:
      - $("opts.k2d")
      - $("taxo.k2d")
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: "--threads"
  confidence:
    type: float?
    default: 0.0
    inputBinding:
      position: 5
      prefix: "--confidence"

outputs:
  kraken2:
    type: File
    outputBinding:
      glob: "*.kraken2" 
  report:
    type: File
    outputBinding:
      glob: "*.report"
