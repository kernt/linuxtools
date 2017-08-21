#!/bin/bash
TARGETDIR="$1"
find $TARGETDIR -type f -mmin -60 --mindepth 2
