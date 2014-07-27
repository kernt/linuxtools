#!/bin/bash
#
# Script-Name : ins_tmate.sh
# Version     : 0.01
# Autor       : Tobias Kern
# Datum       : 27.07.2014
# Lizenz      : GPLv3
# Depends     : git, apt-get
# Use         :
#
# Example:
#
# Description: tested on Debian linux 
###########################################################################################
## Install tmate for gedit with git
##
###########################################################################################
# Name of your script.
SCRIPTNAME=$(basename $0.sh)
# exit code without any error
EXIT_SUCCESS=0
# exit code I/O failure
EXIT_FAILURE=1
# exit code error if known
EXIT_ERROR=2
# unknown ERROR
EXIT_BUG=10
# get tmate from github
git clone https://github.com/nviennot/tmate
# 
apt-get install git-core build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev automake libssh-dev cmake ruby
# for local install use
## https://gist.github.com/ryin/3106801

# 
./autogen.sh
./configure
make         
make install
# source http://tmate.io/
