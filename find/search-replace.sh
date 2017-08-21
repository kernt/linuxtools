#!/bin/bash

SEARCHDIR="$1"
SEARCHSTRING="$2"
REPLACESTRING="$3"

find ${SEARCHDIR} -type f -exec rename "s/${SEARCHSTRING}/${REPLACESTRING/g' {} \;
