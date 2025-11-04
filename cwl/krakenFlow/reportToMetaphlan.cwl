#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["python3", "/scripts/kraken2mpa.py"]

inputs: 
  report:
    type: File
    inputBinding:
        position: 1
        prefix: "-r"

arguments:
  - valueFrom: $(inputs.report.nameroot + "_mpa.tsv") 
    prefix: "-o"

outputs:
    mid_report:
        type: File
        outputBinding:
            glob: "*_mpa.tsv" 