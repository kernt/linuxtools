#/bin/bash
gnome-terminal --window-with-profile=NOCLOSEPROFILE -e "ssh root@192.168.4.95 'shutdown -h now'"
exit 0

