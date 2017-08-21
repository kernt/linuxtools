#!/bin/bash
D="$(date "+%F %T.%N")"; [COMMAND]; find . -newermt "$D"
# List all files modified by a command
