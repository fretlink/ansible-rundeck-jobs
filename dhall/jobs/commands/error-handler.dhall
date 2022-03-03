let JSON = (../commons.dhall).JSON

let Script = ./base/script.dhall

let ScriptFile = ./base/script-file.dhall

let ScriptURL = ./base/script-url.dhall

let SimpleCommand = ./base/simple-command.dhall

let JobReference = ./base/job-reference.dhall

let textSingleton = (../commons.dhall).textSingleton

let singleton = (../commons.dhall).singleton

let ErrorHandlerCommandBase =
      let ErrorHandlerCommandBaseType =
            < SimpleCommand : SimpleCommand.Type
            | Script : Script.Type
            | ScriptFile : ScriptFile.Type
            | ScriptURL : ScriptURL.Type
            | JobReference : JobReference.Type
            >

      in  { Type = ErrorHandlerCommandBaseType
          , toYamlMap =
              λ(c : ErrorHandlerCommandBaseType) →
                merge
                  { SimpleCommand =
                      λ(t : SimpleCommand.Type) → SimpleCommand.toYamlMap t
                  , Script = λ(t : Script.Type) → Script.toYamlMap t
                  , ScriptFile = λ(t : ScriptFile.Type) → ScriptFile.toYamlMap t
                  , ScriptURL = λ(t : ScriptURL.Type) → ScriptURL.toYamlMap t
                  , JobReference =
                      λ(t : JobReference.Type) → JobReference.toYamlMap t
                  }
                  c
          }

let ErrorHandlerCommand =
      let ErrorHandlerCommandType =
            { base : ErrorHandlerCommandBase.Type
            , description : Optional Text
            , keepgoingOnSuccess : Optional Bool
            }

      in  { Type = ErrorHandlerCommandType
          , toYaml =
              λ(c : ErrorHandlerCommandType) →
                JSON.object
                  (   ErrorHandlerCommandBase.toYamlMap c.base
                    # textSingleton "description" c.description
                    # singleton
                        "keepgoingOnSuccess"
                        Bool
                        JSON.bool
                        c.keepgoingOnSuccess
                  )
          }

in  { ErrorHandlerCommandBase, ErrorHandlerCommand }
