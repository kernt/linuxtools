#!/bin/bash
# source :  http://www.thegeekstuff.com/2009/04/linux-postgresql-install-and-configure-from-source/
#
#
#
#

wget http://wwwmaster.postgresql.org/redir/198/f/source/v8.3.7/postgresql-8.3.7.tar.gz
cd postgresql-8.3.7
./configure
make 
make install 

adduser postgres
passwd postgres

mkdir /usr/local/pgsql/data
chown postgres:postgres /usr/local/pgsql/data
ls -ld /usr/local/pgsql/data


#Initialize postgreSQL data directory

# su - postgres
# /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/

ls -l /usr/local/pgsql/data

# Start Postrgesql

/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &

# Loging
cat logfile

