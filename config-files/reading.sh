#!/bin/bash
# source http://wiki.bash-hackers.org/howto/conffile
echo "Reading config...." >&2
source /etc/cool.cfg
echo "Config for the username: $cool_username" >&2
echo "Config for the target host: $cool_host" >&2
