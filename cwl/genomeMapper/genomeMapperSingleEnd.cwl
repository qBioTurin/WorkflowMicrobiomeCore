#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool


requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.index) ]

baseCommand: ["bash", "/scripts/genomeMapperSingleEnd.sh"]

inputs: 
  read_1:
    type: File
    inputBinding:
      position: 1
  index:
    doc: "Index used as reference"
    type: File
    inputBinding: 
      position: 3 
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 1
    inputBinding:
      position: 4

outputs:
  unmapped:
    type: File
    outputBinding:
      glob: "*_unmapped.fastq.gz"
