#!/bin/bash
#####
# Create backup on target directory and remove backups older then a month
# Usage as a Corn job:
#	30 18 * * *	create_backup.sh /opt/docs/ /backup my-docs 
#####
if [ $# -lt 3 ]
then
   echo "Usage: create_backup.sh dir/file_to_backup backup_destination backup_name"
   exit 1;
fi

TARGET_DIR=$1
BACKUP_DEST=$2
BACKUP_NAME=$3
DAT=`date +%d%b%Y` 

tar -z -c -f $BACKUP_DEST/$BACKUP_NAME-$DAT.tgz $TARGET_DIR
find $BACKUP_DEST/*.tgz -mtime +30 -exec rm {} \;
