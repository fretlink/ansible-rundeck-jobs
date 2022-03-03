Rundeck jobs
=========

This role synchronize a directory containing yaml definition of jobs with a rundeck project

Requirements
------------

* `jmespath` python module

Role Variables
--------------

* `rundeck_jobs_path` path of the directory containing the job definition (mandatory).
* `rundeck_project` name of the rundeck project (mandatory).
* `rundeck_api_url` base url of api (mandatory).
* `rundeck_api_token` the authentification token (mandatory).
* `rundeck_api_version` api version supported by rundeck server. Default to 26.
* `rundeck_remove_missing` Whether to delete jobs present in rundeck and not in file. Defaults to true.
* `rundeck_jobs_group` the group of job to check for removal
* `rundeck_ignore_creation_errors` whether to ignore job creation error. Default to true to follow the 200 status given by rundeck API
* `rundeck_jobs_keys` a list of keys to import in rundeck. Each key is a dict with a `path`, a `value` and a `type` as declared in [https://docs.rundeck.com/3.0.x/api/index.html#upload-keys]().
* `rundeck_keys_scoped_by_project` scope each key by project (In a project/ProjectName subdirectory)
* `rundeck_keys_scoped_by_group` scope each key by group. Defaults to true if the group is defined, false otherwise
* `rundeck_remove_missing_keys` remove keys that are not declared in ansible (possibly restrained to the scope defined above)
* `rundeck_jobs` a list of jobs defined inline (similarly to the contents in files at `rundeck_jobs_path`)

A [dhall](https://dhall-lang.org/) Type representing the roles' variables is available in the `./dhall/Config.dhall` file to help you configure your projects with some type checking.

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      vars:
        rundeck_api_url: rundeck.example.com
        rundeck_project: test
        rundeck_jobs_path: /tmp/rundeck-jobs
      roles:
        - rundeck-jobs

License
-------

BSD

Author Information
------------------

FretLink, Love and Truck
