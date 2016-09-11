#! /bin/sh
##########################################################################
# Title      :	logeduser.sh
# Author     :	Tobias Kern
# Date       :	Dezember 23 2007
# Category   :	System Administration
# SCCS-Id.   :	
##########################################################################


# Pseudonym für das aktuelle Terminal
outdev=/dev/tty
fcount=0; newcount=0; timer=10; displaylines=0

# Die Anzahl der Zeilen den last kommandos zählen
fcount=`last | wc -l`

while true
do
  # Erneut die Anzahl Zeilen des last-Kommandos zählen
  newcount=`last | wc -l`
  # und der Vergleich ob neue hinzugekimmen sind
  if [ $newcount -gt $fcount ]
  then
   # Prüfen wie viele neue Zeilen
   displaylines=`expr $newcount - $fcount`
   # Neue Zeilen ausgeben auf outdev hier damit die Kommandzeile nicht Blockiert 
   # das kommando write benutzen.
   last | head -$displaylines > $outdev
   # neuen Wert an fcount zuweisen
   fcount=$newcount
   # timer Sekunden. bis zur nächsten Überprüfung
   sleep $timer
fi
done
