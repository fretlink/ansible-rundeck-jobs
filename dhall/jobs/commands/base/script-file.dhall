let JSON = (../../commons.dhall).JSON

let singleton = (../../commons.dhall).singleton

let textSingleton = (../../commons.dhall).textSingleton

let ScriptFileType =
      { scriptfile : Text
      , args : Optional Text
      , scriptInterpreter : Optional Text
      , interpreterArgsQuoted : Optional Bool
      }

in  { Type = ScriptFileType
    , toYamlMap =
        λ(t : ScriptFileType) →
            [ { mapKey = "scriptfile", mapValue = JSON.string t.scriptfile } ]
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
