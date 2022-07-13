#!/bin/bash
# Backup storage directory 
backupfolder=/var/backups
# Number of days to store the backup 
keep_day=30
app_folder='/var/www'
zipfile=$backupfolder/app_folder-$(date +%d-%m-%Y_%H-%M-%S).zip
# Compress backup 
zip -r $zipfile $app_folder 
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed' 
else
  echo 'Error compressing backup' #| mailx -s 'Backup was not created!' $recipient_email 
  exit 
fi
# Delete old backups 
find $backupfolder -mtime +$keep_day -delete