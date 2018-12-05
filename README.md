# README

# Configuring

Use the rails tasks:

    rails heartbeat:add APPLICATION=my_app INTERVAL_SECONDS=16800
    # => Added. Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:token APPLICATION=my_app
    # => Token: GTWSEcRz4e59dCJKa4AjLvxe

    rails heartbeat:remove APPLICATION=my_app
    # => Removed.

# Sending a heartbeat via curl

TODO
