#!/bin/bash
# Add a full path!
# Just as delimeter use ", " or change it cut -d, -f1 to 
# you can also use a variable
# 
# Your URL to a csv file 
CSVFILE-URL="$1"

curl -s $CSVFILE-URL| cut -d, -f1 | xargs -i timeout 1 ping -c1 -w 1 {} | grep time | sed -u "s/.* from \([^:]*\).*time=\([^ ]*\).*/\2\t\1/g" | sort -n | head -n1

