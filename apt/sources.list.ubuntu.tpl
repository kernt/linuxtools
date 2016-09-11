# Add ddebs repository
codename=$(lsb_release -sc)
repository="http://ddebs.ubuntu.com/" # just a example
listname="$repository" # extensible with 

sudo tee /etc/apt/sources.list.d/${listname}.list << EOF
deb  "$repository" ${codename} main restricted universe multiverse
deb  "$repository" ${codename}-security main restricted universe multiverse
deb  "$repository" ${codename}-updates main restricted universe multiverse
deb  "$repository" ${codename}-proposed main restricted universe multiverse
EOF

# add APT key if you need it
# the pre string from $repository can be dynamicly customised with regex like this:
# gpgkey=%%.*-key.asc
# gpgreleasekey= $(${repository}${gpgkey})
#wget -Nq "$repository"dbgsym-release-key.asc -O- | sudo apt-key add -
#apt-get update && apt-get install linux-image-$(uname -r)-dbgsym
