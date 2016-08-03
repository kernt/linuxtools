#!/bin/bash


# Video To Avi
# Created:	Inameiname
# Version:	3.2








######################################################################################################################################################
###### OPEN IN TERMINAL ###### OPEN IN TERMINAL ###### OPEN IN TERMINAL ###### OPEN IN TERMINAL ###### OPEN IN TERMINAL ###### OPEN IN TERMINAL ######
######################################################################################################################################################








##################################################
# Run in the terminal on double-click		 #
##################################################

tty -s; if [ $? -ne 0 ] ; then gnome-terminal -e "$0"; exit; fi



##################################################
# If it doesn't run in the terminal on 		 #
# double-click, say so				 #
##################################################

[ -t 0 ] && [ -t 1 ] || { zenity --warning --text="${0}: this script must be run from a terminal." ; exit 1 ;}








######################################################################################################################################################
###### INPUT SOURCE VIDEO2AVI STUFF ###### INPUT SOURCE VIDEO2AVI STUFF ###### INPUT SOURCE VIDEO2AVI STUFF ###### INPUT SOURCE VIDEO2AVI STUFF ######
######################################################################################################################################################








##################################################
# Check whether environment variables are empty	 #
##################################################

###### see if the Nautilus environment variable is empty

# if it exists, set it equal to 'INPUT_FILE'
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    ARCHIVE_PATH=${ARCHIVE_FULLPATH%.*}
if [ -f $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ] ; then

# if select iso file:
if [ $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS = $ARCHIVE_PATH.iso ] ; then
# to get desired title on dvd
# requires lsdvd: sudo apt-get install lsdvd
lsdvd $ARCHIVE_PATH.iso

echo -n "Please enter the title number you will convert (usually the longest one):

Press 'Enter' for default (default is '1')...

"
read TITLE

# extra blank space
echo "
"

# default
if [[ -z $TITLE ]] ; then
# If no title passed, default to 1
    TITLE=1
fi

    INPUT_FILE="dvd://$TITLE -dvd-device $ARCHIVE_PATH.iso"
fi



# if select video file:
if [ $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS != $ARCHIVE_PATH.iso ] ; then
    INPUT_FILE=$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
fi

fi

done


# if it's blank, set it equal to $1
if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ] ; then
    # If it's blank, set it equal to $1
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1



###### see if the '$1' variable is empty
# if it exists, set it equal to 'INPUT_FILE'
for ARCHIVE_FULLPATH in $1; do
    ARCHIVE_PATH=${ARCHIVE_FULLPATH%.*}
if [ -f $1 ] ; then

# if select iso file:
if [ $1 = $ARCHIVE_PATH.iso ] ; then
# to get desired title on dvd
# requires lsdvd: sudo apt-get install lsdvd
lsdvd $ARCHIVE_PATH.iso

echo -n "Please enter the title number you will convert (usually the longest one):

Press 'Enter' for default (default is '1')...

"
read TITLE

# extra blank space
echo "
"

# default
if [[ -z $TITLE ]] ; then
# If no title passed, default to 1
    TITLE=1
fi

    INPUT_FILE="dvd://$TITLE -dvd-device $ARCHIVE_PATH.iso"
fi



# if select video file:
if [ $1 != $ARCHIVE_PATH.iso ] ; then
    INPUT_FILE=$1
fi

fi

done



# if it's blank, do the following:
if [ -z "$1" ] ; then



##################################################
# Input DVD/ISO/VIDEO file menu			 #
##################################################

echo -n "What do you want to convert to AVI?:

(1) DVD
(2) ISO file
(3) Video file (such as MKV, VOB, MPEG, AVI, WMV, and etc.)

Press 'Enter' for default (default is '1')...

"
read TYPE

# extra blank space
echo "
"



###### Input DVD/ISO/VIDEO source default ######

if [[ -z $TYPE ]] ; then
    # If no media passed, default to 1
    TYPE=1
fi



###### Input DVD/ISO/VIDEO source ######

###### DVD to AVI
if [[ $TYPE = 1 ]] ; then

# to get desired device
df -h -x tmpfs -x usbfs

echo -n "Please enter the appropriate DVD drive:

(1) /dev/dvd
(2) /dev/sr0
(3) /dev/sr1
(4) /dev/sr2
(5) custom

Press 'Enter' for default (default is '1')...

"
read DEVICE_NUMBER

# extra blank space
echo "
"

# default
if [[ -z $DEVICE_NUMBER ]] ; then
# If no device passed, default to /dev/dvd
    DEVICE=/dev/dvd
fi
# preset
if [[ $DEVICE_NUMBER = 1 ]] ; then
    DEVICE=/dev/dvd
fi
if [[ $DEVICE_NUMBER = 2 ]] ; then
    DEVICE=/dev/sr0
fi
if [[ $DEVICE_NUMBER = 3 ]] ; then
    DEVICE=/dev/sr1
fi
if [[ $DEVICE_NUMBER = 4 ]] ; then
    DEVICE=/dev/sr2
fi
# custom
if [[ $DEVICE_NUMBER = 5 ]] ; then
    echo -n "Please enter the appropriate DVD drive:  "
    echo -n "...like this: '/dev/dvd'..."
    read CUSTOM_DEVICE
    DEVICE=$CUSTOM_DEVICE
fi

# to get desired title on dvd
# requires lsdvd: sudo apt-get install lsdvd
lsdvd $DEVICE

echo -n "Please enter the title number you will convert (usually the longest one):

Press 'Enter' for default (default is '1')...

"
read TITLE

# extra blank space
echo "
"

# default
if [[ -z $TITLE ]] ; then
# If no title passed, default to 1
TITLE=1
fi

# to decide to copy straight from the DVD or first copy to hard drive to ISO
echo -n "Would you first like to copy the DVD onto your hard drive (to ISO)?:

