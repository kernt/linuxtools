#!/bin/bash
## Skript: skript.sh
# Zweck: Basis für eigene Skripte, enthaelt bereits
# einige Skript-Standardelemente (usage-Funktion,
# Optionen parsen mittels getopts, vordefinierte
# Variablen...)
# Skript:       .sh
# 
# 
# 
# 
#
################################################################################ 
SCRIPTNAME=$(basename $0 .sh)
EXIT_SUCCESS=0
EXIT_FAILURE=1
EXIT_ERROR=2
EXIT_BUG=10
# Variablen für Optionsschalter hier mit Default-Werten vorbelegen
VERBOSE=n
OPTFILE=""
# Funktionen
function usage {
 echo "Usage: $SCRIPTNAME [-h] [-v] [-o arg] file ..." >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts ':o:vh' OPTION ; do
 case $OPTION in
 v) VERBOSE=y
 ;;
 o) OPTFILE="$OPTARG"
 ;;
 h) usage $EXIT_SUCCESS
 ;;
 \?) echo "Unbekannte Option \"-$OPTARG\"." >&2
 usage $EXIT_ERROR
 ;;
 :) echo "Option \"-$OPTARG\" benötigt ein Argument." >&2
 usage $EXIT_ERROR
 ;;
 *) echo "Dies kann eigentlich gar nicht passiert sein..."
>&2
 usage $EXIT_BUG
 ;;
 esac
done
# Verbrauchte Argumente überspringen
shift $(( OPTIND - 1 ))

# Farben für die shell
black() { echo "$(tput setaf 0)$*$(tput setaf 9)"; }
red() { echo "$(tput setaf 1)$*$(tput setaf 9)"; }
green() { echo "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow() { echo "$(tput setaf 3)$*$(tput setaf 9)"; }
blue() { echo "$(tput setaf 4)$*$(tput setaf 9)"; }
magenta() { echo "$(tput setaf 5)$*$(tput setaf 9)"; }
cyan() { echo "$(tput setaf 6)$*$(tput setaf 9)"; }
white() { echo "$(tput setaf 7)$*$(tput setaf 9)"; }

# Eventuelle Tests auf min./max. Anzahl Argumente hier
if (( $# < 1 )) ; then
 echo "Mindestens ein Argument beim Aufruf übergeben." >&2
 usage $EXIT_ERROR
fi
# Schleife über alle Argumente
for ARG ; do
 if [[ $VERBOSE = y ]] ; then
 echo -n "Argument: "
 fi
 echo $ARG
done
exit $EXIT_SUCCESS
