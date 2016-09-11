#!/bin/bash
#
#
# Reason somtimes if exchenged your nis they cant be fount than than execute this script
# Source: http://askubuntu.com/questions/82470/what-is-the-correct-way-to-restart-udev

sudo service udev restart
sudo udevadm control --reload-rules
