#!/bin/bash

# sudo apt-get update && sudo apt-get install gphoto2

# To run the script on boot:
# sudo chmod 755 camerabackup.sh
# crontab -e
# Add the following cronjob:
# @reboot sudo /home/pi/camerabackup.sh
# Save the crontab file.

MODEL="USB"
STORAGE_DEV="sda1"
BACKUP_PATH="/media/storage/"$MODEL

DEVICE=$(sudo ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(sudo ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

sudo mount /dev/$STORAGE_DEV -t ext2 $STORAGE_PATH

DEVICE=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $MODEL)
while [ -z ${DEVICE} ]
	do
	sleep 1
	DEVICE=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $MODEL)
done

mkdir $BACKUP_PATH && cd $_
gphoto2 --get-all-files --skip-existing

sudo halt
