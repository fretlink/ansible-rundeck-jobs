let JSON = (../../commons.dhall).JSON

let singleton = (../../commons.dhall).singleton

let textSingleton = (../../commons.dhall).textSingleton

let RankOrder = (../../commons.dhall).RankOrder

let JobReferenceDispatch =
      let JobReferenceDispatchType =
            { keepgoing : Bool
            , threadcount : Natural
            , rankAttribute : Text
            , rankOrder : RankOrder.Type
            }

      in  { Type = JobReferenceDispatchType
          , toYaml =
              λ(t : JobReferenceDispatchType) →
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
                  ]
          , default =
            { keepgoing = False
            , threadcount = 1
            , rankAttribute = "nodename"
            , rankOrder = RankOrder.Type.Ascending
            }
          }

let JobReferenceNodeFilter =
      let JobReferenceNodeFilterType =
            { dispatch : Optional JobReferenceDispatch.Type, filter : Text }

      in  { Type = JobReferenceNodeFilterType
          , toYaml =
              λ(t : JobReferenceNodeFilterType) →
                JSON.object
                  (   singleton
                        "dispatch"
                        JobReferenceDispatch.Type
                        JobReferenceDispatch.toYaml
                        t.dispatch
                    # [ { mapKey = "filter", mapValue = JSON.string t.filter } ]
                  )
          , default.dispatch = None JobReferenceDispatch.Type
          }

let JobReferenceBase =
      let JobReferenceBaseType =
            { name : Text
            , group : Optional Text
            , args : Optional Text
            , nodeStep : Optional Bool
            , nodefilter : Optional JobReferenceNodeFilter.Type
            }

      in  { Type = JobReferenceBaseType
          , toYamlMap =
              λ(t : JobReferenceBaseType) →
                [ { mapKey = "jobref"
                  , mapValue =
                      JSON.object
                        (   [ { mapKey = "name", mapValue = JSON.string t.name }
                            ]
                          # textSingleton "group" t.group
                          # textSingleton "args" t.args
                          # singleton "nodeStep" Bool JSON.bool t.nodeStep
                          # singleton
                              "nodefilter"
                              JobReferenceNodeFilter.Type
                              JobReferenceNodeFilter.toYaml
                              t.nodefilter
                        )
                  }
                ]
          , default =
            { group = None Text
            , args = None Text
            , nodeStep = None Bool
            , nodefilter = None JobReferenceNodeFilter.Type
            }
          }

in  JobReferenceBase ⫽ { JobReferenceNodeFilter, JobReferenceDispatch }
