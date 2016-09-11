#http://www.commandlinefu.com/commands/view/979/backup-a-remote-database-to-your-local-filesystem
ssh user@host 'mysqldump dbname | gzip' > /path/to/backups/db-backup-`date +%Y-%m-%d`.sql.gz

#Backup a remote database to your local filesystem
#I have this on a daily cronjob to backup the commandlinefu.com database from NearlyFreeSpeech.net (awesome hosts by the way) to my local drive. Note that (on my Ubuntu system at least) you need to escape the % signs on the crontab.

#Export MySQL query as .csv file
echo "SELECT * FROM table; " | mysql -u root -p${MYSQLROOTPW} databasename | sed 's/\t/","/g;s/^/"/;s/$/"/;s/\n//g' > outfile.csv

#Export MySQL query as .csv file
#This command converts a MySQL query directly into a .csv (Comma Seperated Value)-file.

ssh -CNL 3306:localhost:3306 user@site.com
#Create an SSH tunnel for accessing your remote MySQL database with a local port 

(pv -n ~/database.sql | mysql -u root -pPASSWORD -D database_name) 2>&1 | zenity --width 550 --progress --auto-close --auto-kill --title "Importing into MySQL" --text "Importing into the database"
 Import SQL into MySQL with a progress meter

#This uses PV to monitor the progress of the MySQL import and displays it though Zenity. You could also do this
#pv ~/database.sql | mysql -u root -pPASSWORD -D database_name
#and get a display in the CLI that looks like this
#2.19MB 0:00:06 [ 160kB/s] [> ] 5% ETA 0:01:40
#My Nautalus script using this command is here
#http://www.daniweb.com/forums/post1253285.html#post1253285
