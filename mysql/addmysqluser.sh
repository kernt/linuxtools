# source
# http://dev.mysql.com/doc/refman/5.6/en/create-user.html
# http://bash.cyberciti.biz/mysql/add-database-username-password-remote-host-access/
# Script for add user to mysql Database.
# make sure we get at least 3 args, else die



db="$1"
user="$2"
pass="$3"
dbremotehost="$4"
dbrights="$5"
 
## Path to mysql bins ##
mysql="/usr/bin/mysql"
## Mysql root settings ##
madminuser='root'
madminpwd='MySQL-PassWord'
mhost='localhost'

[[ $# -le 2 ]] && { echo "Usage: $0 'DB_Name' 'DB_USER' 'DB_PASSORD' ['remote1|remote2|remoteN'] ['DB_RIGHTS']"; exit 1; }
 
# fallback to ALL rights
[[ -z "${dbrights}" ]] && dbrights="ALL"
 
# build mysql queries
_uamq="${mysql} -u "${madminuser}" -h "${mhost}" -p'${madminpwd}' -e 'CREATE DATABASE ${db};'"
_upermq1="${mysql} -u "${madminuser}" -h "${mhost}" -p'${madminpwd}' -e \"GRANT ${dbrights} ON ${db}.* TO ${user}@localhost IDENTIFIED BY '${pass}';\""
 
 
# run mysql queries
$_uamq
$_upermq1
 
 
# read remote host ip in a bash loop
# build queires to grant permission to all remote webserver or hosts via ip using the same username
IFS='|'
for i in ${dbremotehost}
do
_upermq2="${mysql} -u "${madminuser}" -h "${mhost}" -p'${madminpwd}' -e \"GRANT ${dbrights} ON ${db}.* TO ${user}@${i} IDENTIFIED BY '${pass}';\""
$_upermq2
done
