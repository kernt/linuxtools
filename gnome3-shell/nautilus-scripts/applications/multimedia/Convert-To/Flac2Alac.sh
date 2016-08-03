#!/bin/sh

echo ""
echo "flac2alac - script de conversão de áudio FLAC para ALAC"
echo "Este script usa o ffmpeg para conversão de áudio do tipo"
echo "FLAC (Free Lossless Audio Codec) para ALAC (Apple Lossless Audio Codec)."
echo "Por Arlindo \"Nighto\" Pereira"
echo ""

if [ "$1" ]
then
        ffmpeg  -i "$1" -acodec alac "`basename "$1" .flac`.m4a" \
                -metadata title=\""$(metaflac --show-tag=TITLE "$1" | sed 's/TITLE=//g')"\" \
                -metadata author=\""$(metaflac --show-tag=ARTIST "$1" | sed 's/ARTIST=//g')"\" \
                -metadata album=\""$(metaflac --show-tag=ALBUM "$1" | sed 's/ALBUM=//g')"\" \
                -metadata year=\""$(metaflac --show-tag=DATE "$1" | sed 's/DATE=//g')"\" \
                -metadata track=\""$(metaflac --show-tag=TRACKNUMBER "$1" | sed 's/TRACKNUMBER=//g')"\" \
                -metadata genre=\""$(metaflac --show-tag=GENRE "$1" | sed 's/GENRE=//g')"\"
else
        echo "Entre com o nome do arquivo para converter:"
        echo "flac2alac arquivo.flac"
        echo ""
exit 1
fi
