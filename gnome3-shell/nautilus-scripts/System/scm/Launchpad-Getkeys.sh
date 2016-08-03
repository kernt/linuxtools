#! /bin/bash
if [ "`whoami`" != "root" ];
then
echo "Please run with SUDO"
exit 1
fi

function HELP ()
{
echo "

launchpad-getkeys is an utility to automatically import all
Lunchpad PPAs missing GPG keys.

Usage:
* use without any parameter to automatically import all the missing
GPG keys
* -k SERVER:PORT will pass a new keyserver, in case the default
keyserver is down
* -p http://PROXY:PORT lets you specify a proxy-server other than the default one.
"
exit 0
}

while getopts "k:p:h\?" opt; do
	case "$opt" in
		k ) KEYSERVER="$OPTARG"			;;
		p ) PROXY="$OPTARG"			;;
		h ) HELP				;;
		\?) HELP				;;
		* ) warn "Unknown option '$opt'";	;;
	esac
done
shift $(($OPTIND -1))

if [[ $KEYSERVER ]]; then

	KEYSERVERANDPORT=$(echo $KEYSERVER | grep ":")
		if [[ ! $KEYSERVERANDPORT ]]; then
		echo "Error: please enter a keyserver and a port, like so: sudo launchpad-getkeys -k http://SERVER:PORT"
		exit 0
	fi
fi

if [[ $PROXY ]]; then

	PROXYSERVERANDPORT=$(echo $PROXY | grep ":")
		if [[ ! $PROXYSERVERANDPORT ]]; then
		echo "Error: please enter a proxyserver and a port, like so: sudo launchpad-getkeys -p PROXYSERVER:PORT (without http://)"
		exit 0
	fi
fi

if [[ ! $PROXY ]]; then
	PROXY=$http_proxy	
fi

echo "
Please wait... launchpad-getkeys is running an update so 
it can detect the missing GPG keys"
apt-get update -qq 2> /tmp/updateresults


MISSINGGEYS=$(cat /tmp/updateresults)

if [[ $MISSINGGEYS ]]; then

echo "
Trying to import all the missing keys"

	IFS=$'\n'
	n=1
	while read curline; do
		GPGKEYTOGET=$(echo $curline | grep NO_PUBKEY | sed -e 's/.*: \|NO_PUBKEY //g')
		if [[ $KEYSERVER ]]; then
			gpg --ignore-time-conflict --no-options --no-default-keyring --secret-keyring /etc/apt/secring.gpg --trustdb-name /etc/apt/trustdb.gpg --keyring /etc/apt/trusted.gpg --primary-keyring /etc/apt/trusted.gpg --keyserver hkp://$KEYSERVER --keyserver-options http-proxy=$PROXY --recv $GPGKEYTOGET
		else
			gpg --ignore-time-conflict --no-options --no-default-keyring --secret-keyring /etc/apt/secring.gpg --trustdb-name /etc/apt/trustdb.gpg --keyring /etc/apt/trusted.gpg --primary-keyring /etc/apt/trusted.gpg --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy=$PROXY --recv $GPGKEYTOGET
		fi
		let n=n+1
	done < /tmp/updateresults

	echo "
launchpad-getkeys has finished importing all missing GPG keys. 
Try running "sudo apt-get update" - you shouldn't see any key 
errors anymore"
else
	echo "
There are no missing GPG keys!"
fi

rm /tmp/updateresults
