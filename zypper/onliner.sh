# 
# doc https://de.opensuse.org/SDB:Zypper_benutzen
APP=$1
# search install app 
zypper se $APP | grep "^i" | less 
