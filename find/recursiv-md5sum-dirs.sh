#!/bin/bash
#http://www.commandlinefu.com/commands/view/13627/find-files-that-have-been-modified-recently
find . -type f -name '*' -exec md5sum '{}' + > hashes.txt
