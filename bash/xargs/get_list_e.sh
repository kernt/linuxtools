#!/bin/bash
#
#
#
#
#############################################
#
LIST=$1

# delete alls fieles in LIST
cat $LIST | xargs -t rm

# prefix to all in LIST
cat $LIST | xargs -t -l {} mv  {} {}.old

