
# get tmate from github
git clone https://github.com/nviennot/tmate

# 
apt-get install git-core build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev automake libssh-dev cmake ruby

# for local install use
## https://gist.github.com/ryin/3106801


# 
./autogen.sh
./configure
make         
make install


# source http://tmate.io/
