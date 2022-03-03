let JSON = (./commons.dhall).JSON

let singleton = (./commons.dhall).singleton

let textSingleton = (./commons.dhall).textSingleton

let List/map = (./commons.dhall).Prelude.List.map

let Plugin = (./plugins.dhall).Plugin

let Notifications = (./notification.dhall).Notifications

let LogLevel =
      let LogLevelType = < Debug | Verbose | Info | Warn | Error >

      in  { Type = LogLevelType
          , toYaml =
              λ(t : LogLevelType) →
                JSON.string
                  ( merge
                      { Debug = "DEBUG"
                      , Verbose = "VERBOSE"
                      , Info = "INFO"
                      , Warn = "WARN"
                      , Error = "ERROR"
                      }
                      t
                  )
          }

let IntSpec = (./commons.dhall).IntSpec

let LogSize =
      let Size = (./commons.dhall).Size

      let LogSizeType =
            < Lines : Natural | PerNode : Natural | Size : Size.Type >

      in  { Type = LogSizeType
          , toYaml =
              λ(t : LogSizeType) →
                JSON.string
                  ( merge
                      { Lines = Natural/show
                      , PerNode = λ(l : Natural) → Natural/show l ++ "/node"
                      , Size = Size.show
                      }
                      t
                  )
          }

let LoglimitAction =
      let LoglimitActionType = < Halt | Truncate >

      in  { Type = LoglimitActionType
          , toYaml =
              λ(t : LoglimitActionType) →
                JSON.string (merge { Halt = "halt", Truncate = "truncate" } t)
          }

let LoglimitStatus =
      let LoglimitStatusType = < Failed | Aborted | Other : Text >

      in  { Type = LoglimitStatusType
          , toYaml =
              λ(t : LoglimitStatusType) →
                JSON.string
                  ( merge
                      { Failed = "failed"
                      , Aborted = "aborted"
                      , Other = λ(o : Text) → o
                      }
                      t
                  )
          }

let SequenceStrategy =
      let SequenceStrategyType = < NodeFirst | StepFirst >

      in  { Type = SequenceStrategyType
          , toYaml =
              λ(t : SequenceStrategyType) →
                JSON.string
                  ( merge
                      { NodeFirst = "node-first", StepFirst = "step-first" }
                      t
                  )
          }

let Sequence =
      let Command = (./commands/base.dhall).Command

      let SequenceType =
            { keepgoing : Bool
            , strategy : SequenceStrategy.Type
            , commands : List Command.Type
            }

      in  { Type = SequenceType
          , toYaml =
              λ(t : SequenceType) →
                JSON.object
                  [ { mapKey = "keepgoing", mapValue = JSON.bool t.keepgoing }
                  , { mapKey = "strategy"
                    , mapValue = SequenceStrategy.toYaml t.strategy
                    }
                  , { mapKey = "commands"
                    , mapValue =
                        JSON.array
                          ( List/map
                              Command.Type
                              JSON.Type
                              Command.toYaml
                              t.commands
                          )
                    }
                  ]
          , default = {=}
          }

let InputType =
      let InputTypeType = < File >

      in  { Type = InputTypeType
          , toYaml =
              λ(t : InputTypeType) → merge { File = JSON.string "file" } t
          }

