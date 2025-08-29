#!/usr/bin/env cwl-runner
class: ExpressionTool
cwlVersion: "v1.2"

requirements:
  InlineJavascriptRequirement: {}
  LoadListingRequirement:
    loadListing: shallow_listing
inputs: 
  dir: Directory

expression: |
        ${
          
          var files = inputs.dir.listing;

          var filesR1 = [];

          files.forEach(function (file) {
            if (file.basename.includes('fastq')) { 
                filesR1.push(file);
           }
          });

          return {"reads": filesR1};
         }

outputs:
  reads: File[]