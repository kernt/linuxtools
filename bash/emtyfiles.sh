#!/bin/bash
#
#
echo $(du -h * | grep ^0 | awk '{print $2}') | sed "s/\s/, /g"
