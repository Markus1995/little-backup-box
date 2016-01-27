#!/bin/bash

# sudo apt-get update && sudo apt-get install gphoto2

# To run the script on boot:
# sudo chmod 755 camerabackup.sh
# crontab -e
# Add the following cronjob:
# @reboot sudo /path/to/camerabackup.sh
# Save the crontab file.

CAMERA="USB"
STORAGE_DEV="sda1"
STORAGE_PATH="/media/storage/"
BACKUP_PATH="/media/storage/"$CAMERA

DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

mount /dev/$STORAGE_DEV $STORAGE_PATH

DEVICE=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $CAMERA)
while [ -z ${DEVICE} ]
	do
	sleep 1
	DEVICE=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $CAMERA)
done
if [ ! -d $BACKUP_PATH ]; then
  mkdir $BACKUP_PATH
fi
cd $BACKUP_PATH
gphoto2 --get-all-files --skip-existing
halt
