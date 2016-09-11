#!/bin/bash
#by Arturo Martinez-Nieves
#Section: Multimedia
#
#You can select multiple mpegs, asfs or vob in Nautilus and and convert them to MPEG or AVI (XVID) format.
#
#############
#
# video-convert including to xvid.01.2a
# 9/April/2006 - Last Updated: 9/April/2006
# based on:
# crmanski / http://szone.berlinwall.org
# Requirements: zenity (Comes with gnome 2.4), ffmpeg (apt-get ffmpeg)
# This script will take multiple video files of the same type (right now: MPG, AVI, MOV)
# and covert them into either NTSC - dvd, svcd or vcd compliant MPEG files by using
# ffmpeg (http://ffmpeg.sourceforge.net)	
### ADDED by Arturo Martinez-Nieves
### OPTION TO CONVERT TO XVID (.avi)
### Also added handling of .ASF files as input types.
# Installation:
# Place the script in the Nautilus scripts folder
# (/home/YourUserName/.gnome2/nautilus-scripts)
# Make sure the file is executable
# Select some video files. This works well on the video files my digital camera makes
# Choose Scripts->video-convert
#
# Background and Credits:
# I came across the very nicely done audio-convert script in the ubuntu forums
# http://ubuntuforums.org/showthread.php?t=48007
# and thought how nice it would be to not have to open each file I
want to convert in avidemux
# manually or by using a script for each file(s) using ffmpeg. So
after looking at
# http://g-scripts.sourceforge.net/ and some of the scripts there:
# http://g-scripts.sourceforge.net/nautilus-scripts/Multimedia/Image/NIS
# http://g-scripts.sourceforge.net/nautilus-scripts/Multimedia/Image/convert_to_jpeg
# I ended up working this out with various bits and pieces of the
above mentioned scripts.
# It is not pretty but it works for me.  Have fun!
#
# License:
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
# USA

