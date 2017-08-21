#!/bin/bash
find . -type d -print0 | while read -d $'\0' dir; do cd "$dir"; echo " process $dir"; find . -maxdepth 1 -name "*.ogg.mp3" -exec rename 's/.ogg.mp3/.mp3/' {} \; ; cd -; done
