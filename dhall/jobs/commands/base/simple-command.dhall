let JSON = (../../commons.dhall).JSON

let SimpleCommandType = { exec : Text }

in  { Type = SimpleCommandType
    , toYamlMap =
        λ(t : SimpleCommandType) →
          [ { mapKey = "exec", mapValue = JSON.string t.exec } ]
    , default = {=}
    }
