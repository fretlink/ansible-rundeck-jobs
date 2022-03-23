let JSON = (../commons.dhall).JSON

let Configuration = (../commons.dhall).JSONMap

let boolToText =
      λ(b : Bool) → if b then JSON.string "true" else JSON.string "false"

let singleton = (../commons.dhall).textSingleton

let someToMap =
      λ(key : Text) →
      λ(t : Type) →
      λ(f : t → Configuration) →
      λ(b : Optional t) →
        merge
          { None = [ { mapKey = key, mapValue = boolToText False } ]
          , Some =
              λ(c : t) → [ { mapKey = key, mapValue = boolToText True } ] # f c
          }
          b

let boolWithDefault =
      λ(b : Optional Bool) →
      λ(default : Bool) →
        merge { None = boolToText default, Some = boolToText } b

let Base =
      let BaseType = { type : Text, configuration : Configuration }

      let toYamlMap =
            λ(b : BaseType) →
              [ { mapKey = "type", mapValue = JSON.string b.type }
              , { mapKey = "configuration"
                , mapValue = JSON.object b.configuration
                }
              ]

      in  { Type = BaseType
          , toYamlMap
          , toYaml = λ(b : BaseType) → JSON.object (toYamlMap b)
          }

let StepBase =
      let StepBaseType = Base.Type ⩓ { nodeStep : Bool }

      let toYamlMap =
            λ(b : StepBaseType) →
              [ { mapKey = "type", mapValue = JSON.string b.type }
              , { mapKey = "configuration"
                , mapValue = JSON.object b.configuration
                }
              , { mapKey = "nodeStep", mapValue = JSON.bool b.nodeStep }
              ]

      in  { Type = StepBaseType
          , toYamlMap
          , toYaml = λ(b : StepBaseType) → JSON.object (toYamlMap b)
          }

in  { StepBase
    , Base
    , Configuration
    , singleton
    , boolToText
    , someToMap
    , boolWithDefault
    }
