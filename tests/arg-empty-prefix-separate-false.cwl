class: CommandLineTool
cwlVersion: v1.1
baseCommand: []
inputs: []
outputs: 
  out:
    type: File
    outputBinding:
      glob: out
arguments:
- position: 1
  shellQuote: false
  valueFrom: "non_existing_app"
- position: 0
  prefix: ''
  separate: false
  shellQuote: false
  valueFrom: "echo"
stdout: out
requirements:
- class: ShellCommandRequirement
