#!/bin/bash
DIR="$1"
REGEX="$2"
find . -iname $REGEX -print0 | xargs -0 mv --verbose -t $DIR
