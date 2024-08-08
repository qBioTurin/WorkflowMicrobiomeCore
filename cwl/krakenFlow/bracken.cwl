cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["python3", "/Bracken-2.9/src/est_abundance.py"]
arguments:
  - valueFrom: $(runtime.outdir)/result.bracken
    prefix: -o
  - valueFrom: $(runtime.outdir)/result_bracken.report
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
      glob: "$(runtime.outdir)/result.bracken"
      outputEval: ${
          self[0].basename = inputs.report.nameroot + ".bracken";
          return self; }
  report_bracken: 
    type: File
    outputBinding:
      glob: "$(runtime.outdir)/result_bracken.report"
      outputEval: ${
          self[0].basename = inputs.report.nameroot + "_bracken.report";
          return self; }
