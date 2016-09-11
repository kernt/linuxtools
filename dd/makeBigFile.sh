#!/bin/bash
# 
# 
# 
# 
# 
# Erstellt eine große datei z.B 100GB
# hier wird bei bs 1GB Ram benötigt bei 1024*1024*1024*1024 wären
# 1TB notwendig! und 100TB erzeugt.
DUMP1GBRAM=((1024*1024*1024))
DUMP20GBRAM=((1024*1024*1024*20))
DUMP30GBRAM=((1024*1024*1024*30))
dd if=/dev/zero of=dump.bin bs=$((1024*1024*1024)) count=100
exit 0
