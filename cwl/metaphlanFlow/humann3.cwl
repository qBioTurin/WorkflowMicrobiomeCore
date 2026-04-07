cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: qbioturin/humann3:0.0.3

baseCommand: ["humann"]


inputs:
  read_fused:
    type: File
    inputBinding:
      position: 1
      prefix: --input  
  report:
    type: File
    inputBinding:
      position: 3
      prefix: --taxonomic-profile
  chocophlan_DB:
    type: Directory
    inputBinding:
      position: 4
      prefix: --nucleotide-database
  uniref_DB:
    type: Directory
    inputBinding:
      position: 5
      prefix: --protein-database
  threads:
    doc: "Maximum number of compute threads"
    type: int?
    default: 1
    inputBinding:
      position: 6
      prefix: --threads
  output_prefix:
    type: string?
    default: ""
arguments: ["--output","./", "--input-format","fastq"]
 
     
outputs:
  gene_families:
    type: File
    outputBinding:
      glob: "*genefamilies.tsv"
      outputEval: ${
          self[0].basename = inputs.read_fused.nameroot + "_" + inputs.output_prefix + "_genefamilies.tsv";
          return self; }
  path_coverage:
    type: File
    outputBinding:
      glob: "*pathcoverage.tsv"
      outputEval: ${
          self[0].basename = inputs.read_fused.nameroot + "_" + inputs.output_prefix + "_pathcoverage.tsv";
          return self; }
  path_abundance:
    type: File
    outputBinding:
      glob: "*pathabundance.tsv"
      outputEval: ${
          self[0].basename = inputs.read_fused.nameroot + "_" + inputs.output_prefix + "_pathabundance.tsv";
          return self; }
