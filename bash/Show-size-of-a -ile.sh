#!/bin/bash
FILENAME=/home/heiko/dummy/packages.txt
FILESIZE=$(wc -c < "$FILENAME")
# non standard way (GNU stat): FILESIZE=$(stat -c%s "$FILENAME")

echo "Size of $FILENAME = $FILESIZE bytes."