let Option =
      let List/map = (./commons.dhall).Prelude.List.map

      let OptionType =
            { name : Text
            , description : Optional Text
            , type : Optional InputType.Type
            , value : Optional Text
            , values : Optional (List Text)
            , required : Optional Bool
            , enforced : Optional Bool
            , regex : Optional Text
            , valuesUrl : Optional Text
            , multivalued : Optional Bool
            , delimiter : Optional Text
            , multivalueAllSelected : Optional Bool
            , secure : Optional Bool
            , valueExposed : Optional Bool
            , storagePath : Optional Text
            , isDate : Optional Bool
            , dateFormat : Optional Text
            }

      in  { Type = OptionType
          , toYaml =
              λ(t : OptionType) →
                JSON.object
                  (   [ { mapKey = "name", mapValue = JSON.string t.name } ]
                    # textSingleton "description" t.description
                    # textSingleton "value" t.value
                    # singleton
                        "values"
                        (List Text)
                        ( λ(values : List Text) →
                            JSON.array
                              (List/map Text JSON.Type JSON.string values)
                        )
                        t.values
                    # singleton "type" InputType.Type InputType.toYaml t.type
                    # singleton "required" Bool JSON.bool t.required
                    # singleton "enforced" Bool JSON.bool t.enforced
                    # textSingleton "regex" t.regex
                    # textSingleton "valuesUrl" t.valuesUrl
                    # singleton "multivalued" Bool JSON.bool t.multivalued
                    # textSingleton "delimiter" t.delimiter
                    # singleton
                        "multivalueAllSelected"
                        Bool
                        JSON.bool
                        t.multivalueAllSelected
                    # singleton "secure" Bool JSON.bool t.secure
                    # singleton "valueExposed" Bool JSON.bool t.valueExposed
                    # textSingleton "storagePath" t.storagePath
                    # singleton "isDate" Bool JSON.bool t.isDate
                    # textSingleton "dateFormat" t.dateFormat
                  )
          , default =
            { required = None Bool
            , type = None InputType.Type
            , enforced = None Bool
            , multivalued = None Bool
            , multivalueAllSelected = None Bool
            , secure = None Bool
            , valueExposed = None Bool
            , isDate = None Bool
            , description = None Text
            , value = None Text
            , values = None (List Text)
            , regex = None Text
            , valuesUrl = None Text
            , delimiter = None Text
            , storagePath = None Text
            , dateFormat = None Text
            }
          }

let Dispatch =
      let RankOrder = (./commons.dhall).RankOrder

      let DispatchType =
            { keepgoing : Bool
            , threadcount : Natural
            , rankAttribute : Text
            , rankOrder : RankOrder.Type
            , excludePrecedence : Bool
            }

      in  { Type = DispatchType
          , toYaml =
              λ(t : DispatchType) →
                JSON.object
                  [ { mapKey = "keepgoing", mapValue = JSON.bool t.keepgoing }
                  , { mapKey = "threadcount"
                    , mapValue = JSON.natural t.threadcount
                    }
                  , { mapKey = "rankAttribute"
                    , mapValue = JSON.string t.rankAttribute
                    }
                  , { mapKey = "rankOrder"
                    , mapValue = RankOrder.toYaml t.rankOrder
                    }
                  , { mapKey = "excludePrecedence"
                    , mapValue = JSON.bool t.excludePrecedence
                    }
                  ]
          , default =
            { keepgoing = False
            , threadcount = 1
            , rankAttribute = "nodename"
            , rankOrder = RankOrder.Type.Ascending
            , excludePrecedence = True
            }
          }

let NodeFilter =
      let NodeFilterType = { dispatch : Optional Dispatch.Type, filter : Text }

      in  { Type = NodeFilterType
          , default.dispatch = None Dispatch.Type
          , toYaml =
              λ(t : NodeFilterType) →
                JSON.object
                  (   [ { mapKey = "filter", mapValue = JSON.string t.filter } ]
                    # singleton
                        "dispatch"
                        Dispatch.Type
                        Dispatch.toYaml
                        t.dispatch
                  )
          }

