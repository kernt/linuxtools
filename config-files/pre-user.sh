#!/bin/bash
echo "Reading system-wide config...." >&2
. /etc/cool.cfg
if [ -r ~/.coolrc ]; then
  echo "Reading user config...." >&2
  . ~/.coolrc
fi
