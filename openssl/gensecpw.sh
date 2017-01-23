#!/bin/bash
#
#
#
#
#
#
#
# Gen N secure Passwords

N=$1
Z=$2

for (( i=$N; i<=$Z; i++ )) 
 do
   openssl rand -hex 10
 done
