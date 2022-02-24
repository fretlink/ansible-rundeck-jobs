let Key = { path : Text, value : Text, type : Text }

let Vault = λ(a : Type) → { apiToken : Text, keys : a }

let Config =
      { Type =
          { rundeck_jobs_path : Text
          , rundeck_project : Text
          , rundeck_api_url : Text
          , rundeck_api_token : Text
          , rundeck_api_version : Optional Natural
          , rundeck_remove_missing : Optional Bool
          , rundeck_ignore_creation_error : Optional Bool
          , rundeck_jobs_group : Optional Text
          , rundeck_jobs_keys : List Key
          , rundeck_keys_scoped_by_project : Optional Bool
          , rundeck_keys_scoped_by_group : Optional Bool
          }
      , default =
        { rundeck_api_version = Some 26
        , rundeck_remove_missing = Some True
        , rundeck_ignore_creation_error = Some True
        , rundeck_jobs_group = None Text
        , rundeck_jobs_keys = [] : List Key
        , rundeck_keys_scoped_by_project = Some True
        , rundeck_keys_scoped_by_group = None Bool
        }
      }

in  { Vault, Config, Key }
