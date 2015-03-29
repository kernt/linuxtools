#!/bin/bash
#
#
#
#
###################################
# Show only installed packages APP is your app

aptitude search -F '%p' '~i APP'
