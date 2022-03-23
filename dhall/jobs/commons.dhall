let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/package.dhall sha256:eb693342eb769f782174157eba9b5924cf8ac6793897fc36a31ccbd6f56dafe2

let Map = Prelude.Map.Type

let JSON = Prelude.JSON

let IntSpec =
      let IntSpecType = < Number : Natural | Variable : Text >

      in  { Type = IntSpecType
          , toYaml =
              λ(t : IntSpecType) →
                JSON.string
                  ( merge
                      { Number = Natural/show
                      , Variable = λ(variable : Text) → variable
                      }
                      t
                  )
          }

let Size =
      let SizeUnit = < Bytes | KiloBytes | MegaBytes | GigaBytes >

      let SizeType = { value : Natural, unit : SizeUnit }

      in  { Type = SizeType
          , Unit = SizeUnit
          , show =
              λ(t : SizeType) →
                    Natural/show t.value
                ++  merge
                      { Bytes = "B"
                      , KiloBytes = "KB"
                      , MegaBytes = "MB"
                      , GigaBytes = "GB"
                      }
                      t.unit
          }

let RankOrder =
      let RankOrderType = < Ascending | Descending >

      in  { Type = RankOrderType
          , toYaml =
              λ(t : RankOrderType) →
                JSON.string
                  ( merge
                      { Ascending = "ascending", Descending = "descending" }
                      t
                  )
          }

let JSONMap = Map Text JSON.Type

let textSingleton =
      λ(name : Text) →
      λ(t : Optional Text) →
        merge
          { None = [] : JSONMap
          , Some = λ(t : Text) → [ { mapKey = name, mapValue = JSON.string t } ]
          }
          t

let singleton =
      λ(name : Text) →
      λ(type : Type) →
      λ(f : type → JSON.Type) →
      λ(t : Optional type) →
        merge
          { None = [] : JSONMap
          , Some = λ(t : type) → [ { mapKey = name, mapValue = f t } ]
          }
          t

in  { Prelude
    , JSON
    , JSONMap
    , RankOrder
    , IntSpec
    , Size
    , singleton
    , textSingleton
    }
