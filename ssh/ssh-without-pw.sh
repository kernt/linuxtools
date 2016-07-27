#!/bin/bash
# Source: http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/
#
#
#

remote-host="$1"

ssh-agent $SHELL
ssh-add -L
ssh-add

ssh-copy-id -i ~/.ssh/id_rsa.pub $remote-host