#Has a file been selected?
if [ $# -eq 0 ]; then
        zenity --error --title="error" --text="You must select at least 1
file to process"
        exit 1
fi

#Input - What Type?
#Detect Mime Type
#This will detect the first file in the bunch and base the encoding on
that. Make sure you select the same types.
mime=`file -bi "$1"`
humantype=`file "$1"`
valid_video_type="0"
if [ "$mime" = "video/x-msvideo" ]; then
        video_in_type="AVI"
        valid_video_type="1"
fi
if [ "$mime" = "application/octet-stream" ]; then # this one is fishy
to me, but that is all the info I could get out of the files off my
camera
        video_in_type="MOV"
        valid_video_type="1"
fi
if [ "$mime" = "video/mpeg" ]; then
        video_in_type="MPG"
        valid_video_type="1"
fi
if [ "$mime" = "application/octet-stream" ]; then
        video_in_type="ASF"
        valid_video_type="1"
fi


#Checking...
if [ $valid_video_type -eq "1" ]; then
        valid_video_type = "1"
        else
        zenity --error --title="Error" --text="You have not selected a valid
Video Type. MimeType= $mime"
        exit
fi

#Output - What kind?
#echo "This Script converts selected AVI, MOVE or MPG files to
NTSC-DVD, SVCD or VCD compliant MPG files with ffmpeg"
title="What kind of Video Do you want to convert those $video_in_type files to?"
video_out_type=`zenity  --width="480" --height="380" --title="$title"
--list --radiolist --column="" \
        --column="Video Type" \
        TRUE "XVID" \
        FALSE "DVD" \
        FALSE "SVCD" \
        FALSE "VCD" | sed 's/ max//g' `

#user must select a target size
if [ ! "$video_out_type" ]; then
        zenity --error --title="Error" --text="You must select a Input Type"
        exit
fi

# If we are making DVD there are a few options...
if [ "$video_out_type" = "DVD" ]; then
        
        #What Size?
        title="Choose which resolution the video files should be..."
        dvd_res=`zenity --width="480" --height="380" --title="$title"
--text="Input format: $humantype" --list --radiolist --column=""
--column="Choose Video Resolution" --column "description" \
                TRUE "ntsc-dvd -s 720x480" "standard ntsc"\
                FALSE "ntsc-dvd -s 720x400 -padtop 40 -padbottom 40" "" \
                FALSE "ntsc-dvd -s 704x480" "" \
                FALSE "ntsc-dvd -s 704x396 -padtop 42 -padbottom 42" "" \
                FALSE "ntsc-dvd -s 352x480" "4:3 half ntsc" \
                FALSE "ntsc-dvd -s 352x240" "4:3 vcd size" \
                FALSE "ntsc-dvd -s 352x196 -padtop 22 -padbottom 22" "" \
                FALSE "pal-dvd -s 720x576" "4:3 full pal" \
                FALSE "pal-dvd -s 704x576" "" \
                FALSE "pal-dvd -s 352x576" "4:3 half pal" \
                FALSE "pal-dvd -s 352x288" "4:3 vcd size" \
                | sed 's/ max//g' `

        #PAL?
        if [ "${dvd_res##pal-dvd}" != "$dvd_res" ]; then
                video_out_type="DVD_PAL"
        fi

        #user must select a target size
        if [ ! "$dvd_res" ]; then
                zenity --error --title="Error" --text="You must select a target resolution."
                exit
        fi
        title="Choose the audio bitrate your video files should have..."
        audio_br=`zenity  --width="480" --height="380" --title="$title"
--list --radiolist --column="" \
        --column="Choose Audio Bitrate" \
                FALSE "448" \
                FALSE "356" \
                TRUE "224" \
                FALSE "160" \
                FALSE "128" | sed 's/ max//g' `
        #user must select an audio bitrate
        if [ ! "$audio_br" ]; then
                zenity --error --title="Error" --text="You must select an audio bitrate."
                exit
        fi
        title="Choose the audio stream type your video files should have..."
        audio_str=`zenity  --width="480" --height="380" --title="$title"
--list --radiolist --column="" --column="Choose Audio Stream Type"
TRUE "ac3" FALSE "mp2" | sed 's/ max//g' `
        #user must select an audio bitrate
        if [ ! "$audio_str" ]; then
                zenity --error --title="Error" --text="You must select an audio stream type."
                exit
        fi
fi

#SVCD Options
if [ "$video_out_type" = "SVCD" ]; then
        title="What type of SVCD are you making?"
        video_out_type=`zenity  --width="480" --height="380" --title="$title"
--list --radiolist --column="" \
        --column="NTSC or PAL?" \
                TRUE "SVCD_NTSC" \
                FALSE "SVCD_PAL" \
                | sed 's/ max//g' `
fi

#VCD Options
if [ "$video_out_type" = "VCD" ]; then
        title="What type of VCD are you making?"
        video_out_type=`zenity  --width="480" --height="380" --title="$title"
--list --radiolist --column="" \
        --column="NTSC or PAL?" \
                TRUE "VCD_NTSC" \
                FALSE "VCD_PAL" \
                | sed 's/ max//g' `
fi

#Video Encoding Functions...
dvd_encode_ntsc ()
{
        /usr/bin/ffmpeg -i "$movie" -target $dvd_res -sameq -r 29.97 -aspect
4:3 -ab $audio_br -ar 48000 -ac 2 -acodec $audio_str -y "$mpg_file"
}
dvd_encode_pal ()
{
        /usr/bin/ffmpeg -i "$movie" -target $dvd_res -sameq -r 25 -ab
$audio_br -ar 48000 -ac 2 -acodec $audio_str -y "$mpg_file"

}
svcd_encode_ntsc ()
{
        /usr/bin/ffmpeg -i "$movie" -target ntsc-svcd -sameq -aspect 4:3 -y "$mpg_file"
}
svcd_encode_pal ()
{
        /usr/bin/ffmpeg -i "$movie" -target pal-svcd -sameq -aspect 4:3 -y "$mpg_file"
}
vcd_encode_ntsc ()
{
        /usr/bin/ffmpeg -i "$movie" -target ntsc-vcd -sameq -aspect 4:3 -y "$mpg_file"
}
vcd_encode_pal ()
{
        /usr/bin/ffmpeg -i "$movie" -target pal-vcd -sameq -aspect 4:3 -y "$mpg_file"
}
xvid_encode ()
{
        /usr/bin/ffmpeg -i "$movie" -f avi -vcodec mpeg4 -b 800 -g 300 -bf 2
-acodec mp2 -ab 128 -y "$avi_file"
}

#Input Selection was AVI Video
if [ "$video_in_type" = "AVI" ]; then
        mime=`file -bi "$*"`
        nb_video=`echo "$mime" | grep video/x-msvideo | wc -l`

        let "nbfiles = $nb_video"

        while [ $# -gt 0 ]; do
                movie=$1
                mpg_file=`echo "$movie" | sed 's/\.\w*$/.mpg/'`
                mime=`file -bi "$movie"`
                isvideo=`echo "$mime" | grep video/x-msvideo | wc -l`
                if [ $isvideo -eq 0 ]; then
                        zenity --error --title="error" --text="$movie is not an AVI video file"
                else
                        echo "# Processing AVI Video $movie ..."
                        if [ "$video_out_type" = "DVD" ]; then
                                dvd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "DVD_PAL" ]; then
                                dvd_encode_pal
                        fi
                        if [ "$video_out_type" = "SVCD_NTSC" ]; then
                                svcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "SVCD_PAL" ]; then
                                svcd_encode_pal
                        fi
                        if [ "$video_out_type" = "VCD_NTSC" ]; then
                                vcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "VCD_PAL" ]; then
                                vcd_encode_pal
                        fi
                        if [ "$video_out_type" = "XVID" ]; then
                                xvid_encode
                        fi
                fi      
                
                shift
        done 2>&1|
                perl -ne '$/="\r";$| = 1;if (/Duration:
