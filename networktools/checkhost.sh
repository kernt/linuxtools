#!/bin/bash

if ping -c 1 $1 &> /dev/null
then
  echo 1
else
  echo 0
fi
