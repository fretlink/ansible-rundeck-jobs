let JSON = (./commons.dhall).JSON

let Map = (./commons.dhall).Prelude.Map.Type

let List/map = (./commons.dhall).Prelude.List.map

let EmailNotificationAttach = < File | Inline >

let EmailNotification =
      let ENType =
            { attachType : Optional EmailNotificationAttach
            , recipients : List Text
            , subject : Text
            }

      let Text/concatSep = (./commons.dhall).Prelude.Text.concatSep

      let Optional/null = (./commons.dhall).Prelude.Optional.null

      let attachLog =
            λ(t : ENType) →
              merge
                { None = [] : List { mapKey : Text, mapValue : JSON.Type }
                , Some =
                    λ(a : EmailNotificationAttach) →
                      merge
                        { File =
                          [ { mapKey = "attachLogInFile"
                            , mapValue = JSON.bool True
                            }
                          ]
                        , Inline =
                          [ { mapKey = "attachLogInline"
                            , mapValue = JSON.bool True
                            }
                          ]
                        }
                        a
                }
                t.attachType

      in  { Type = ENType
          , default.attachType = None EmailNotificationAttach
          , toYaml =
              λ(t : ENType) →
                JSON.object
                  (   [ { mapKey = "subject", mapValue = JSON.string t.subject }
                      , { mapKey = "recipients"
                        , mapValue =
                            JSON.string (Text/concatSep "," t.recipients)
                        }
                      , { mapKey = "attachLog"
                        , mapValue =
                            if    Optional/null
                                    EmailNotificationAttach
                                    t.attachType
                            then  JSON.bool False
                            else  JSON.bool True
                        }
                      ]
                    # attachLog t
                  )
          }

let UrlNotificationFormat = < XML | JSON >

let UrlNotificationMethod = < POST | GET >

let UrlNotification =
      let UNType =
            { format : UrlNotificationFormat
            , httpMethod : UrlNotificationMethod
            , urls : List Text
            }

      let Text/concatSep = (./commons.dhall).Prelude.Text.concatSep

      in  { Type = UNType
          , default = {=}
          , toYamlMap =
              λ(t : UNType) →
                [ { mapKey = "format"
                  , mapValue =
                      JSON.string
                        (merge { XML = "xml", JSON = "json" } t.format)
                  }
                , { mapKey = "httpMethod"
                  , mapValue =
                      JSON.string
                        (merge { POST = "post", GET = "get" } t.httpMethod)
                  }
                , { mapKey = "urls"
                  , mapValue = JSON.string (Text/concatSep "," t.urls)
                  }
                ]
          }

let Plugin = (./plugins.dhall).Plugin

let Notification =
      let NType =
            { email : Optional EmailNotification.Type
            , urls : Optional UrlNotification.Type
            , plugins : Optional (List Plugin.Type)
            }

      let singleton = (./commons.dhall).singleton

      let mapPlugin =
            λ(t : List Plugin.Type) →
              if    (./commons.dhall).Prelude.Natural.lessThanEqual
                      (List/length Plugin.Type t)
                      1
              then  merge
                      { None = JSON.null
                      , Some = λ(plugin : Plugin.Type) → Plugin.toYaml plugin
                      }
                      ((./commons.dhall).Prelude.List.head Plugin.Type t)
              else  JSON.array (List/map Plugin.Type JSON.Type Plugin.toYaml t)

      in  { Type = NType
          , default =
            { email = None EmailNotification.Type
            , urls = None UrlNotification.Type
            , plugins = None (List Plugin.Type)
            }
          , toYaml =
              λ(t : NType) →
                JSON.object
                  (   singleton
                        "email"
                        EmailNotification.Type
                        EmailNotification.toYaml
                        t.email
                    # merge
                        { None = [] : Map Text JSON.Type
                        , Some = UrlNotification.toYamlMap
                        }
                        t.urls
                    # singleton "plugin" (List Plugin.Type) mapPlugin t.plugins
                  )
          }

let Notifications =
      let NotificationsType =
            { onfailure : Optional Notification.Type
            , onstart : Optional Notification.Type
            , onsuccess : Optional Notification.Type
            , onavgduration : Optional Notification.Type
            , avgdurationthreshold : Optional Text
            , onretryablefailure : Optional Notification.Type
            }

      let singleton = (./commons.dhall).singleton

      in  { Type = NotificationsType
          , toYaml =
              λ(t : NotificationsType) →
                JSON.object
                  (   singleton
                        "onfailure"
                        Notification.Type
                        Notification.toYaml
                        t.onfailure
                    # singleton
                        "onstart"
                        Notification.Type
                        Notification.toYaml
                        t.onstart
                    # singleton
                        "onsuccess"
                        Notification.Type
                        Notification.toYaml
                        t.onsuccess
                    # singleton
                        "onavgduration"
                        Notification.Type
                        Notification.toYaml
                        t.onavgduration
                    # singleton
                        "onretryablefailure"
                        Notification.Type
                        Notification.toYaml
                        t.onretryablefailure
                  )
          , default =
            { onfailure = None Notification.Type
            , onstart = None Notification.Type
            , onsuccess = None Notification.Type
            , onavgduration = None Notification.Type
            , onretryablefailure = None Notification.Type
            , avgdurationthreshold = None Text
            }
          }

in  { Notifications
    , Notification
    , EmailNotification
    , UrlNotification
    , UrlNotificationMethod
    , UrlNotificationFormat
    }
