#!/bin/bash
# Backup storage directory 
backupfolder=/var/backups
# Notification email address 
recipient_email=username@mail.com
# MySQL user
user=dev
# MySQL password
password=dev123
# MySQL database
dbName=engloset_final_db
# Number of days to store the backup 
keep_day=30
sqlfile=$backupfolder/$dbName-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/$dbName-$(date +%d-%m-%Y_%H-%M-%S).zip
# Create a backup 
mysqldump --routines -R --triggers --events -u $user -p$password $dbName > $sqlfile 
if [ $? == 0 ]; then
  echo 'Sql dump created' 
else
  echo 'mysqldump return non-zero code' #| mailx -s 'No backup was created!' $recipient_email  
  exit 
fi
# Compress backup 
zip $zipfile $sqlfile 
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed' 
else
  echo 'Error compressing backup' #| mailx -s 'Backup was not created!' $recipient_email 
  exit 
fi
rm $sqlfile 
# Delete old backups 
find $backupfolder -mtime +$keep_day -delete