(1) Yes (Highly Recommended)
(2) No

Press 'Enter' for default (default is '1')...

"
read DVD2ISO

# extra blank space
echo "
"

# default
if [[ -z $DVD2ISO ]] ; then
# If no DVD2ISO passed, default to 1
dd if=$DEVICE of=NEW.iso
INPUT_FILE="dvd://$TITLE -dvd-device NEW.iso"
fi
# preset
if [[ $DVD2ISO = 1 ]] ; then
dd if=$DEVICE of=NEW.iso
INPUT_FILE="dvd://$TITLE -dvd-device NEW.iso"
fi
if [[ $DVD2ISO = 2 ]] ; then
INPUT_FILE="dvd://$TITLE -dvd-device $DEVICE"
fi

fi



###### ISO to AVI
if [[ $TYPE = 2 ]] ; then

echo -n "Please enter the full path for the ISO:

Example: /home/(your username)/Videos/NEW.iso...

"
read ISO

# extra blank space
echo "
"

# to get desired title on dvd
# requires lsdvd: sudo apt-get install lsdvd
lsdvd $ISO

echo -n "Please enter the title number you will convert (usually the longest one):

Press 'Enter' for default (default is '1')...

"
read TITLE

# extra blank space
echo "
"

# default
if [[ -z $TITLE ]] ; then
# If no title passed, default to 1
TITLE=1
fi

INPUT_FILE="dvd://$TITLE -dvd-device $ISO"
fi



###### Video to AVI
if [[ $TYPE = 3 ]] ; then

echo -n "Please enter the name for the input file (full path, with extension):

It can be any type, such as MKV, VOB, MPEG, AVI, WMV, and etc...

Example: /home/(your username)/Videos/NEW.avi...

"
read VIDEO_FILE

# extra blank space
echo "
"

INPUT_FILE=$VIDEO_FILE
fi



##################################################
# Close the variable statements			 #
##################################################

fi



fi








######################################################################################################################################################
###### GENERAL VIDEO2AVI STUFF ###### GENERAL VIDEO2AVI STUFF ###### GENERAL VIDEO2AVI STUFF ###### GENERAL VIDEO2AVI STUFF ###### GENERAL VIDEO2AVI STUFF
######################################################################################################################################################








##################################################
# Cropping (done automatically)			 #
##################################################

###### start a timer to kill mplayer
echo "Cropdetect is now running...

A few seconds of your video should now be playing...
"



###### start a timer to kill mplayer
(sleep 6 && killall mplayer)&



###### start the mplayer cropdetect on on the DVD at a random time
mplayer $INPUT_FILE -ss 0:03:10 -vf cropdetect &> mplayer.tmp



###### get last crop value from mplayer output and store in variable
CROP_VALUES=$(awk -F'crop=' '/\[CROP\]/{f=$2} END{print f}' ./mplayer.tmp |cut -d')' -f1)



###### print detected crop values
echo -e "\n\nDetected crop values = ${CROP_VALUES}\n\n"



##################################################
# Output desired name for file			 #
##################################################

###### file input
echo -n "Please enter a name for the output file (without extension):

Press 'Enter' for default (default is 'NEW')...

"
read OUTPUT_FILE



###### extra blank space
echo "
"



###### default ######

if [[ -z $OUTPUT_FILE ]] ; then
    # If no file passed, default to NEW
    OUTPUT_FILE=NEW_$(date "+%y.%m.%d_%H.%M")
fi



##################################################
# Available processor number (done automatically)#
##################################################

CPUS=$(grep -c processor /proc/cpuinfo)

echo "Using $CPUS processor(s)..."



###### extra blank space
echo "
"








######################################################################################################################################################
###### MAIN MENU OPTIONS AND CHOICES ###### MAIN MENU OPTIONS AND CHOICES ###### MAIN MENU OPTIONS AND CHOICES ###### MAIN MENU OPTIONS AND CHOICES ######
######################################################################################################################################################








##################################################
# Preset/Custom type options			 #
##################################################

echo -n "Select a quality level:
(1) exact copy quality MPEG		    (DVD/ISO sources only)
(2) exact copy audio-only quality AC3	    (DVD/ISO sources only)
(3) very high quality H.264 (2-pass)	    (350min:105min film w/2 1.5mhz cpus)
(4) very high quality DIVX/MPEG-4 (2-pass)  (270min:105min film w/2 1.5mhz cpus)
(5) very high quality XVID (2-pass)	    (220min:105min film w/2 1.5mhz cpus)
(6) very high quality H.264 (1-pass)	    (400min:105min film w/2 1.5mhz cpus)
(7) very high quality DIVX/MPEG-4 (1-pass)  (230min:105min film w/2 1.5mhz cpus)
(8) very high quality XVID (1-pass)	    (180min:105min film w/2 1.5mhz cpus)
(9) high quality H.264 (2-pass)		    (240min:105min film w/2 1.5mhz cpus)
(10)high quality DIVX/MPEG-4 (2-pass)	    (190min:105min film w/2 1.5mhz cpus)
(11)high quality XVID (2-pass)		    (135min:105min film w/2 1.5mhz cpus)
(12)high quality H.264 (1-pass)	     	    (200min:105min film w/2 1.5mhz cpus)
(13)high quality DIVX/MPEG-4 (1-pass)	    (150min:105min film w/2 1.5mhz cpus)
(14)high quality XVID (1-pass)		    (090min:105min film w/2 1.5mhz cpus)
(15)fast quality H.264 (1-pass)	     	    (155min:105min film w/2 1.5mhz cpus)
(16)fast quality DIVX/MPEG-4 (1-pass)	    (065min:105min film w/2 1.5mhz cpus)
(17)fast quality XVID (1-pass)		    (065min:105min film w/2 1.5mhz cpus)
(18)fast quality XVID YouTube (1-pass)	    (025min:105min film w/2 1.5mhz cpus)
(19)realtime quality DIVX/MPEG-4 (1-pass)   (050min:105min film w/2 1.5mhz cpus)
(20)realtime quality XVID (1-pass)	    (060min:105min film w/2 1.5mhz cpus)
(21)low quality WMV (1-pass)		    (017min:105min film w/2 1.5mhz cpus)
(22)custom quality
Press 'Enter' for default (default is '14')...  "
read Q



