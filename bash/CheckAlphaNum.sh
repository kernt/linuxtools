#!bin/sh
# Author: Tobias Kern
# Kontakt: admin@computernotfalldienst.de
# Name : checkalphanum.sh
# checkInput() : Überprüft, dass eine richtige Eingabe aus alpha-/numerischen Zeichen besteht.
# checkInt() : Überprüft den Integer wert auf gültigkeit
# Gibt 0 (=OK) zurück, wenn alle Zeichen aus Groß- und Kleinbuchstaben und Zahlen besthen.
# ansonsten wird immer 1 zurückgegeben.
checkInput() {
 if [ -z "$input" ]
 then
  echo "Es wurde nichts eingegeben"
  exit 1
 fi
 
 
# Alle unerwünschten Zeichen entvernen ...
inputTmp="`echo $1 | sed -e 's/[^[:alnum]]//g'`"
# .. und dann vergliechen


  if [ "$inputTmp" != "$input" ]
    then 
      return 1
    else
      return 0
   fi
}

checkInt() {
number="$1"

# Mindestwert für Integer
min=2147483648

# maximaler Wert für einen Interger
max=2147483647

if [ -z $number ]
  then
    echo "Es wurde nichts eingeben"
    exit 1
fi

# Prüfung auf einen Negativen wert
if [ "${number%${number#?}}" = "-" ]
  then
    testinteger="${number#?}"
  else
    testinteger="$number"
fi

# Alle zeichen außer Zahlen entvernen
extract_nodigits="`echo $testinteger | \
		   sed 's/[[:digit:]]//g'`"
# Überprüfen ob noch unerwüschte zeichen vorhanden sind
if [ ! -z $extract_nodigits ]
  then
    echo "Kein numerisches Format!"
    return 1
fi

# Mindestwert einhalten
if [ "$number" -lt "$min" ]
  then
    echo "Der Wert ist unter dem erlaubten Mindestwert : $min"
    return1
fi

# max. Grenze einhalten
if [ "$number" -gt "$max" ]
  then
    echo "Der Wert ist über dem erlaubten Maximalwert : $max"
    return 1
fi
  return 0
}
