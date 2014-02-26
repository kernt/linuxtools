#!/bin/bash
#
#
#
#
#
#
#
#
#
#
##########################################################################################################################

KEYURL="YOURURL"

curl $KEYURL | apt-key add -

# alternative use the following example.
# get -q $KEYURL -O- | apt-key add -
