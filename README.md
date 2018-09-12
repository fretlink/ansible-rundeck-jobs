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

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: rundeck-jobs, rundeck_api_url: rundeck.example.com, rundeck_project: test, rundeck_jobs_path: /tmp/rundeck-jobs }

License
-------

TBD

Author Information
------------------

FretLink, Love and Truck
