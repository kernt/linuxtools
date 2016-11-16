#!/bin/bash
# Name: curl-pw-sec-get-value-by-tag.sh
#
#
# Is currently not working !!! 
# 
# Source : 
# https://gist.github.com/cjus/1047794
# http://kmkeen.com/jshon/
# http://stackoverflow.com/questions/18910939/how-to-get-json-key-and-value-in-javascript
# http://stackoverflow.com/questions/20488315/read-the-json-data-in-shell-script
# https://gist.github.com/cjus/1047794
# https://github.com/step-/JSON.awk
#################################

SERVER=$1
FILEPATH=$2
USERNAME=$USER
ADDRESS= https://${SERVER}/${FILEPATH}
# 
JSON-REQ=$(curl -Lk -XGET -u "${USERNAME}:${PW}" -b cookies.txt -c cookies.txt -s $ADDRESS)

JSON-PARSE="awk -v k="Body" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}"

OUTPUT=$($JSON-REQ | $JSON-PARSE )

echo "$OUTPUT"
