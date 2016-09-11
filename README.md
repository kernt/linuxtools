linuxtools
==========

Tools for usefull Systemadministration

Cloning a Debian system - identical packages and versions

I have long wished for the ability to install a Debian system specifying both the package list and 
the exact versions of the packages installed.

dpkg --get-selections | ssh newhost dpkg --set-selections 

is useful but always chooses the latest version, and especially when using testing or unstable, 
it is sometimes necessary to temporarily downgrade a package from the latest version available.
