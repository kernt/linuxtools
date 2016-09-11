#! /bin/sh
# Name: loguser
# Das Script überwacht , ob sich jemand am System einlogt

# Pseudonym für das  aktuelle terminal

outdev=/dev/tty
fcount=0; newcount; timer=3; displaylines=0

# Die Anzahl der zeilen des last-Kommandos zählen
# anstelle von last kann, wenn es um einen bestimmten user geht auch w -hs
# genutzt werden
fcount=`last | wc -l`

while true
do
 # Erneuert die Anzahl Zeilen des last-Kommandos...
 newcount=`last | wc -l`
 # vergleich ob neue hinzugekommen sind
 if [ $newcount -gt $fcount ]
 then
 # Wie viele neue Zeilen
 displaylines=`expr $newcount - $fcount`
 # auf outdev ausgeben
 # Hier z.B write oder screen benutzen damit die Kommandozeile nicht
 # blockiert wird
 last | head -$displaylines > $outdev
 # neuen Wert an fcount zuweisen
 fcount=$newcount
 # timer n Sekunden wareten, bis zur naechsten Pruefung
 sleep $timer
fi
done

exit 0