###### extra blank space
echo "
"



###### default ######

if [[ -z $Q ]] ; then
    # If no quality passed, default to 14
    Q=14
fi



##################################################
# Frame rate					 #
##################################################

###### frame rate menu
if [[ $Q != 1 && $Q != 2 ]] ; then
echo -n "Select a frame rate level:

(1) NTSC-VIDEO 	(~ 30 fps)
(2) NTSC-FILM	(~ 24 fps)
(3) PAL		(~ 25 fps)
(4) Streaming	(~ 15 fps)
(5) custom

Press 'Enter' for default (default is '2')...

"
read FRAME_RATE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $FRAME_RATE_NUMBER ]] ; then
    # If no frame rate passed, default to 2
    FRAME_RATE="-ofps 24000/1001"
fi



###### preset
if [[ $FRAME_RATE_NUMBER = 1 ]] ; then
    FRAME_RATE="-ofps 30000/1001"
fi

if [[ $FRAME_RATE_NUMBER = 2 ]] ; then
    FRAME_RATE="-ofps 24000/1001"
fi

if [[ $FRAME_RATE_NUMBER = 3 ]] ; then
    FRAME_RATE="-ofps 25000/1001"
fi

if [[ $FRAME_RATE_NUMBER = 4 ]] ; then
    FRAME_RATE="-ofps 15000/1001"
fi



###### custom
if [[ $FRAME_RATE_NUMBER = 5 ]] ; then
    echo -n "Please enter a frame rate:  "
    echo -n "...like this: '-ofps 15000/1001'..."
    read CUSTOM_FRAME_RATE
    FRAME_RATE=$CUSTOM_FRAME_RATE
fi



fi



##################################################
# Divx ffourcc menu				 #
##################################################

###### DivX ffourcc menu
if [[ $Q != 1 && $Q != 2 && $Q != 3 && $Q != 5 && $Q != 6 && $Q != 8 && $Q != 9 && Q != 11 && $Q != 12 && $Q != 14 && $Q != 15 && $Q != 17 && $Q != 18 && $Q != 20 && $Q != 21 && $Q != 22 ]] ; then
echo -n "Select the desired Divx or generic MPEG4 quality:

(1) FFMPEG MPEG-4
(2) DivX MPEG-4 Version 4
(3) DivX MPEG-4 Version 5

Press 'Enter' for default (default is '3')...

"
read DIVX_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $DIVX_NUMBER ]] ; then
    # If no file passed, default to 3
    DIVX="-ffourcc DX50"
fi



###### preset
if [[ $DIVX_NUMBER = 1 ]] ; then
    DIVX=
fi

if [[ $DIVX_NUMBER = 2 ]] ; then
    DIVX="-ffourcc DIVX"
fi

if [[ $DIVX_NUMBER = 3 ]] ; then
    DIVX="-ffourcc DX50"
fi



fi



##################################################
# Conversion is starting			 #
##################################################

###### conversion is starting message
if [[ $Q != 22 ]] ; then
read -sn 1 -p "Your conversion is about to begin, press any key to continue..."
fi



###### extra blank space
echo "
"



##################################################
# Conversions					 #
##################################################

###### preset ######

###### exact copy quality (DVD/ISO sources only)
if [[ $Q = 1 ]] ; then
# If 1 passed, use MPEG exact copy quality
mplayer $INPUT_FILE -dumpstream -dumpfile $OUTPUT_FILE.mpg
fi

if [[ $Q = 2 ]] ; then
# If 2 passed, use MPEG exact copy audio-only quality
mplayer $INPUT_FILE -dumpaudio -dumpfile $OUTPUT_FILE.ac3
fi



