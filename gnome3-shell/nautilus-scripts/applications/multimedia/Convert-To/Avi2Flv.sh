#!/bin/bash
echo
echo "  ~·~·~·~·~·~·~·~·~·~·~·~·~·"
echo " * Script By FrankRock.it *"
echo " ~·~·~·~·~·~·~·~·~·~·~·~··"
echo
# Selezionare il file avi ed aspettare la fine della conversione.
#
# By http://www.frankrock.it
# frankrock74@gmail.com
#
VAR=$@
mencoder -forceidx -of lavf -oac mp3lame -lameopts abr:br=64 -srate 22050 -ovc lavc  -lavcopts vcodec=flv:vqscale=6:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 -o "$VAR".flv "$VAR" | zenity --progress --pulsate --auto-close --title="By FrankRock.it" --text="ATTENDERE! \n Sto convertendo "$VAR""

zenity --info --title="By FrankRock.it" --text="Operazione completata\! \n By FrankRock.it v 1.0"
