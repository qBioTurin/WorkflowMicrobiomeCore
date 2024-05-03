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
          var filesR2 = [];

          files.forEach(function (file) {
            if (file.basename.includes('1.f')) {
              var correspondingFileR2 = file.basename.replace('1.f', '2.f');
              var fileR2 = files.find(function (f) {
                return f.basename === correspondingFileR2;
              });
              if (fileR2) {
                filesR1.push(file);
                filesR2.push(fileR2);
             }
           }
          });

          return {"reads_1": filesR1, "reads_2": filesR2};
         }

outputs:
  reads_1: File[]
  reads_2: File[]
