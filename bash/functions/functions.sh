# usage: reverse arrayname
reverse()
{
	local -a R
	local -i i
	local rlen temp

	# make r a copy of the array whose name is passed as an arg
	eval R=\( \"\$\{$1\[@\]\}\" \)

	# reverse R
	rlen=${#R[@]}

	for ((i=0; i < rlen/2; i++ ))
	do
		temp=${R[i]}
		R[i]=${R[rlen-i-1]}
		R[rlen-i-1]=$temp
	done

	# and assign R back to array whose name is passed as an arg
	eval $1=\( \"\$\{R\[@\]\}\" \)
}

A=(1 2 3 4 5 6 7)
echo "${A[@]}"
reverse A
echo "${A[@]}"
reverse A
echo "${A[@]}"

# unset last element of A
alen=${#A[@]}
unset A[$alen-1]
echo "${A[@]}"

# ashift -- like shift, but for arrays

ashift()
{
	local -a R
	local n

	case $# in
	1)	n=1 ;;
	2)	n=$2 ;;
	*)	echo "$FUNCNAME: usage: $FUNCNAME array [count]" >&2
		exit 2;;
	esac

	# make r a copy of the array whose name is passed as an arg
	eval R=\( \"\$\{$1\[@\]\}\" \)

	# shift R
	R=( "${R[@]:$n}" )

	# and assign R back to array whose name is passed as an arg
	eval $1=\( \"\$\{R\[@\]\}\" \)
}

ashift A 2
echo "${A[@]}"

ashift A
echo "${A[@]}"

ashift A 7
echo "${A[@]}"

# Sort the members of the array whose name is passed as the first non-option
# arg.  If -u is the first arg, remove duplicate array members.
array_sort()
{
	local -a R
	local u

	case "$1" in
	-u)	u=-u ; shift ;;
	esac

	if [ $# -eq 0 ]; then
		echo "array_sort: argument expected" >&2
		return 1
	fi

	# make r a copy of the array whose name is passed as an arg
	eval R=\( \"\$\{$1\[@\]\}\" \)

	# sort R
	R=( $( printf "%s\n" "${A[@]}" | sort $u) )

	# and assign R back to array whose name is passed as an arg
	eval $1=\( \"\$\{R\[@\]\}\" \)
	return 0
}

A=(3 1 4 1 5 9 2 6 5 3 2)
array_sort A
echo "${A[@]}"

A=(3 1 4 1 5 9 2 6 5 3 2)
array_sort -u A
echo "${A[@]}"

#####################################################################################
function basename ()
{
 local path="$1"
 local suffix="$2"
 local tpath="${path%/}"

    # Strip trailing '/' characters from path (unusual that this should
    # ever occur, but basename(1) seems to deal with it.)
    while [ "${tpath}" != "${path}" ]; do
       tpath="${path}"
       path="${tpath%/}"
    done

    path="${path##*/}"       # Strip off pathname
    echo ${path%${suffix}}   # Also strip off extension, if any.
}
#####################################################################################
# mkdir if it doesn't exist
testmkdir () {
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
}
# Copy a file if the destination doesn't exist
testcp () {
	if [ ! -e $2 ]; then
		cp $1 $2
	fi
}


detect_ip () {
	#primaryaddr=`/sbin/ifconfig eth0|grep 'inet addr'|cut -d: -f2|cut -d" " -f1`
        primaryaddr=`/sbin/ip -f inet -o -d addr show dev \`/sbin/ip ro ls | grep default | awk '{print $5}'\` | head -1 | awk '{print $4}' | cut -d"/" -f1`
	if [ $primaryaddr ]; then
		logger_info "Primary address detected as $primaryaddr"
		address=$primaryaddr
		return 0
	else
		logger_info "Unable to determine IP address of primary interface."
		echo "Please enter the name of your primary network interface: "
		read primaryinterface
		#primaryaddr=`/sbin/ifconfig $primaryinterface|grep 'inet addr'|cut -d: -f2|cut -d" " -f1`
                primaryaddr=`/sbin/ip -f inet -o -d addr show dev $primaryinterface | head -1 | awk '{print $4}' | cut -d"/" -f1`
		if [ "$primaryaddr" = "" ]; then
			# Try again with FreeBSD format
			primaryaddr=`/sbin/ifconfig $primaryinterface|grep 'inet' | awk '{ print $2 }'`
		fi
		if [ $primaryaddr ]; then
			logger_info "Primary address detected as $primaryaddr"
			address=$primaryaddr
		else
			fatal "Unable to determine IP address of selected interface.  Cannot continue."
		fi
		return 0
	fi
}

set_hostname () {
	i=0
	while [ $i -eq 0 ]; do
		if [ "$forcehostname" = "" ]; then
			printf "Please enter a fully qualified hostname (for example, host.example.com): "
			read line
		else
			logger_info "Setting hostname to $forcehostname"
			line=$forcehostname
		fi
		if ! is_fully_qualified $line; then
			logger_info "Hostname $line is not fully qualified."
		else
			hostname $line
			detect_ip
			if grep $address /etc/hosts; then
				logger_info "Entry for IP $address exists in /etc/hosts."
				logger_info "Updating with new hostname."
				shortname=`echo $line | cut -d"." -f1`
				sed -i "s/^$address\([\s\t]+\).*$/$address\1$line\t$shortname/" /etc/hosts
			else
				logger_info "Adding new entry for hostname $line on $address to /etc/hosts."
				printf "$address\t$line\t$shortname\n" >> /etc/hosts
			fi
		i=1
	fi
	done
}

is_fully_qualified () {
	case $1 in
		localhost.localdomain)
			logger_info "Hostname cannot be localhost.localdomain."
			return 1
		;;
		*.localdomain)
			logger_info "Hostname cannot be *.localdomain."
			return 1
		;;
		*.*)
			logger_info "Hostname OK: fully qualified as $1"
			return 0
		;;
	esac
	logger_info "Hostname $name is not fully qualified."
	return 1
}

# download()
# Use $download to download the provided filename or exit with an error.
download() {
	if $download $1
	then
		success "Download of $1"
   	return $?
	else
		fatal "Failed to download $1."
	fi
}

# Functions that are used in the OS specific modifications section
disable_selinux () {
	seconfigfiles="/etc/selinux/config /etc/sysconfig/selinux"
	for i in $seconfigfiles; do
		if [ -e $i ]; then
			sed -i "s/SELINUX=.*/SELINUX=disabled/" $i
		fi
	done
}

