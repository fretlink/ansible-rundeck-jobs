let JSON = (../commons.dhall).JSON

let boolToText = (./base.dhall).boolToText

let Base = (./base.dhall).StepBase.Type

let Configuration = (./base.dhall).Configuration

let singleton = (./base.dhall).singleton

let boolWithDefault = (./base.dhall).boolWithDefault

let CopyFile =
      { sourcePath : Text
      , destinationPath : Text
      , pattern : Optional Text
      , echo : Optional Bool
      , recursive : Optional Bool
      }

let default = { pattern = None Text, echo = None Bool, recursive = None Bool }

let toYaml =
      λ(c : CopyFile) →
          [ { mapKey = "sourcePath", mapValue = JSON.string c.sourcePath }
          , { mapKey = "destinationPath"
            , mapValue = JSON.string c.destinationPath
            }
          , { mapKey = "echo", mapValue = boolWithDefault c.echo True }
          , { mapKey = "recursive"
            , mapValue = boolWithDefault c.recursive False
            }
          ]
        # singleton "pattern" c.pattern

let config =
      λ(c : CopyFile) →
        { type = "copyfile", nodeStep = True, configuration = toYaml c } : Base

in  { Type = CopyFile, config, default }
