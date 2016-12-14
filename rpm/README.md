RPM Versionslocking and  Pinning
--------------------------------

Sources: 
* https://scottlinux.com/2013/03/18/red-hat-6-or-centos-6-yum-tips-lock-package-versions-and-only-apply-security-updates/
* https://www.cyberciti.biz/faq/centos-redhat-fedora-yum-lock-package-version-command/
* https://access.redhat.com/solutions/98873
* http://yum.baseurl.org/wiki/Faq

Requirements

`sudo yum install yum-plugin-versionlock`


Example for version logging :
`sudo yum versionlock add ${APP}`
