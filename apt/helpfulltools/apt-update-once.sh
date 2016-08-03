#!/bin/bash

PACKAGENAME=$@

apt-get install $PACKAGENAME --only-upgrade

exit 0
