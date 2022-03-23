let JSON = (./commons.dhall).JSON

let ExportVar = ./plugins/export-var.dhall

let CopyFile = ./plugins/copyfile.dhall

let HttpStep = ./plugins/http-step.dhall

let Slack = ./plugins/slack-notification.dhall

let Base = (./plugins/base.dhall).Base

let StepBase = (./plugins/base.dhall).StepBase

let StepPlugin =
      let StepPluginType =
            < ExportVar : ExportVar.Type
            | CopyFile : CopyFile.Type
            | HttpStep : HttpStep.Type
            >

      let toYamlMap =
            λ(t : StepPluginType) →
              StepBase.toYamlMap
                ( merge
                    { ExportVar = ExportVar.config
                    , CopyFile = CopyFile.config
                    , HttpStep = HttpStep.config
                    }
                    t
                )

      in  { Type = StepPluginType
          , ExportVar
          , CopyFile
          , HttpStep
          , toYamlMap
          , toYaml = λ(t : StepPluginType) → JSON.object (toYamlMap t)
          }

let Plugin =
      let PluginType = < Slack : Slack.Type >

      let toYamlMap =
            λ(t : PluginType) →
              Base.toYamlMap (merge { Slack = Slack.config } t)

      in  { Type = PluginType
          , Slack
          , toYamlMap
          , toYaml = λ(t : PluginType) → JSON.object (toYamlMap t)
          }

in  { StepPlugin, Plugin }