###### very high quality
if [[ $Q = 3 ]] ; then
# very high H.264 quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc x264 -x264encopts pass=1:subq=1:partitions=all:8x8dct:me=umh:frameref=1:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=2000 -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES} $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc x264 -x264encopts pass=2:subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=2000 -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 4 ]] ; then
# very high MPEG4 quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc lavc $DIVX -lavcopts vpass=1:vcodec=mpeg4:mbd=2:trell:v4mv:last_pred=2:dia=-1:vmax_b_frames=2:vb_strategy=1:cmp=3:subcmp=3:precmp=0:vqcomp=0.6:turbo:vhq:threads=$CPUS:vbitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc lavc $DIVX -lavcopts vpass=2:vcodec=mpeg4:mbd=2:mv0:trell:v4mv:cbp:last_pred=3:predia=2:dia=2:vmax_b_frames=2:vb_strategy=1:precmp=2:cmp=2:subcmp=2:preme=2:qns=2:vhq:threads=$CPUS:vbitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 5 ]] ; then
# very high XVID quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc xvid -xvidencopts pass=1:chroma_opt:vhq=1:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc xvid -xvidencopts pass=2:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 6 ]] ; then
# very high H.264 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc x264 -x264encopts subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 7 ]] ; then
# very high MPEG4 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc lavc $DIVX -lavcopts vcodec=mpeg4:mbd=2:mv0:trell:v4mv:cbp:last_pred=3:predia=2:dia=2:vmax_b_frames=2:vb_strategy=1:precmp=2:cmp=2:subcmp=2:preme=2:qns=2:vhq:threads=$CPUS:vbitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 8 ]] ; then
# very high XVID quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=192:vol=3 -ovc xvid -xvidencopts chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=2000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES} $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### high quality
if [[ $Q = 9 ]] ; then
# high H.264 quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc x264 -x264encopts pass=1:subq=1:partitions=all:8x8dct:me=umh:frameref=1:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=-700000 -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc x264 -x264encopts pass=2:subq=5:8x8dct:frameref=2:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=1200 -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 10 ]] ; then
# high MPEG4 quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc lavc $DIVX -lavcopts vpass=1:vcodec=mpeg4:mbd=2:trell:v4mv:last_pred=2:dia=-1:vmax_b_frames=2:vb_strategy=1:cmp=3:subcmp=3:precmp=0:vqcomp=0.6:turbo:vhq:threads=$CPUS:vbitrate=1100 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc lavc $DIVX -lavcopts vpass=2:vcodec=mpeg4:mbd=2:trell:v4mv:last_pred=2:dia=-1:vmax_b_frames=2:vb_strategy=1:cmp=3:subcmp=3:precmp=0:vqcomp=0.6:turbo:vhq:threads=$CPUS:vbitrate=1100 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 11 ]] ; then
# high XVID quality (2-pass)
# actual two-pass conversion
mencoder $INPUT_FILE -nosound -ovc xvid -xvidencopts pass=1:vhq=1:bvhq=1:chroma_opt:quant_type=mpeg:threads=$CPUS:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc xvid -xvidencopts pass=2:vhq=2:bvhq=1:chroma_opt:quant_type=mpeg:threads=$CPUS:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 12 ]] ; then
# high H.264 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc x264 -x264encopts subq=5:8x8dct:frameref=2:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 13 ]] ; then
# high MPEG4 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc lavc $DIVX -lavcopts vcodec=mpeg4:mbd=2:trell:v4mv:last_pred=2:dia=-1:vmax_b_frames=2:vb_strategy=1:cmp=3:subcmp=3:precmp=0:vqcomp=0.6:turbo:vhq:threads=$CPUS:vbitrate=1100 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 14 ]] ; then
# high XVID quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc xvid -xvidencopts vhq=2:bvhq=1:chroma_opt:quant_type=mpeg:threads=$CPUS:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### fast quality
if [[ $Q = 15 ]] ; then
# fast H.264 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc x264 -x264encopts subq=4:8x8dct:bframes=2:b_pyramid=normal:weight_b:threads=auto:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 16 ]] ; then
# fast MPEG4 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc lavc $DIVX -lavcopts vcodec=mpeg4:mbd=2:trell:v4mv:turbo:vhq:threads=$CPUS:vbitrate=1100 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 17 ]] ; then
# fast XVID quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc xvid -xvidencopts turbo:vhq=0:threads=$CPUS:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### YouTube quality
if [[ $Q = 18 ]] ; then
# YouTube MPEG4 quality (1-pass)
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc lavc $DIVX -lavcopts vcodec=mpeg4:threads=$CPUS -ffourcc xvid -vf scale=320:-2,expand=:240:::1 $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### realtime quality
if [[ $Q = 19 ]] ; then
# realtime MPEG4 quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc lavc $DIVX -lavcopts vcodec=mpeg4:mbd=2:turbo:vhq:threads=$CPUS:vbitrate=1100 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $Q = 20 ]] ; then
# realtime XVID quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts abr:br=128:vol=3 -ovc xvid -xvidencopts turbo:nochroma_me:notrellis:max_bframes=0:vhq=0:threads=$CPUS:bitrate=-700000 -vf pp=de,pullup,softskip,crop=${CROP_VALUES},scale -zoom -xy 624 $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### low quality
if [[ $Q = 21 ]] ; then
# low WMV quality (1-pass)
# actual one-pass conversion
mencoder $INPUT_FILE -oac mp3lame -lameopts cbr:br=16:vol=3 -ovc lavc -lavcopts vcodec=wmv2:vbitrate=100 -vf scale -zoom -xy 240 $FRAME_RATE -o $OUTPUT_FILE.wmv
fi








######################################################################################################################################################
###### CUSTOM QUALITY CHOICE #17 OPTION AND CHOICES ###### CUSTOM QUALITY CHOICE #17 OPTION AND CHOICES ###### MISCELLANEOUS ###### CUSTOM QUALITY CHOICE
######################################################################################################################################################








##################################################
# Custom quality				 #
##################################################

if [[ $Q = 22 ]] ; then
# If 22 passed, use custom quality (1-pass and 2-pass)



##################################################
# Custom type options				 #
##################################################

echo -n "What type of AVI do you want to create with custom settings?:

(1)  H.264		(2-Pass)
(2)  H.264		(1-Pass)
(3)  DIVX/MPEG-4	(2-Pass)
(4)  DIVX/MPEG-4	(1-Pass)
(5)  XVID		(2-Pass)
(6)  XVID		(1-Pass)


Press 'Enter' for default (default is '6')...

"
read MPEG4_TYPE



###### extra blank space
echo "
"



###### default ######

if [[ -z $MPEG4_TYPE ]] ; then
    # If no media passed, default to 6
    MPEG4_TYPE=6
fi



##################################################
# Custom Divx ffourcc menu			 #
##################################################

###### DivX ffourcc menu
if [[ $MPEG4_TYPE != 1 && $MPEG4_TYPE != 2 && $MPEG4_TYPE != 5 && $MPEG4_TYPE != 6 ]] ; then
echo -n "Select the desired Divx or generic MPEG4 quality:

(1) FFMPEG MPEG-4
(2) DivX MPEG-4 Version 4
(3) DivX MPEG-4 Version 5

Press 'Enter' for default (default is '3')...

