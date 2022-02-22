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
