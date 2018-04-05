#!/bin/bash

#The following command will take a backup of the crontab entries, 
#and pass the crontab entries as an input to sed command which will do the substituion. 
#After the substitution, it will be added as a new cron job.

crontab -l | tee crontab-backup.txt | sed 's/old/new/' | crontab –

