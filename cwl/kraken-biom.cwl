#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Get .biom from kraken results 

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["kraken-biom"]

inputs: 
  kraken_report:
    doc: "Kraken Report"
    type: File[]
    inputBinding:
      position: 1
  fmt:
    doc: ""
    type: string
    default: json
    inputBinding:
      position: 2
      prefix: --fmt
  biom_name:
    doc: ""
    type: string
    default: table.biom
    inputBinding:
      position: 3
      prefix: -o

outputs:
  biom:
    type: File
    outputBinding:
      glob: $(inputs.biom_name)
