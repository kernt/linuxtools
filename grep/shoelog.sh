#!/bin/bash
egrep -v "lockfile:" /var/log/daemon.log | egrep "$@"