"
read CUSTOM_DIVX_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $CUSTOM_DIVX_NUMBER ]] ; then
    # If no file passed, default to 3
    CUSTOM_DIVX="-ffourcc DX50"
fi



###### preset
if [[ $CUSTOM_DIVX_NUMBER = 1 ]] ; then
    CUSTOM_DIVX=
fi

if [[ $CUSTOM_DIVX_NUMBER = 2 ]] ; then
    CUSTOM_DIVX="-ffourcc DIVX"
fi

if [[ $CUSTOM_DIVX_NUMBER = 3 ]] ; then
    CUSTOM_DIVX="-ffourcc DX50"
fi



fi



##################################################
# Custom scaling				 #
##################################################

echo -n "Choose a resolution:

(1)  original resolution(cropped, but no scaling)
(2)  624 x 352 scaling	(fullscreen/widescreen)
(3)  624 x ??? scaling	(fullscreen/widescreen)	(auto-height)
(4)  800 x 600 scaling	(fullscreen)
(5)  800 x ??? scaling	(fullscreen) 		(auto-height)
(6)  600 x 400 scaling	(widescreen)
(7)  600 x ??? scaling	(widescreen) 		(auto-height)
(8)  640 x 480 scaling	(fullscreen)
(9)  640 x ??? scaling	(fullscreen) 		(auto-height)
(10) 704 x 294 scaling	(widescreen) (2.35:1)
(11) 704 x ??? scaling	(widescreen) (2.35:1) 	(auto-height)
(12) 768 x 432 scaling	(widescreen) (16:9)
(13) 768 x ??? scaling	(widescreen) (16:9) 	(auto-height)
(14) custom

Press 'Enter' for default (default is '3')...

"
read SCALING_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $SCALING_NUMBER ]] ; then
    # If no file passed, default to 3
    SCALING="scale -zoom -xy 624"
fi



###### preset
if [[ $SCALING_NUMBER = 1 ]] ; then
    SCALING="scale=${CROP_VALUES}"
fi

if [[ $SCALING_NUMBER = 2 ]] ; then
    SCALING="scale=624:352"
fi

if [[ $SCALING_NUMBER = 3 ]] ; then
    SCALING="scale -zoom -xy 624"
fi

if [[ $SCALING_NUMBER = 4 ]] ; then
    SCALING="scale=800:600"
fi

if [[ $SCALING_NUMBER = 5 ]] ; then
    SCALING="scale -zoom -xy 800"
fi

if [[ $SCALING_NUMBER = 6 ]] ; then
    SCALING="scale=600:400"
fi

if [[ $SCALING_NUMBER = 7 ]] ; then
    SCALING="scale -zoom -xy 600"
fi

if [[ $SCALING_NUMBER = 8 ]] ; then
    SCALING="scale=640:480"
fi

if [[ $SCALING_NUMBER = 9 ]] ; then
    SCALING="scale -zoom -xy 640"
fi

if [[ $SCALING_NUMBER = 10 ]] ; then
    SCALING="scale=704:294"
fi

if [[ $SCALING_NUMBER = 11 ]] ; then
    SCALING="sscale -zoom -xy 704"
fi

if [[ $SCALING_NUMBER = 12 ]] ; then
    SCALING="scale=768:432"
fi

if [[ $SCALING_NUMBER = 13 ]] ; then
    SCALING="scale -zoom -xy 768"
fi



###### custom
if [[ $SCALING_NUMBER = 14 ]] ; then
    echo -n "Please enter a custom scale:  "
    echo -n "...like this: 'scale=800:600' or 'scale -zoom -xy 624'..."
    read CUSTOM_SCALING
    SCALING=$CUSTOM_SCALING
fi



##################################################
# Custom total/video bitrate level		 #
##################################################

echo -n "Select a total/video bitrate level:

(1)  -350000	(= max file size of ~ 350MB)	(H.264/XVID only)
(2)  -700000	(= max file size of ~ 700MB)	(H.264/XVID only)
(3)  -1000000	(= max file size of ~ 1GB)	(H.264/XVID only)
(4)  400 kbps
(5)  600 kbps
(6)  800 kbps
(7)  1000 kbps
(8)  1100 kbps
(9)  1150 kbps
(10) 1200 kbps
(11) 1250 kbps
(12) 1500 kbps
(13) 2000 kbps
(14) 3000 kbps
(15) 4000 kbps
(16) 5000 kbps
(17) custom

Press 'Enter' for default (default is '2')...

"
read BITRATE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $BITRATE_NUMBER ]] ; then
    # If no file passed, default to 2
    BITRATE=-700000
fi



###### preset
if [[ $BITRATE_NUMBER = 1 ]] ; then
    BITRATE=-350000
fi

if [[ $BITRATE_NUMBER = 2 ]] ; then
    BITRATE=-700000
fi

if [[ $BITRATE_NUMBER = 3 ]] ; then
    BITRATE=-1000000
fi

if [[ $BITRATE_NUMBER = 4 ]] ; then
    BITRATE=400
fi

if [[ $BITRATE_NUMBER = 5 ]] ; then
    BITRATE=600
fi

if [[ $BITRATE_NUMBER = 6 ]] ; then
    BITRATE=800
fi

if [[ $BITRATE_NUMBER = 7 ]] ; then
    BITRATE=1000
fi

if [[ $BITRATE_NUMBER = 8 ]] ; then
    BITRATE=1100
fi

if [[ $BITRATE_NUMBER = 9 ]] ; then
    BITRATE=1150
fi

if [[ $BITRATE_NUMBER = 10 ]] ; then
    BITRATE=1200
fi

if [[ $BITRATE_NUMBER = 11 ]] ; then
    BITRATE=1250
fi

if [[ $BITRATE_NUMBER = 12 ]] ; then
    BITRATE=1500
fi

