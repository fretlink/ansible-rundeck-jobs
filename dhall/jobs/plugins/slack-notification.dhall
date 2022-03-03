let JSON = (../commons.dhall).JSON

let Base = (./base.dhall).Base.Type

let Configuration = (./base.dhall).Configuration

let singleton = (./base.dhall).singleton

let SlackPlugin =
      { webhook_base_url : Text
      , webhook_token : Text
      , slack_channel : Optional Text
      }

let default = { slack_channel = None Text }

let toYaml =
      λ(c : SlackPlugin) →
          [ { mapKey = "webhook_base_url"
            , mapValue = JSON.string c.webhook_base_url
            }
          , { mapKey = "webhook_token", mapValue = JSON.string c.webhook_token }
          ]
        # singleton "slack_channel" c.slack_channel

let config =
      λ(c : SlackPlugin) →
        { type = "SlackNotification", configuration = toYaml c } : Base

in  { Type = SlackPlugin, config, default }
