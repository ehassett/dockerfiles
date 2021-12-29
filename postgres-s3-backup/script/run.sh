#!/bin/bash

set -e

# Set variables
BACKUP_SCRIPT=/app/backup.sh

# Configure signature version
if [ "${AWS_S3_S3V4}" = "yes" ]; then
  aws configure set default.s3.signature_version s3v4
fi

# Check and set schedule
case $BACKUP_SCHEDULE in
  once)
    bash $BACKUP_SCRIPT
    exit 0
    ;;
    
  15min)
    WAIT_TIME=900
    ;;

  hourly)
    WAIT_TIME=3600
    ;;
    
  daily)
    WAIT_TIME=86400
    ;;
    
  weekly)
    WAIT_TIME=604800
    ;;
  
  *)
    echo "Unsupported backup schedule, use one of: once, 15min, hourly, daily, weekly"
    exit 1
    ;;
esac

while true
do
  bash $BACKUP_SCRIPT
  echo "Sleeping..."
  sleep $WAIT_TIME
done