if [[ $BITRATE_NUMBER = 13 ]] ; then
    BITRATE=2000
fi

if [[ $BITRATE_NUMBER = 14 ]] ; then
    BITRATE=3000
fi

if [[ $BITRATE_NUMBER = 15 ]] ; then
    BITRATE=4000
fi

if [[ $BITRATE_NUMBER = 16 ]] ; then
    BITRATE=5000
fi



###### custom
if [[ $BITRATE_NUMBER = 17 ]] ; then
    echo -n "Please enter a custom total/video bitrate:  "
    echo -n "...like this: '1175'..."
    read CUSTOM_BITRATE
    BITRATE=$CUSTOM_BITRATE
fi



##################################################
# Custom audio track				 #
##################################################

echo -n "Select an audio track:

(1) -aid 0	(good when getting no audio with others) (ex.: Custom DVD rips)
(2) -aid 127
(3) -aid 128	(often main language non-director's commentary audio track)
(4) -aid 129	(often second track, such as director's commentary)
(5) -aid 130
(6) -aid 131
(7) -aid 132
(8) -aid 160
(9) custom

Press 'Enter' for default (default is 'null', which is DVD default)...

"
read AUDIO_TRACK_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $AUDIO_TRACK_NUMBER ]] ; then
    # If no file passed, default to null
    AUDIO_TRACK=
fi



###### preset
if [[ $AUDIO_TRACK_NUMBER = 1 ]] ; then
    AUDIO_TRACK="-aid 0"
fi

if [[ $AUDIO_TRACK_NUMBER = 2 ]] ; then
    AUDIO_TRACK="-aid 127"
fi

if [[ $AUDIO_TRACK_NUMBER = 3 ]] ; then
    AUDIO_TRACK="-aid 128"
fi

if [[ $AUDIO_TRACK_NUMBER = 4 ]] ; then
    AUDIO_TRACK="-aid 129"
fi

if [[ $AUDIO_TRACK_NUMBER = 5 ]] ; then
    AUDIO_TRACK="-aid 130"
fi

if [[ $AUDIO_TRACK_NUMBER = 6 ]] ; then
    AUDIO_TRACK="-aid 131"
fi

if [[ $AUDIO_TRACK_NUMBER = 7 ]] ; then
    AUDIO_TRACK="-aid 132"
fi

if [[ $AUDIO_TRACK_NUMBER = 8 ]] ; then
    AUDIO_TRACK="-aid 160"
fi



###### custom
if [[ $AUDIO_TRACK_NUMBER = 9 ]] ; then
    echo -n "Please enter a custom audio track:  "
    echo -n "...like this: '-aid 128'..."
    read CUSTOM_AUDIO_TRACK
    AUDIO_TRACK=$CUSTOM_AUDIO_TRACK
fi



##################################################
# Custom audio track language			 #
##################################################

echo -n "Select an audio track language:

(1)  Chinese - zh
(2)  Dansk (Danish) - da
(3)  Deutsch - de
(4)  English - en
(5)  Español - es
(6)  Français - fr
(7)  Greek - el
(8)  Italiano (Italian) - it
(9)  Japanese - ja
(10) Korean - ko
(11) Nederlands - nl
(12) Polish - pl
(13) Portugues - pt
(14) Russian - ru

Or input your own (like this: 'en')...

Press 'Enter' for default (default is 'null', which is DVD default)...

"
read AUDIO_LANGUAGE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $AUDIO_LANGUAGE_NUMBER ]] ; then
    # If no file passed, default to null
    AUDIO_LANGUAGE=
fi



###### preset
if [[ $AUDIO_LANGUAGE_NUMBER = 1 ]] ; then
    AUDIO_LANGUAGE="-alang zh"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 2 ]] ; then
    AUDIO_LANGUAGE="-alang da"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 3 ]] ; then
    AUDIO_LANGUAGE="-alang de"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 4 ]] ; then
    AUDIO_LANGUAGE="-alang en"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 5 ]] ; then
    AUDIO_LANGUAGE="-alang es"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 6 ]] ; then
    AUDIO_LANGUAGE="-alang fr"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 7 ]] ; then
    AUDIO_LANGUAGE="-alang el"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 8 ]] ; then
    AUDIO_LANGUAGE="-alang it"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 9 ]] ; then
    AUDIO_LANGUAGE="-alang ja"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 10 ]] ; then
    AUDIO_LANGUAGE="-alang ko"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 11 ]] ; then
    AUDIO_LANGUAGE="-alang nl"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 12 ]] ; then
    AUDIO_LANGUAGE="-alang pl"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 13 ]] ; then
    AUDIO_LANGUAGE="-alang pt"
fi

if [[ $AUDIO_LANGUAGE_NUMBER = 14 ]] ; then
    AUDIO_LANGUAGE="-alang ru"
fi



##################################################
# Custom audio bitrate level			 #
##################################################

echo -n "Select an audio bitrate level:

(1) 48 kbps
(2) 64 kbps
(3) 128 kbps
(4) 160 kbps
(5) 192 kbps
(6) 224 kbps
(7) 256 kbps
(8) 320 kbps
(9) custom

Press 'Enter' for default (default is '3')...

"
read AUDIO_BITRATE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $AUDIO_BITRATE_NUMBER ]] ; then
    # If no file passed, default to 3
    AUDIO_BITRATE=128
fi



###### preset
if [[ $AUDIO_BITRATE_NUMBER = 1 ]] ; then
    AUDIO_BITRATE=48
fi

if [[ $AUDIO_BITRATE_NUMBER = 2 ]] ; then
    AUDIO_BITRATE=96
fi

if [[ $AUDIO_BITRATE_NUMBER = 3 ]] ; then
    AUDIO_BITRATE=128
fi

