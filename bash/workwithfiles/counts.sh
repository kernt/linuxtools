#!/bin/bash
#
#
#
# Remove N lines 
# Make variables read-only. 
# These variables cannot then be assigned values by subsequent assignment statements, nor can they be unset.
# Prevent for manipulation.
readonly CN=37

# Calculate is there N degred than the original
ISSAME=$(expr  "$( cat files-etc.xml | wc -l )" - "$(cat f2.xml | wc -l)" )

awk 'NR > $CN' file.xml > 'f2.xml'
sed -i '1,37d' file.xml

