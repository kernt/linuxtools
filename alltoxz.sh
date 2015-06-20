#!/bin/bash

# Convert all compressed files under the current directory to
# be in XZ format for maximum space efficiency.

if [ ! "$(find -name *\ *)" == "" ]
	then echo "WARNING: Filenames with spaces found, aborting."
	exit 1
fi

CATCOM="pv -B 65536"; test ! -e /usr/bin/pv && CATCOM=cat

# Rename .tgz to .tar.gz so they work as expected
for X in $(find -name \*.tgz)
	do mv "$X" "$(echo "$X" | sed 's/\.tgz$/.tar.gz/')"
done

GZ=$(find -name \*.gz)
BZ2=$(find -name \*.bz2)
LZO=$(find -name \*.lzo)
LZMA=$(find -name \*.lzma)
unset XZ; test "$1" = "-f" && XZ=$(find -name \*.xz)

R=0
unset NT

cleanup () {
	rm -f "$NT"
	echo "$R bytes total saved before aborting."
	exit 1
}

trap cleanup ABRT QUIT TERM INT

echo "Converting all archives to XZ format, please wait."

for COMP in gzip bzip2 lzop lzma xz
	do case $COMP in
		gzip) EXT="gz"; FILES="$GZ" ;;
		bzip2) EXT="bz2"; FILES="$BZ2" ;;
		lzop) EXT="lzo"; FILES="$LZO" ;;
		lzma) EXT="lzma"; FILES="$LZMA" ;;
		xz) EXT="xz"; FILES="$XZ" ;;
		*) echo "Bad compressor specified."; exit 1 ;;
	esac
	for X in $FILES
		do SIZE1=$(du -sb ${X} | cut -f1)
		NT="${X}.tempfile"
		NEW=$(echo "${X}" | sed "s/\.${EXT}\$/.xz/g")
		if [ -e "$X" ]
			then echo "$X => $NEW"
			if $CATCOM $X | $COMP -dc | xz -9e > $NT
				then rm $X; mv "$NT" "$NEW"
				echo "done."
				else rm $NT
				echo "error."
			fi
		fi
		SIZE2=$(du -sb ${NEW} | cut -f1)
		DIFF=$(( $SIZE1 - $SIZE2 ))
		R=$(( $R + $DIFF ))
		echo "$X cut $DIFF; $R total"
	done
done