if [[ $AUDIO_BITRATE_NUMBER = 4 ]] ; then
    AUDIO_BITRATE=160
fi

if [[ $AUDIO_BITRATE_NUMBER = 5 ]] ; then
    AUDIO_BITRATE=192
fi

if [[ $AUDIO_BITRATE_NUMBER = 6 ]] ; then
    AUDIO_BITRATE=224
fi

if [[ $AUDIO_BITRATE_NUMBER = 7 ]] ; then
    AUDIO_BITRATE=256
fi

if [[ $AUDIO_BITRATE_NUMBER = 8 ]] ; then
    AUDIO_BITRATE=320
fi



###### custom
if [[ $AUDIO_BITRATE_NUMBER = 9 ]] ; then
    echo -n "Please enter a custom audio bitrate level:  "
    echo -n "...like this: '100'..."
    read CUSTOM_AUDIO_BITRATE
    AUDIO_BITRATE=$CUSTOM_AUDIO_BITRATE
fi



##################################################
# Custom audio bitrate type			 #
##################################################

echo -n "Select an audio bitrate type:

(1) Average Bitrate
(2) Constant Bitrate
(3) Variable Bitrate

Press 'Enter' for default (default is '1')...

"
read AUDIO_BITRATE_TYPE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $AUDIO_BITRATE_TYPE_NUMBER ]] ; then
    # If no file passed, default to abr
    AUDIO_BITRATE_TYPE=abr
fi



###### preset
if [[ $AUDIO_BITRATE_TYPE_NUMBER = 1 ]] ; then
    AUDIO_BITRATE_TYPE=abr
fi

if [[ $AUDIO_BITRATE_TYPE_NUMBER = 2 ]] ; then
    AUDIO_BITRATE_TYPE=cbr
fi

if [[ $AUDIO_BITRATE_TYPE_NUMBER = 3 ]] ; then
    AUDIO_BITRATE_TYPE=vbr
fi



##################################################
# Custom audio volume level			 #
##################################################

echo -n "Select an audio volume increase level (1-10):

Press 'Enter' for default (default is '3')...

"
read AUDIO_VOLUME_LEVEL



###### extra blank space
echo "
"



###### default
if [[ -z $AUDIO_VOLUME_LEVEL ]] ; then
    # If no file passed, default to 3
    AUDIO_VOLUME_LEVEL=3
fi



##################################################
# Subtitles?					 #
##################################################

echo -n "Do you want subtitles?:

(1) No
(2) Yes (DVD/ISO only)

Press 'Enter' for default (default is '1', for no subtitles)...

"
read SUBTITLE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $SUBTITLE_NUMBER ]] ; then
    # If no file passed, default to null
    SUBTITLE_TRACK=
    SUBTITLE_LANGUAGE=
    SUBTITLE_TYPE=
fi



###### preset
if [[ $SUBTITLE_NUMBER = 1 ]] ; then
    SUBTITLE_TRACK=
    SUBTITLE_LANGUAGE=
    SUBTITLE_TYPE=
fi

if [[ $SUBTITLE_NUMBER = 2 ]] ; then



##################################################
# Custom subtitle track				 #
##################################################

echo -n "Select a subtitle track:

(1) -sid 0
(2) -sid 1
(3) -sid 2
(4) -sid 3
(5) -sid 4
(6) -sid 5
(7) -sid 6
(8) -sid 7
(9) custom

Press 'Enter' for default (default is 'null')...

"
read SUBTITLE_TRACK_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $SUBTITLE_TRACK_NUMBER ]] ; then
    # If no file passed, default to null
    SUBTITLE_TRACK=
fi



###### preset
if [[ $SUBTITLE_TRACK_NUMBER = 1 ]] ; then
    SUBTITLE_TRACK="-sid 0"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 2 ]] ; then
    SUBTITLE_TRACK="-sid 1"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 3 ]] ; then
    SUBTITLE_TRACK="-sid 2"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 4 ]] ; then
    SUBTITLE_TRACK="-sid 3"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 5 ]] ; then
    SUBTITLE_TRACK="-sid 4"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 6 ]] ; then
    SUBTITLE_TRACK="-sid 5"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 7 ]] ; then
    SUBTITLE_TRACK="-sid 6"
fi

if [[ $SUBTITLE_TRACK_NUMBER = 8 ]] ; then
    SUBTITLE_TRACK="-sid 7"
fi



###### custom
if [[ $SUBTITLE_TRACK_NUMBER = 9 ]] ; then
    echo -n "Please enter a custom subtitles track:  "
    echo -n "...like this: '-sid 10'..."
    read CUSTOM_SUBTITLE_TRACK
    SUBTITLE_TRACK=$CUSTOM_SUBTITLE_TRACK
fi



##################################################
# Custom subtitles track language		 #
##################################################

echo -n "Select a subtitles track language:

(1)  Chinese - zh
(2)  Dansk (Danish) - da
(3)  Deutsch - de
(4)  English - en
(5)  Español - es
(6)  Français - fr
(7)  Greek - el
(8)  Italiano (Italian) - it
(9)  Japanese - ja
(10) Korean - ko
(11) Nederlands - nl
(12) Polish - pl
(13) Portugues - pt
(14) Russian - ru

Or input your own (like this: 'en')...

Press 'Enter' for default (default is 'null')...

"
read SUBTITLE_LANGUAGE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $SUBTITLE_LANGUAGE_NUMBER ]] ; then
    # If no file passed, default to null
    SUBTITLE_LANGUAGE=
fi



