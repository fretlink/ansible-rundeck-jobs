let JSON = (../commons.dhall).JSON

let boolToText = (./base.dhall).boolToText

let singleton = (./base.dhall).singleton

let someToMap = (./base.dhall).someToMap

let Text/concatSep = (../commons.dhall).Prelude.Text.concatSep

let Configuration = (./base.dhall).Configuration

let Base = (./base.dhall).StepBase.Type

let AuthenticationBasic = { username : Text, passwordPath : Text }

let AuthenticationOAuth =
      { clientId : Text
      , clientSecretPath : Text
      , oauthTokenUrl : Text
      , oauthValidateUrl : Text
      }

let Authentication =
      < Basic : AuthenticationBasic | Oauth : AuthenticationOAuth >

let Method = < Get | Post | Put | Patch | Delete | Head | Options >

let Step =
      { Type =
          { remoteUrl : Text
          , httpMethod : Method
          , headers : List Text
          , body : Optional Text
          , timeout : Optional Text
          , sslVerify : Bool
          }
      , default =
        { headers = [] : List Text, body = None Text, timeout = None Text }
      }

let Proxy = { ip : Text, port : Natural }

let HttpCall =
      { step : Step.Type
      , authentication : Optional Authentication
      , check : Optional Text
      , print : Bool
      , printToFile : Optional Text
      , proxy : Optional Proxy
      }

let default =
      { authentication = None Authentication
      , check = None Text
      , printToFile = None Text
      , proxy = None Proxy
      }

let toYaml =
      λ(h : HttpCall) →
        let authentication =
              merge
                { None =
                  [ { mapKey = "authentication", mapValue = JSON.string "None" }
                  ]
                , Some =
                    λ(a : Authentication) →
                      merge
                        { Basic =
                            λ(b : AuthenticationBasic) →
                              [ { mapKey = "authentication"
                                , mapValue = JSON.string "Basic"
                                }
                              , { mapKey = "username"
                                , mapValue = JSON.string b.username
                                }
                              , { mapKey = "password"
                                , mapValue = JSON.string b.passwordPath
                                }
                              ]
                        , Oauth =
                            λ(b : AuthenticationOAuth) →
                              [ { mapKey = "authentication"
                                , mapValue = JSON.string "OAuth 2.0"
                                }
                              , { mapKey = "username"
                                , mapValue = JSON.string b.clientId
                                }
                              , { mapKey = "password"
                                , mapValue = JSON.string b.clientSecretPath
                                }
                              , { mapKey = "oauthTokenEndpoint"
                                , mapValue = JSON.string b.oauthTokenUrl
                                }
                              , { mapKey = "oauthValidateEndpoint"
                                , mapValue = JSON.string b.oauthValidateUrl
                                }
                              ]
                        }
                        a
                }
                h.authentication

        let responseCode =
              λ(t : Text) →
                [ { mapKey = "responseCode", mapValue = JSON.string t } ]

        let printToFile =
              λ(t : Text) → [ { mapKey = "file", mapValue = JSON.string t } ]

        let proxySettings =
              λ(p : Proxy) →
                [ { mapKey = "proxyIP", mapValue = JSON.string p.ip }
                , { mapKey = "proxyPort", mapValue = JSON.natural p.port }
                ]

        let headers =
              if    Natural/isZero (List/length Text h.step.headers)
              then  [] : Configuration
              else  [ { mapKey = "headers"
                      , mapValue =
                          let comment =
                                "New line added at end of string to have a multiline yaml string"

                          in  JSON.string
                                (Text/concatSep "\n" h.step.headers ++ "\n")
                      }
                    ]

        in    [ { mapKey = "remoteUrl"
                , mapValue = JSON.string h.step.remoteUrl
                }
              , { mapKey = "method"
                , mapValue =
                    JSON.string
                      ( merge
                          { Get = "GET"
                          , Post = "POST"
                          , Put = "PUT"
                          , Patch = "PATCH"
                          , Delete = "DELETE"
                          , Head = "HEAD"
                          , Options = "OPTIONS"
                          }
                          h.step.httpMethod
                      )
                }
              , { mapKey = "sslVerify", mapValue = boolToText h.step.sslVerify }
              , { mapKey = "printResponse", mapValue = boolToText h.print }
              ]
            # singleton "body" h.step.body
            # headers
            # singleton "timeout" h.step.timeout
            # authentication
            # someToMap "checkResponseCode" Text responseCode h.check
            # someToMap "printResponseToFile" Text printToFile h.printToFile
            # someToMap "proxySettings" Proxy proxySettings h.proxy

let config =
      λ(c : HttpCall) →
          { type = "edu.ohio.ais.rundeck.HttpWorkflowStepPlugin"
          , nodeStep = False
          , configuration = toYaml c
          }
        : Base

in  { AuthenticationBasic
    , AuthenticationOAuth
    , Authentication
    , Method
    , Step
    , Proxy
    , Type = HttpCall
    , default
    , config
    }
