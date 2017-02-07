#!/bin/bash
# Small script to recursively show dependencies of packages
# Author: Remy van Elst <raymii.org>

pkgdep() {
  apt-cache depends --installed $1 | awk -F\: '{print $2}' | grep -v -e '<' -e '>' | awk 'NF'
}

for i in $(pkgdep $1); do
  pkgdep $i
done | sort -u
