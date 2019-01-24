cwlVersion: v1.1.0-dev1
class: Workflow
requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
inputs: {}
outputs:
  contains_b:
    type: boolean
    outputSource: check_file/contains_b

steps:
  create_file:
    run:
      class: ExpressionTool
      requirements: { InlineJavascriptRequirement: {} }
      inputs: { }
      outputs: { lit: File }
      expression: |
        ${
           var contents = "a".repeat(Math.pow(2, 20)) + "b";
           return { "lit": { "class": "File", "basename": "lit", "contents": contents } };
        }
    in: {}
    out: [ lit ]
  check_file:
    run:
      class: ExpressionTool
      requirements: { InlineJavascriptRequirement: {} }
      inputs: { lit: string }
      outputs: { contains_b: boolean }
      expression: |
        ${
           return { "contains_b": inputs.lit.indexOf("b") >= 0 };
        }
    in:
      lit:
        source: create_file/lit
        loadContents: true
        valueFrom: $(self.contents)

    out: [ contains_b ]
