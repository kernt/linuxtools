#!/usr/bin/env bash
#
# Script-Name : install.sh
# Version : 0.0.1
# Autor : Tobias Kern
# Datum : 16-04-2014
# Lizenz : GPLv3
# Depends : wget , git
# Use : execute it
#
# Description:
####################################################################################################
## FILEOUT = Name of your outputfile
## TXT     = text in for your outputfile
##   example use:
###                 CatTxtToFile.sh mynewfile.txt "My text for my file it is."
####################################################################################################
#
#
#
#
#
FILEOUT=$1
TXT=$2
cat > $FILEOUT << EOF
$TXT
EOF
