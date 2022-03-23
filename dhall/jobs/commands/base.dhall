let JSON = (../commons.dhall).JSON

let Script = ./base/script.dhall

let ScriptFile = ./base/script-file.dhall

let ScriptURL = ./base/script-url.dhall

let SimpleCommand = ./base/simple-command.dhall

let JobReference = ./base/job-reference.dhall

let PluginStep = ./base/plugin-step.dhall

let ErrorHandlerCommand = (./error-handler.dhall).ErrorHandlerCommand

let textSingleton = (../commons.dhall).textSingleton

let singleton = (../commons.dhall).singleton

let CommandBase =
      let CommandBaseType =
            < SimpleCommand : SimpleCommand.Type
            | Script : Script.Type
            | ScriptFile : ScriptFile.Type
            | ScriptURL : ScriptURL.Type
            | JobReference : JobReference.Type
            | PluginStep : PluginStep.Type
            >

      in  { Type = CommandBaseType
          , toYamlMap =
              λ(c : CommandBaseType) →
                merge
                  { SimpleCommand =
                      λ(t : SimpleCommand.Type) → SimpleCommand.toYamlMap t
                  , Script = λ(t : Script.Type) → Script.toYamlMap t
                  , ScriptFile = λ(t : ScriptFile.Type) → ScriptFile.toYamlMap t
                  , ScriptURL = λ(t : ScriptURL.Type) → ScriptURL.toYamlMap t
                  , JobReference =
                      λ(t : JobReference.Type) → JobReference.toYamlMap t
                  , PluginStep = λ(t : PluginStep.Type) → PluginStep.toYamlMap t
                  }
                  c
          }

let Command =
      let CommandType =
            { base : CommandBase.Type
            , description : Optional Text
            , errorHandler : Optional ErrorHandlerCommand.Type
            }

      in  { Type = CommandType
          , toYaml =
              λ(c : CommandType) →
                JSON.object
                  (   CommandBase.toYamlMap c.base
                    # textSingleton "description" c.description
                    # singleton
                        "errorHandler"
                        ErrorHandlerCommand.Type
                        ErrorHandlerCommand.toYaml
                        c.errorHandler
                  )
          , default =
            { description = None Text
            , errorHandler = None ErrorHandlerCommand.Type
            }
          }

in    { Command
      , CommandBase
      , Script
      , SimpleCommand
      , ScriptFile
      , ScriptURL
      , JobReference
      , PluginStep
      }
    ∧ ./error-handler.dhall
