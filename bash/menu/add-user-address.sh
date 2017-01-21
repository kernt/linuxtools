#! /bin/sh
# Belegung Beispieldaten
# An diese Stelle würde ein Datenbankzugriff integriert
a="Herr"
b="Max Mustermann"
c="Testsystem 123"
d="90003 Musterort"
while true; do
  clear
  echo "-------------------------------------------"
  echo "      Adressbearbeitung"
  echo "------+----------+-------------------------"
  echo "F-Nr. |          |    Wert"
  echo "  1   |  Anrede: | "$a
  echo "  2   |    Name: | "$b
  echo "  3   |  Straße: | "$c
  echo "  4   | PLZ/Ort: | "$d
  echo "------+----------+-------------------------"
  echo "Aktionen: [F-Nr]: Zeile ändern, [s] speichern,"
  echo "[q] Abbruch"
  echo -n "Aktion: ";read wn
  if [ "$wn" = "1" ]; then
    a=$(readpreprompt "Zeile $wn: " "$a")
  elif [ "$wn" = "2" ]; then
    b=$(readpreprompt "Zeile $wn: " "$b")
  elif [ "$wn" = "3" ]; then
    c=$(readpreprompt "Zeile $wn: " "$c")
  elif [ "$wn" = "4" ]; then
    d=$(readpreprompt "Zeile $wn: " "$d")
  elif [ "$wn" = "s" ]; then
    echo "Hier würde in die Datenbank geschrieben werden"
    break
  elif [ "$wn" = "q" ]; then
    exit
  fi
done
echo "-----------------------------"
echo $a
echo $b
echo $c
echo $d