let ScheduleSpec =
      let ScheduleSpecType =
            { seconds : Optional Text
            , minute : Optional Text
            , hour : Optional Text
            , weekday : Optional Text
            , dayofmonth : Optional Text
            , month : Optional Text
            , year : Optional Text
            }

      in  { Type = ScheduleSpecType
          , toYaml =
              λ(t : ScheduleSpecType) →
                let Map = (./commons.dhall).Prelude.Map.Type

                let Entry = (./commons.dhall).Prelude.Map.Entry

                let singleton =
                      λ(name : Text) →
                      λ(t : Optional Text) →
                        merge
                          { None = [] : Map Text JSON.Type
                          , Some =
                              λ(t : Text) →
                                [ { mapKey = name, mapValue = JSON.string t } ]
                          }
                          t

                let timeValues =
                        singleton "seconds" t.seconds
                      # singleton "minute" t.minute
                      # singleton "hour" t.hour

                let time =
                      if    Natural/isZero
                              (List/length (Entry Text JSON.Type) timeValues)
                      then  [] : Map Text JSON.Type
                      else  [ { mapKey = "time"
                              , mapValue = JSON.object timeValues
                              }
                            ]

                let weekdayValues = singleton "day" t.weekday

                let weekday =
                      if    Natural/isZero
                              (List/length (Entry Text JSON.Type) weekdayValues)
                      then  [] : Map Text JSON.Type
                      else  [ { mapKey = "weekday"
                              , mapValue = JSON.object weekdayValues
                              }
                            ]

                in  JSON.object
                      (   time
                        # weekday
                        # singleton "month" t.month
                        # singleton "year" t.year
                        # singleton "dayofmonth" t.dayofmonth
                      )
          , default =
            { seconds = None Text
            , minute = None Text
            , hour = None Text
            , weekday = None Text
            , dayofmonth = None Text
            , month = None Text
            , year = None Text
            }
          }

let Schedule =
      let ScheduleType = < Crontab : Text | Time : ScheduleSpec.Type >

      in  { Type = ScheduleType
          , toYaml =
              λ(t : ScheduleType) →
                merge
                  { Crontab =
                      λ(t : Text) →
                        JSON.object
                          [ { mapKey = "crontab", mapValue = JSON.string t } ]
                  , Time = ScheduleSpec.toYaml
                  }
                  t
          }

let DefaultTab =
      let DefaultTabType = < Nodes | LogOutput | HTML >

      in  { Type = DefaultTabType
          , toYaml =
              λ(t : DefaultTabType) →
                JSON.string
                  ( merge
                      { Nodes = "nodes", LogOutput = "output", HTML = "html" }
                      t
                  )
          }

