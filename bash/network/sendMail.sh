#!/bin/bash
# script to send simple email
#
FQDN=$(hostname -f)
# email subject
SUBJECT="SET-EMAIL-SUBJECT"
# Email To ?
EMAIL="admin@$FQDN"
# Email text/message
EMAILMESSAGE="/tmp/emailmessage.txt"
echo "This is an email message test"> $EMAILMESSAGE
echo "This is email text" >>$EMAILMESSAGE
# send an email using /bin/mail
/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
