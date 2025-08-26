#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement: 
    listing:
      - entry: $(inputs.report)
        writable: True

hints:
  DockerRequirement:
    dockerPull: "qbioturin/kraken2:0.1.1"

baseCommand: ["python3", "/transformInMeta.py"]

inputs: 
  report:
    type: File
    inputBinding:
        position: 1

outputs:
    final_report:
        type: File
        outputBinding:
            glob: "*_output.tsv" 