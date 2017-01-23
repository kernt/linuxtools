#!/bin/bash
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -1 | python -c "import sys,crypt; stdin=sys.stdin.readline().rstrip('\n'); print stdin;print crypt.crypt(stdin)"
exit 0
