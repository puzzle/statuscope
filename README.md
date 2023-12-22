# statuscope - Heartbeat monitoring service

Statuscope is a monitoring intermediary for push heartbeats via HTTP(S).

You can

* Make sure things run in the expected intervals (e.g. that a backup runs daily).
* Report failures of things (e.g. a failed backup).
* Hook up your Prometheus to statuscope (`/metrics`, see the help given in the response) to know when heartbeats fail.
* Hook up your monitoring/alerting to statuscope to know when heartbeats fail (deprecated, prefer Prometheus).
* Easily send heartbeats from the monitoring subjects via curl.

# Running the tests

    bundle exec rake

# Releasing a new version

* Define a new version tag `v1.2.3` (the idea is to use [semantic versioning](https://semver.org/)).
* Change the BuildConfig named `statuscope`, to use the tag you're adding in the next step (`.spec.source.git.ref`).
* Commit, add the tag, push it and redeploy (see below).

# Deploying to OpenShift

Create the route

    hostname=www.example.com

    cat openshift/route.yml.template | \
      sed "s#HOSTNAME_PLACEHOLDER#$hostname#" | \
      oc apply -f -

Create deployment

    bundle exec rake secret > secret
    oc create secret generic statuscope-rails --from-file=secret_key_base=secret
    rm secret
    oc apply -f openshift/

Tag the image from your relevant registry that the GitHub build pushed it to

    oc tag your-registry.ch/your-namespace/statuscope:latest statuscope:latest

Aaand it's done.

# Configuring

Got into statuscope Pods first container

    oc exec -it $(oc get pod | grep Running | awk '{ print $1 }') bash

and use the rails tasks

    rails heartbeat:add APPLICATION=my_app INTERVAL_SECONDS=16800 TEAM=puzzle
    # => Added. Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:token APPLICATION=my_app
    # => Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:remove APPLICATION=my_app
    # => Removed.

Set `INTERVAL_SECONDS=0` to disable interval checks and just remember the last
reported state.

# Sending heartbeats via curl

Signal a success with

    curl \
      -X POST \
      http://localhost:3000/signal \
      -d application=my_app \
      -d token=m2x5b6vMdxtatTdGYnqyR8ee \
      -d status=ok

Signal a failure with

    curl \
      -X POST \
      http://localhost:3000/signal \
      -d application=my_app \
      -d token=m2x5b6vMdxtatTdGYnqyR8ee \
      -d status=fail

# Debugging heartbeats

    curl http://localhost:3000/checks/my_app | jq .
    # => {
    #      "application": "my_app",
    #      "state": "fail",
    #      "check_in": "2018-12-05T13:27:00.980Z",
    #      "interval": 16800
    #    }
