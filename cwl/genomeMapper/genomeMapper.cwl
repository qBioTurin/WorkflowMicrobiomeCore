#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.index) ]

baseCommand: ["bash", "/scripts/genomeMapper.sh"]

inputs: 
  read_1:
    type: File
    inputBinding:
      position: 1
      prefix: --read1
  read_2:
    type: File?
    inputBinding:
      position: 2
      prefix: --read2
  index:
    doc: "Index used as reference"
    type: File[]
    inputBinding: 
      position: 3
      prefix: --index
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 1
    inputBinding:
      position: 4
      prefix: --threads

outputs:
  unmapped_R1:
    type: File
    outputBinding:
      glob: "*_final_unmapped_R1.fastq.gz"
  unmapped_R2:
    type: File?
    outputBinding:
      glob: "*_final_unmapped_R2.fastq.gz"
  read_fused:
    type: File
    outputBinding:
      glob: "*_final_unmapped.fastq"
