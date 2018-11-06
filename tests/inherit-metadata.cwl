#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.1.0-dev1
baseCommand:
  - echo
  - this
  - file
  - has
  - metadata
inputs:
  - id: input_file
    type: File
  - id: input_list
    type: File[]
outputs:
  - id: out
    type: File
    secondaryFiles:
      - $(self.basename)
    outputBinding:
      glob: out
      addMetadata: $(inputs.input_file.metadata)
  - id: out_intersected
    type: File[]
    secondaryFiles:
      - $(self.basename)
    outputBinding:
      glob: out
      addMetadata: 
      - input_file
      - input_list
requirements:
  - class: DockerRequirement
    dockerPull: 'debian:stretch-slim'
  - class: InlineJavascriptRequirement
stdout: out