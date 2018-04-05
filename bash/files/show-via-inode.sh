#/bin/bash
INODE="$1"


find -inum $INODE

# ext4 
# debugfs -R "ncheck $INODE" file 2>/dev/null



exit 0
