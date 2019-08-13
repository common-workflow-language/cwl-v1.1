class: CommandLineTool
cwlVersion: v1.1
baseCommand: []
inputs: []
outputs: []
arguments:
- position: 1
  shellQuote: false
  valueFrom: "non_existing_app"
- position: 0
  prefix: ''
  separate: false
  shellQuote: false
  valueFrom: "echo"
requirements:
- class: ShellCommandRequirement
