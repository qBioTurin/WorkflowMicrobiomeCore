cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: qbioturin/kraken2:0.1.10

baseCommand: ["python3", "/Bracken-2.9/src/est_abundance.py"]
arguments:
  - valueFrom: result.bracken
    prefix: -o
  - valueFrom: result_bracken.report
    prefix: --out-report

inputs:
  report: 
    type: File
    inputBinding:
      position: 2
      prefix: -i
  kmer_distrib:
    type: File
    inputBinding:
      position: 3
      prefix: -k
  classification_level:
    type: string?
    default: "S"
    inputBinding:
      position: 4
      prefix: -l
  threshold:
    type: int?
    default: 10
    inputBinding:
      position: 5
      prefix: -t 
     
outputs:
  bracken:
    type: File
    outputBinding:
      glob: result.bracken
      outputEval: ${
          self[0].basename = inputs.report.nameroot + ".bracken";
          return self; }
  report_bracken: 
    type: File
    outputBinding:
      glob: result_bracken.report
      outputEval: ${
          self[0].basename = inputs.report.nameroot + "_bracken.report";
          return self; }
