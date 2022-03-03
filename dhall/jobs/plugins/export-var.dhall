let JSON = (../commons.dhall).JSON

let Base = (./base.dhall).StepBase.Type

let ExportVar = { export : Text, group : Text, value : Text }

let default = {=}

let toYaml =
      λ(c : ExportVar) →
        [ { mapKey = "export", mapValue = JSON.string c.export }
        , { mapKey = "group", mapValue = JSON.string c.group }
        , { mapKey = "value", mapValue = JSON.string c.value }
        ]

let config =
      λ(c : ExportVar) →
          { type = "export-var", nodeStep = False, configuration = toYaml c }
        : Base

in  { Type = ExportVar, config, default }
