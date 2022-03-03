let JSON = (../../commons.dhall).JSON

let singleton = (../../commons.dhall).singleton

let textSingleton = (../../commons.dhall).textSingleton

let ScriptType =
      { script : Text
      , args : Optional Text
      , scriptInterpreter : Optional Text
      , interpreterArgsQuoted : Optional Bool
      }

in  { Type = ScriptType
    , toYamlMap =
        λ(t : ScriptType) →
            [ { mapKey = "script", mapValue = JSON.string t.script } ]
          # textSingleton "args" t.args
          # textSingleton "scriptInterpreter" t.scriptInterpreter
          # singleton
              "interpreterArgsQuoted"
              Bool
              JSON.bool
              t.interpreterArgsQuoted
    , default =
      { scriptInterpreter = None Text
      , args = None Text
      , interpreterArgsQuoted = None Bool
      }
    }
