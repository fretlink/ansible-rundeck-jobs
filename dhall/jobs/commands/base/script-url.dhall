let JSON = (../../commons.dhall).JSON

let singleton = (../../commons.dhall).singleton

let textSingleton = (../../commons.dhall).textSingleton

let ScriptURLType =
      { scripturl : Text
      , args : Optional Text
      , scriptInterpreter : Optional Text
      , interpreterArgsQuoted : Optional Bool
      }

in  { Type = ScriptURLType
    , toYamlMap =
        λ(t : ScriptURLType) →
            [ { mapKey = "scripturl", mapValue = JSON.string t.scripturl } ]
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