let Job =
      let JobType =
            { name : Text
            , shortDescription : Text
            , longDescription : Optional Text
            , defaultTab : DefaultTab.Type
            , executionEnabled : Optional Bool
            , scheduleEnabled : Optional Bool
            , loglevel : LogLevel.Type
            , sequence : Sequence.Type
            , uuid : Optional Text
            , group : Optional Text
            , multipleExecutions : Optional Bool
            , timeout : Optional IntSpec.Type
            , retry : Optional IntSpec.Type
            , loglimit : Optional LogSize.Type
            , loglimitAction : Optional LoglimitAction.Type
            , loglimitStatus : Optional LoglimitStatus.Type
            , options : List Option.Type
            , schedule : Optional Schedule.Type
            , nodeFilterEditable : Optional Bool
            , nodefilters : Optional NodeFilter.Type
            , nodesSelectedByDefault : Optional Bool
            , notification : Optional Notifications.Type
            , orchestrator : Optional Plugin.Type
            , timeZone : Optional Text
            }

      in  { Type = JobType
          , toYaml =
              λ(t : JobType) →
                let Map = (./commons.dhall).Prelude.Map.Type

                let options =
                      if    Natural/isZero (List/length Option.Type t.options)
                      then  [] : Map Text JSON.Type
                      else  [ { mapKey = "options"
                              , mapValue =
                                  JSON.array
                                    ( List/map
                                        Option.Type
                                        JSON.Type
                                        Option.toYaml
                                        t.options
                                    )
                              }
                            ]

                let avgDurationThreshold =
                      merge
                        { None = [] : Map Text JSON.Type
                        , Some =
                            λ ( notification
                              : (./notification.dhall).Notifications.Type
                              ) →
                              textSingleton
                                "notifyAvgDurationThreshold"
                                notification.avgdurationthreshold
                        }
                        t.notification

                in  JSON.object
                      (   [ { mapKey = "name", mapValue = JSON.string t.name }
                          , { mapKey = "description"
                            , mapValue =
                                JSON.string
                                  ( merge
                                      { None = t.shortDescription
                                      , Some =
                                          λ(d : Text) →
                                            t.shortDescription ++ "\n\n" ++ d
                                      }
                                      t.longDescription
                                  )
                            }
                          , { mapKey = "defaultTab"
                            , mapValue = DefaultTab.toYaml t.defaultTab
                            }
                          , { mapKey = "loglevel"
                            , mapValue = LogLevel.toYaml t.loglevel
                            }
                          , { mapKey = "sequence"
                            , mapValue = Sequence.toYaml t.sequence
                            }
                          ]
                        # singleton
                            "executionEnabled"
                            Bool
                            JSON.bool
                            t.executionEnabled
                        # singleton
                            "scheduleEnabled"
                            Bool
                            JSON.bool
                            t.scheduleEnabled
                        # textSingleton "uuid" t.uuid
                        # textSingleton "group" t.group
                        # singleton
                            "multipleExecutions"
                            Bool
                            JSON.bool
                            t.multipleExecutions
                        # singleton
                            "timeout"
                            IntSpec.Type
                            IntSpec.toYaml
                            t.timeout
                        # singleton "retry" IntSpec.Type IntSpec.toYaml t.retry
                        # singleton
                            "loglimit"
                            LogSize.Type
                            LogSize.toYaml
                            t.loglimit
                        # singleton
                            "loglimitAction"
                            LoglimitAction.Type
                            LoglimitAction.toYaml
                            t.loglimitAction
                        # singleton
                            "loglimitStatus"
                            LoglimitStatus.Type
                            LoglimitStatus.toYaml
                            t.loglimitStatus
                        # options
                        # singleton
                            "schedule"
                            Schedule.Type
                            Schedule.toYaml
                            t.schedule
                        # singleton
                            "nodeFilterEditable"
                            Bool
                            JSON.bool
                            t.nodeFilterEditable
                        # singleton
                            "nodefilters"
                            NodeFilter.Type
                            NodeFilter.toYaml
                            t.nodefilters
                        # singleton
                            "nodesSelectedByDefault"
                            Bool
                            JSON.bool
                            t.nodesSelectedByDefault
                        # singleton
                            "notification"
                            Notifications.Type
                            Notifications.toYaml
                            t.notification
                        # singleton
                            "orchestrator"
                            Plugin.Type
                            Plugin.toYaml
                            t.orchestrator
                        # textSingleton "timeZone" t.timeZone
                        # avgDurationThreshold
                      )
          , default =
            { shortDescription = ""
            , longDescription = None Text
            , defaultTab = DefaultTab.Type.Nodes
            , executionEnabled = None Bool
            , scheduleEnabled = None Bool
            , multipleExecutions = None Bool
            , loglimitAction = None LoglimitAction.Type
            , loglimitStatus = None LoglimitStatus.Type
            , nodeFilterEditable = None Bool
            , nodesSelectedByDefault = None Bool
            , uuid = None Text
            , group = None Text
            , timeout = None IntSpec.Type
            , retry = None IntSpec.Type
            , loglimit = None LogSize.Type
            , options = [] : List Option.Type
            , schedule = None Schedule.Type
            , notification = None Notifications.Type
            , nodefilters = None NodeFilter.Type
            , orchestrator = None Plugin.Type
            , timeZone = None Text
            }
          }

let listToYaml =
      let List/map = (./commons.dhall).Prelude.List.map

      in  List/map Job.Type JSON.Type Job.toYaml

in    { Job
      , Sequence
      , LogLevel = LogLevel.Type
      , LogSize = LogSize.Type
      , LoglimitAction = LoglimitAction.Type
      , LoglimitStatus = LoglimitStatus.Type
      , InputType = InputType.Type
      , Option
      , NodeFilter
      , Schedule = Schedule.Type
      , SequenceStrategy = SequenceStrategy.Type
      , DefaultTab = DefaultTab.Type
      , ScheduleSpec
      , Dispatch
      , listToYaml
      , Commons = ./commons.dhall
      }
    ∧ ./commands/base.dhall
    ∧ ./plugins.dhall
    ∧ ./notification.dhall