(\d+):(\d+):(\d+)/) { $max=($1*3600+$2*60+$3) };
                if (/time=(\d+)/) { printf "%d\n",($1/$max*100);}
                print STDERR $_;'|
                zenity --progress --auto-close --title="Converting AVI Video
Files"  --text="Converting AVI Video Files..."  --percentage=0
fi

#Input Selection was Quicktime Video
if [ "$video_in_type" = "MOV" ]; then
        mime=`file -bi "$*"`
        nb_video=`echo "$mime" | grep application/octet-stream | wc -l`

        let "nbfiles = $nb_video"

        while [ $# -gt 0 ]; do
                movie=$1
                mpg_file=`echo "$movie" | sed 's/\.\w*$/.mpg/'`
                mime=`file -bi "$movie"`
                isvideo=`echo "$mime" | grep application/octet-stream | wc -l`
                if [ $isvideo -eq 0 ]; then
                        zenity --error --title="error" --text="$movie is not a Quicktime video file"
                else
                        echo "# Processing Quicktime Video $movie ..."
                        if [ "$video_out_type" = "DVD" ]; then
                                dvd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "DVD_PAL" ]; then
                                dvd_encode_pal
                        fi
                        if [ "$video_out_type" = "SVCD_NTSC" ]; then
                                svcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "SVCD_PAL" ]; then
                                svcd_encode_pal
                        fi
                        if [ "$video_out_type" = "VCD_NTSC" ]; then
                                vcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "VCD_PAL" ]; then
                                vcd_encode_pal
                        fi
                        if [ "$video_out_type" = "XVID" ]; then
                                xvid_encode
                        fi
                fi      
                
                shift
        done 2>&1|
                perl -ne '$/="\r";$| = 1;if (/Duration:
(\d+):(\d+):(\d+)/) { $max=($1*3600+$2*60+$3) };
                if (/time=(\d+)/) { printf "%d\n",($1/$max*100);}
                print STDERR $_;'|
                zenity --progress --auto-close --title="Converting Quicktime
Video Files"  --text="Converting Quicktime Video Files..." 
--percentage=0
fi

#Input Selection was MPG Video
if [ "$video_in_type" = "MPG" ]; then
        mime=`file -bi "$*"`
        nb_video=`echo "$mime" | grep video/mpeg | wc -l`

        let "nbfiles = $nb_video"

        while [ $# -gt 0 ]; do
                movie=$1
                mpg_file=`echo "$movie" | sed 's/\.\w*$/_NTSC-DVD.mpg/'`
                avi_file=`echo "$movie" | sed 's/\.\w*$/_XVID.avi/'`
                mime=`file -bi "$movie"`
                isvideo=`echo "$mime" | grep video/mpeg | wc -l`
                if [ $isvideo -eq 0 ]; then
                        zenity --error --title="error" --text="$movie is not a MPG video file"
                else
                        echo "# Processing MPG Video $movie ..."
                        if [ "$video_out_type" = "DVD" ]; then
                                dvd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "DVD_PAL" ]; then
                                dvd_encode_pal
                        fi
                        if [ "$video_out_type" = "SVCD_NTSC" ]; then
                                svcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "SVCD_PAL" ]; then
                                svcd_encode_pal
                        fi
                        if [ "$video_out_type" = "VCD_NTSC" ]; then
                                vcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "VCD_PAL" ]; then
                                vcd_encode_pal
                        fi
                        if [ "$video_out_type" = "XVID" ]; then
                                xvid_encode
                        fi
                fi      
                
                shift
        done 2>&1|
                perl -ne '$/="\r";$| = 1;if (/Duration:
