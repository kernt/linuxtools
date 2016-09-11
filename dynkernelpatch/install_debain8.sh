#/bin/bash
# Source: https://github.com/dynup/kpatch
#
echo "NOTE: You'll need about 15GB of free disk space for the kpatch-build cache in ~/.kpatch and for ccache."
echo "Install the dependencies for compiling kpatch:"
sleep 3

apt-get install make gcc libelf-dev build-essential

echo "Install and prepare the kernel sources:"

apt-get install linux-source-$(uname -r)
cd /usr/src && tar xvf linux-source-$(uname -r).tar.xz && ln -s linux-source-$(uname -r) linux && cd linux
cp /boot/config-$(uname -r) .config
for OPTION in CONFIG_KALLSYMS_ALL CONFIG_FUNCTION_TRACER ; do sed -i "s/# $OPTION is not set/$OPTION=y/g" .config ; done
sed -i "s/^SUBLEVEL.*/SUBLEVEL =/" Makefile
make -j`getconf _NPROCESSORS_CONF` deb-pkg KDEB_PKGVERSION=$(uname -r).9-1

echo "Install the kernel packages and reboot"
dpkg -i /usr/src/*.deb
reboot

echo "Install the dependencies for the "kpatch-build" command:"
apt-get install dpkg-dev
apt-get build-dep linux

echo " Install ccache optional, but highly recommended"
apt-get install ccache
ccache --max-size=5G

exit 0
