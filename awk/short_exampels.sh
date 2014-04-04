#!/bin/bash

# das letzte Feld jeder Eingabezeile ausgeben
  awk '{ print $NF }' /etc/hosts
  
  # die 10. Eingabezeile ausgeben
  awk 'NR == 10' /etc/passwd
  
  # alle Zeilen ausgeben, die entweder "root" oder "false" enthalten
  # (also Suche wie bei egrep)
  awk '/root|false/' /etc/passwd
  
  # Gesamtzahl der Eingabe-Zeilen ausgeben
  awk 'END { print NR }' /etc/passwd
  
  # das erste und letzte Feld der Eingabezeilen 5 bis 10 ausgeben
  awk -F: 'NR == 5, NR == 10 { print $1, $NF }' /etc/passwd
  
  # das erste und vorletzte Feld der letzten Eingabezeile ausgeben
  awk -F: 'END { print $1, $(NF-1) }' /etc/passwd
  
  # passwd-Eintrag für die aktuelle UID ausgeben
  awk -F: "\$3 == $UID" /etc/passwd
  awk -F: -v uid=$UID '$3 == uid' /etc/passwd
  
  # Ausgabe von Zeilen mit mehr als 2 Feldern
  awk 'NF > 2' /etc/hosts
  
  # Ausgabe von Zeilen, deren Feld 3 kleiner als 50 ist
  awk -F: '$3 < 50' /etc/passwd
  
  # Ausgabe von Zeilen, deren letztes Feld "false" enthält
  awk -F: '$NF ~ /false/' /etc/passwd
  
  # Ausgabe der Anzahl von Zeilen, deren letztes Feld "false" enthält;
  # Anmerkung: das Semikolon vor END ist nicht nötig
  awk -F: '$NF ~ /false/ { anz++ } ; END { print anz }' /etc/passwd
  
  # Ausgabe von nicht leeren Zeilen
  awk NF /etc/hosts
  
  # ermittle, wie oft jeder Wert des letzten Feldes der Eingabezeilen vorkommt
  awk -F: '
    { ANZ[$NF]++ }
    END { for (w in ANZ) printf("%s: %d\n", w, ANZ[w]) }
  ' /etc/passwd
  
  # tausche Feld 1 und 2 der ersten 10 Eingabezeilen;
  # gib restliche Zeilen unverändert aus
  awk -F: '
    BEGIN { OFS = FS }
    NR < 11 { t = $1; $1 = $2; $2 = t }
    1
  ' /etc/passwd
  
  # ermittle die längste Eingabe-Zeile
  awk '
    length($0) > max { max = length($0) ; fn = FILENAME ; fnr = FNR ; line = $0 }
    END { if (fnr) printf("%d Zeichen in Zeile %d in Datei %s\n%s\n", max, fnr, fn, line) }
  ' /etc/{hosts,passwd}
  
  # gib die UIDs der Nutzer, die die bash als Login-Shell haben, fallend sortiert
  # aus; anschließend wird noch die Anzahl dieser Nutzer ausgegeben
  awk -F: '
    BEGIN { sort = "sort -rn" }
    $7 ~ /bash/ { print $3 | sort ; anz++ }
    END { close(sort) ; printf("Anzahl: %d\n", anz) }
  ' /etc/passwd
