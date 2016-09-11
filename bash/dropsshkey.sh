#!/bin/bash
IP=$1
ssh-keygen -f "/home/tobkern/.ssh/known_hosts" -R $IP
