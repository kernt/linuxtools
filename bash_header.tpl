#!/usr/bin/env bash
# Sources:   http://www.gmarik.info/blog/2016/5-tips-for-solid-bash-code/
#            https://natelandau.com/boilerplate-shell-script-template/
#            https://github.com/natelandau/shell-scripts
#            
# Script-Name	: myscriptz.sh
# Version	    : 0.01
# Autor		     : Tobias Kern
# Datum		     : $(date)
# Lizenz	     : GPLv3
# Depends     : 
# Use         : 
# 
# Example: 
#
# Description:
#         
###########################################################################################
##################              Semantic Versioning              ##########################
###########################################################################################
# Source : http://semver.org/
MAJOR = 0
MINOR = 1
PATCH = 0

VERSION = $MAJOR.$MINOR.$PATCH
###########################################################################################
#################                Default Functions                         ################
###########################################################################################
#
# readFile
# ------------------------------------------------------
# Function to read a line from a file.
#
# Most often used to read the config files saved in my etc directory.
# Outputs each line in a variable named $result
# ------------------------------------------------------
function readFile() {
  unset "${result}"
  while read result
  do
    echo "${result}"
  done < "$1"
}

# needSudo
# ------------------------------------------------------
# If a script needs sudo access, call this function which
# requests sudo access and then keeps it alive.
# ------------------------------------------------------
function needSudo() {
  # Update existing sudo time stamp if set, otherwise do nothing.
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

# Print Date
print_date() {
  echo "today is $(date)"
}

# File Checks
# ------------------------------------------------------
# A series of functions which make checks against the filesystem. For
# use in if/then statements.
#
# Usage:
#    if is_file "file"; then
#       ...
#    fi
# ------------------------------------------------------

function is_exists() {
  if [[ -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_exists() {
  if [[ ! -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_file() {
  if [[ -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_file() {
  if [[ ! -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_dir() {
  if [[ -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_dir() {
  if [[ ! -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_symlink() {
  if [[ -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_symlink() {
  if [[ ! -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_empty() {
  if [[ -z "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_empty() {
  if [[ -n "$1" ]]; then
    return 0
  fi
  return 1
}


# set productiv environment
env_prod() {
  local NAME=${NAME?"Required"}
  # sets fail early flag
  set -e
}

# set test environment
env_test() {
  # enable debugging output
  set -x
}

# Test which OS the user runs
# $1 = OS to test
# Usage: if is_os 'darwin'; then

function is_os() {
  if [[ "${OSTYPE}" == $1* ]]; then
    return 0
  fi
  return 1
}

# Text Transformations
# -----------------------------------
# Transform text using these functions.
# Adapted from https://github.com/jmcantrell/bashful
# -----------------------------------

lower() {
  # Convert stdin to lowercase.
  # usage:  text=$(lower <<<"$1")
  #         echo "MAKETHISLOWERCASE" | lower
  tr '[:upper:]' '[:lower:]'
}

upper() {
  # Convert stdin to uppercase.
  # usage:  text=$(upper <<<"$1")
  #         echo "MAKETHISUPPERCASE" | upper
  tr '[:lower:]' '[:upper:]'
}

ltrim() {
  # Removes all leading whitespace (from the left).
  local char=${1:-[:space:]}
    sed "s%^[${char//%/\\%}]*%%"
}

rtrim() {
  # Removes all trailing whitespace (from the right).
  local char=${1:-[:space:]}
  sed "s%[${char//%/\\%}]*$%%"
}

trim() {
  # Removes all leading/trailing whitespace
  # Usage examples:
  #     echo "  foo  bar baz " | trim  #==> "foo  bar baz"
  ltrim "$1" | rtrim "$1"
}

squeeze() {
  # Removes leading/trailing whitespace and condenses all other consecutive
  # whitespace into a single space.
  #
  # Usage examples:
  #     echo "  foo  bar   baz  " | squeeze  #==> "foo bar baz"

  local char=${1:-[[:space:]]}
  sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"
}

squeeze_lines() {
    # <doc:squeeze_lines> {{{
    #
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.
    #
    # </doc:squeeze_lines> }}}

    sed '/^[[:space:]]\+$/s/.*//g' | cat -s | trim_lines
}

progressBar() {
  # progressBar
  # -----------------------------------
  # Prints a progress bar within a for/while loop.
  # To use this function you must pass the total number of
  # times the loop will run to the function.
  #
  # usage:
  #   for number in $(seq 0 100); do
  #     sleep 1
  #     progressBar 100
  #   done
  # -----------------------------------
  if [[ "${quiet}" = "true" ]] || [ "${quiet}" == "1" ]; then
    return
  fi

  local width
  width=30
  bar_char="#"

  # Don't run this function when scripts are running in verbose mode
  if ${verbose}; then return; fi

  # Reset the count
  if [ -z "${progressBarProgress}" ]; then
    progressBarProgress=0
  fi

  # Do nothing if the output is not a terminal
  if [ ! -t 1 ]; then
      echo "Output is not a terminal" 1>&2
      return
  fi
  # Hide the cursor
    tput civis
    trap 'tput cnorm; exit 1' SIGINT

  if [ ! "${progressBarProgress}" -eq $(( $1 - 1 )) ]; then
    # Compute the percentage.
    perc=$(( progressBarProgress * 100 / $1 ))
    # Compute the number of blocks to represent the percentage.
    num=$(( progressBarProgress * width / $1 ))
    # Create the progress bar string.
    bar=
    if [ ${num} -gt 0 ]; then
        bar=$(printf "%0.s${bar_char}" $(seq 1 ${num}))
    fi
    # Print the progress bar.
    progressBarLine=$(printf "%s [%-${width}s] (%d%%)" "Running Process" "${bar}" "${perc}")
    echo -en "${progressBarLine}\r"
    progressBarProgress=$(( progressBarProgress + 1 ))
  else
    # Clear the progress bar when complete
    echo -ne "${width}%\033[0K\r"
    unset progressBarProgress
  fi

  tput cnorm
}


################################################################################################
############                            ERROR Codes                          ###################
################################################################################################
# Name of your script.
SCRIPTNAME=$(basename $0.sh)
# exit code without any error
EXIT_SUCCESS=0
# exit code I/O failure
EXIT_FAILURE=1
# exit code error if known
EXIT_ERROR=2
# unknown ERROR 
EXIT_BUG=10
#################################################################################################
##########                     working with getopts                             #################
#################################################################################################
file= verbose= quiet= long=

while getopts  :f:vql opt
do
	case $opt in
	f)	file=$OPTARG
		;;
	v)	verbose=true
		quit=
		;;
	q)	quiet=true
		verbose=
		;;
	l)	long=true
		;;
	'?')	echo $0: $1: unrecognized option -$OPTARG >&2
		echo "Usage: $0 [-f file] [-vql] [files ...]" >&2
		exit 1
		;;
	esac
done

######################################################################################################
##############      Bash environment variables                                    ####################
######################################################################################################
# Posision from function to script
POSTOFONCA="*"

# Posision from function to script
POSTOFONCONCE="@"

# Options by execute bash
BACHEXECOP="-"

# Exit state from last command
STATELASTCOMMAND="?"

# Variable for optionsswitch
#OPTFILE=""
fbname=$(basename "$1".txt)

# SCRIPTNAME
# ------------------------------------------------------
# Will return the name of the script being run
# ------------------------------------------------------
scriptName=`basename $0` #Set Script Name variable
scriptBasename="$(basename ${scriptName} .sh)" # Strips '.sh' from scriptName

# TIMESTAMPS
# ------------------------------------------------------
# Prints the current date and time in a variety of formats:
#
# ------------------------------------------------------
now=$(LC_ALL=C date +"%m-%d-%Y %r")        # Returns: 06-14-2015 10:34:40 PM
datestamp=$(LC_ALL=C date +%Y-%m-%d)       # Returns: 2015-06-14
hourstamp=$(LC_ALL=C date +%r)             # Returns: 10:34:40 PM
timestamp=$(LC_ALL=C date +%Y%m%d_%H%M%S)  # Returns: 20150614_223440
today=$(LC_ALL=C date +"%m-%d-%Y")         # Returns: 06-14-2015
longdate=$(LC_ALL=C date +"%a, %d %b %Y %H:%M:%S %z")  # Returns: Sun, 10 Jan 2016 20:47:53 -0500
gmtdate=$(LC_ALL=C date -u -R | sed 's/\+0000/GMT/') # Returns: Wed, 13 Jan 2016 15:55:29 GMT

# THISHOST
# ------------------------------------------------------
# Will print the current hostname of the computer the script
# is being run on.
# ------------------------------------------------------
thisHost=$(hostname)

parse_yaml() {
  # Function to parse YAML files and add values to variables. Send it to a temp file and source it
  # https://gist.github.com/DinoChiesa/3e3c3866b51290f31243 which is derived from
  # https://gist.github.com/epiloque/8cf512c6d64641bde388
  #
  # Usage:
  #     $ parse_yaml sample.yml > /some/tempfile
  #
  # parse_yaml accepts a prefix argument so that imported settings all have a common prefix
  # (which will reduce the risk of name-space collisions).
  #
  #     $ parse_yaml sample.yml "CONF_"

    local prefix=$2
    local s
    local w
    local fs
    s='[[:space:]]*'
    w='[a-zA-Z0-9_]*'
    fs="$(echo @|tr @ '\034')"
    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
    awk -F"$fs" '{
      indent = length($1)/2;
      if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
              vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
              printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
      }
    }' | sed 's/_=/+=/g'
}

function json2yaml() {
  # convert json files to yaml using python and PyYAML
  python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < "$1"
}

function yaml2json() {
  # convert yaml files to json using python and PyYAML
  python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < "$1"
}



###########################################################################################################
##########                       MyScript                                     #############################
###########################################################################################################

main() {
  print_date
  env_prod
  
}
