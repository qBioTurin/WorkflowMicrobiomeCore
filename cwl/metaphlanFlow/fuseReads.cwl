cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMax: $(inputs.threads)
  InitialWorkDirRequirement: 
    listing:
      - entry: $(inputs.read_1)
        writable: True
      - entry: $(inputs.read_2)
        writable: True

hints:
  DockerRequirement:
    dockerPull: scontaldo/humanmapper

baseCommand: ["bash", "/scripts/fuseReads.sh"]

inputs:  
  read_1:
    type: File
    inputBinding:
      position: 1
  read_2:
    type: File
    inputBinding:
      position: 2
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 1
    inputBinding:
      position: 3

outputs:
  read_fused:
    type: File
    outputBinding:
      glob: "*_fused.fastq"
