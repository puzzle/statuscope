# README

# Configuring

Use the rails tasks:

    rails heartbeat:add APPLICATION=my_app INTERVAL_SECONDS=16800
    # => Added. Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:token APPLICATION=my_app
    # => Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:remove APPLICATION=my_app
    # => Removed.

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
