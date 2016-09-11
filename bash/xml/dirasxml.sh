#!/bin/bash
#
#
#
#
# did for etch dir a xml taht can be used to convert them to json 
for dir in $(ls -d */)  ; do tree -L 1 -X $dir | tail -n +2  ; done
