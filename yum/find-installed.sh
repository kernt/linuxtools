#!/bin/bash
yum list installed | grep "$@"

#or rpm -qa | grep bind

exit 0