###### preset
if [[ $SUBTITLE_LANGUAGE_NUMBER = 1 ]] ; then
    SUBTITLE_LANGUAGE="-slang zh"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 2 ]] ; then
    SUBTITLE_LANGUAGE="-slang da"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 3 ]] ; then
    SUBTITLE_LANGUAGE="-slang de"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 4 ]] ; then
    SUBTITLE_LANGUAGE="-slang en"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 5 ]] ; then
    SUBTITLE_LANGUAGE="-slang es"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 6 ]] ; then
    SUBTITLE_LANGUAGE="-slang fr"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 7 ]] ; then
    SUBTITLE_LANGUAGE="-slang el"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 8 ]] ; then
    SUBTITLE_LANGUAGE="-slang it"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 9 ]] ; then
    SUBTITLE_LANGUAGE="-slang ja"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 10 ]] ; then
    SUBTITLE_LANGUAGE="-slang ko"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 11 ]] ; then
    SUBTITLE_LANGUAGE="-slang nl"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 12 ]] ; then
    SUBTITLE_LANGUAGE="-slang pl"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 13 ]] ; then
    SUBTITLE_LANGUAGE="-slang pt"
fi

if [[ $SUBTITLE_LANGUAGE_NUMBER = 14 ]] ; then
    SUBTITLE_LANGUAGE="-slang ru"
fi



##################################################
# Subtitle Kind?				 #
##################################################

echo -n "What kind of subtitles do you prefer?:

(1)  Embed onto the video
(2)  Embed into a separate file

Press 'Enter' for default (default is '1')...

"
read SUBTITLE_TYPE_NUMBER



###### extra blank space
echo "
"



###### default
if [[ -z $SUBTITLE_TYPE_NUMBER ]] ; then
    # If no file passed, default to null
    SUBTITLE_TYPE=
fi



###### preset
if [[ $SUBTITLE_TYPE_NUMBER = 1 ]] ; then
    SUBTITLE_TYPE=
fi

if [[ $SUBTITLE_TYPE_NUMBER = 2 ]] ; then
    SUBTITLE_TYPE="-vobsubout ${OUTPUT_FILE}"
fi



###### closes the preset of 'yes' for subtitles
fi



##################################################
# Custom conversion is starting			 #
##################################################

###### extra blank space
echo "
"



###### custom conversion is starting message
read -sn 1 -p "Your custom conversion is about to begin, press any key to continue..."



##################################################
# Custom conversions (very high quality settings)#
##################################################

###### custom preset ######

###### H.264
if [[ $MPEG4_TYPE = 1 ]] ; then
# actual two-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -nosound -ovc x264 -x264encopts pass=1:subq=1:partitions=all:8x8dct:me=umh:frameref=1:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=$BITRATE -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc x264 -x264encopts pass=2:subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=$BITRATE -vf pp=de,pullup,softskip,harddup,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $MPEG4_TYPE = 2 ]] ; then
# actual one-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc x264 -x264encopts subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=normal:weight_b:threads=auto:bitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### MPEG4
if [[ $MPEG4_TYPE = 3 ]] ; then
# actual two-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -nosound -ovc lavc $CUSTOM_DIVX -lavcopts vpass=1:vcodec=mpeg4:mbd=2:trell:v4mv:last_pred=2:dia=-1:vmax_b_frames=2:vb_strategy=1:cmp=3:subcmp=3:precmp=0:vqcomp=0.6:turbo:threads=$CPUS:vbitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc lavc $CUSTOM_DIVX -lavcopts vpass=2:vcodec=mpeg4:mbd=2:mv0:trell:v4mv:cbp:last_pred=3:predia=2:dia=2:vmax_b_frames=2:vb_strategy=1:precmp=2:cmp=2:subcmp=2:preme=2:qns=2:threads=$CPUS:vbitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $MPEG4_TYPE = 4 ]] ; then
# actual one-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc lavc $CUSTOM_DIVX -lavcopts vcodec=mpeg4:mbd=2:mv0:trell:v4mv:cbp:last_pred=3:predia=2:dia=2:vmax_b_frames=2:vb_strategy=1:precmp=2:cmp=2:subcmp=2:preme=2:qns=2:threads=$CPUS:vbitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi



###### XVID
if [[ $MPEG4_TYPE = 5 ]] ; then
# actual two-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -nosound -ovc xvid -xvidencopts pass=1:chroma_opt:vhq=1:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o '/dev/null'
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc xvid -xvidencopts pass=2:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi

if [[ $MPEG4_TYPE = 6 ]] ; then
# actual one-pass conversion
mencoder $INPUT_FILE $AUDIO_TRACK $AUDIO_LANGUAGE $SUBTITLE_TRACK $SUBTITLE_LANGUAGE $SUBTITLE_TYPE -oac mp3lame -lameopts $AUDIO_BITRATE_TYPE:br=$AUDIO_BITRATE:vol=$AUDIO_VOLUME_LEVEL -ovc xvid -xvidencopts chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=$CPUS:bitrate=$BITRATE -vf pp=de,pullup,softskip,crop=${CROP_VALUES},$SCALING $FRAME_RATE -o $OUTPUT_FILE.avi
fi



##################################################
# Close the custom quality option #17		 #
##################################################

fi








######################################################################################################################################################
###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP ###### CLEANUP
######################################################################################################################################################








if [ -f mplayer.tmp ];then
	rm mplayer.tmp
fi



if [ -f divx2pass.log ];then
	rm divx2pass.log
fi








######################################################################################################################################################
###### CONVERSION FINISHED ###### CONVERSION FINISHED ###### CONVERSION FINISHED ###### CONVERSION FINISHED ###### CONVERSION FINISHED ######
######################################################################################################################################################








##################################################
# Conversion finished notifications		 #
##################################################

###### extra blank spaces
echo "
"



###### notifications
notify-send -t 7000 -i /usr/share/icons/gnome/32x32/status/info.png "Conversion Finished" ; espeak "Conversion Finished"



# extra blank spaces
echo "
"



read -sn 1 -p "Your conversion has finished, press any key to continue and close this terminal session..."