(\d+):(\d+):(\d+)/) { $max=($1*3600+$2*60+$3) };
                if (/time=(\d+)/) { printf "%d\n",($1/$max*100);}
                print STDERR $_;'|
                zenity --progress --auto-close --title="Converting MPG Video
Files"  --text="Converting MPG Video Files..."  --percentage=0
fi

#Input Selection was MPG Video
if [ "$video_in_type" = "MPG" ]; then
        mime=`file -bi "$*"`
        nb_video=`echo "$mime" | grep video/mpeg | wc -l`

        let "nbfiles = $nb_video"

        while [ $# -gt 0 ]; do
                movie=$1
                mpg_file=`echo "$movie" | sed 's/\.\w*$/_NTSC-DVD.mpg/'`
                avi_file=`echo "$movie" | sed 's/\.\w*$/_XVID.avi/'`
                mime=`file -bi "$movie"`
                isvideo=`echo "$mime" | grep video/mpeg | wc -l`
                if [ $isvideo -eq 0 ]; then
                        zenity --error --title="error" --text="$movie is not a MPG video file"
                else
                        echo "# Processing MPG Video $movie ..."
                        if [ "$video_out_type" = "DVD" ]; then
                                dvd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "DVD_PAL" ]; then
                                dvd_encode_pal
                        fi
                        if [ "$video_out_type" = "SVCD_NTSC" ]; then
                                svcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "SVCD_PAL" ]; then
                                svcd_encode_pal
                        fi
                        if [ "$video_out_type" = "VCD_NTSC" ]; then
                                vcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "VCD_PAL" ]; then
                                vcd_encode_pal
                        fi
                        if [ "$video_out_type" = "XVID" ]; then
                                xvid_encode
                        fi
                fi      
                
                shift
        done 2>&1|
                perl -ne '$/="\r";$| = 1;if (/Duration:
(\d+):(\d+):(\d+)/) { $max=($1*3600+$2*60+$3) };
                if (/time=(\d+)/) { printf "%d\n",($1/$max*100);}
                print STDERR $_;'|
                zenity --progress --auto-close --title="Converting MPG Video
Files"  --text="Converting MPG Video Files..."  --percentage=0
fi

#Input Selection was ASF Video
if [ "$video_in_type" = "ASF" ]; then
        mime=`file -bi "$*"`
        nb_video=`echo "$mime" | grep application/octet-stream | wc -l`

        let "nbfiles = $nb_video"

        while [ $# -gt 0 ]; do
                movie=$1
                mpg_file=`echo "$movie" | sed 's/\.\w*$/_NTSC-DVD.mpg/'`
                avi_file=`echo "$movie" | sed 's/\.\w*$/_XVID.avi/'`
                mime=`file -bi "$movie"`
                isvideo=`echo "$mime" | grep application/octet-stream | wc -l`
                if [ $isvideo -eq 0 ]; then
                        zenity --error --title="error" --text="$movie is not a ASF video file"
                else
                        echo "# Processing ASF Video $movie ..."
                        if [ "$video_out_type" = "DVD" ]; then
                                dvd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "DVD_PAL" ]; then
                                dvd_encode_pal
                        fi
                        if [ "$video_out_type" = "SVCD_NTSC" ]; then
                                svcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "SVCD_PAL" ]; then
                                svcd_encode_pal
                        fi
                        if [ "$video_out_type" = "VCD_NTSC" ]; then
                                vcd_encode_ntsc
                        fi
                        if [ "$video_out_type" = "VCD_PAL" ]; then
                                vcd_encode_pal
                        fi
                        if [ "$video_out_type" = "XVID" ]; then
                                xvid_encode
                        fi
                fi      
                
                shift
        done 2>&1|
                perl -ne '$/="\r";$| = 1;if (/Duration:
(\d+):(\d+):(\d+)/) { $max=($1*3600+$2*60+$3) };
                if (/time=(\d+)/) { printf "%d\n",($1/$max*100);}
                print STDERR $_;'|
                zenity --progress --auto-close --title="Converting MPG Video
Files"  --text="Converting MPG Video Files..."  --percentage=0
fi

