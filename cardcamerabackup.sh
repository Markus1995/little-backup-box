#!/bin/bash

# sudo apt-get update && sudo apt-get install rsync gphoto2

# To run the script on boot:
# sudo chmod 755 cardcamerabackup.sh
# crontab -e
# Add the following cronjob:
# @reboot sudo /path/to/cardcamerabackup.sh
# Save the crontab file.

# If BlinkStick (https://www.blinkstick.com) is installed,
# light green to indicate that the script is ready
blinkstick --set-color=GREEN --brightness=50

# User-defined settings
CAMERA_SEARCH_STRING="USB" # Run the gphoto2 --auto-detect command. Use the first word of the camera maker's name.
STORAGE_DEV="sda1"
STORAGE_PATH="/media/storage" # Create this mount point if it doesn't exist
CAMERA_BACKUP_PATH=$STORAGE_PATH/$CAMERA_SEARCH_STRING
CARD_DEV="sdb1"
CARD_PATH="/media/card" # Create this mount point if it doesn't exist

# Don't edit below this line

# Wait for a USB storage device (e.g., a USB stick)
STORAGE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${STORAGE} ]
  do
  sleep 1
  STORAGE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

# When the USB storage device is detected, mount it
mount /dev/$STORAGE_DEV $STORAGE_PATH

# Light blue to indicate that the storage device has been mounted
blinkstick --set-color=BLUE --brightness=50

# Wait for a card reader or a camera
CARD_READER=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
CAMERA=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $CAMERA_SEARCH_STRING)
while [ -z $CARD_READER ] || [ -z $CAMERA ]
  do
  sleep 1
  CARD_READER=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
  CAMERA=$(gphoto2 --auto-detect | cut -d ' ' -f 1 | grep $CAMERA_SEARCH_STRING)
done

# If the card reader is detected, mount it and obtain its UUID
if [ ! -z $CARD_READER ]
  mount /dev/$CARD_DEV $CARD_PATH
  UUID=$(ls -l /dev/disk/by-uuid/ | grep $CARD_DEV | cut -d" " -f9)
  # Light yellow to indicate that the storage device has been mounted
  blinkstick --set-color=YELLOW --brightness=50
  # If UUID doesn't exist, read the id file on the card and use it as a directory name in the backup path
  # Otherwise use the UUID as a directory name in the backup path
  if [ -z $UUID ]; then
    read -r ID < $CARD_PATH/id
    BACKUP_PATH=$STORAGE_PATH/"$ID"
    else
    BACKUP_PATH=$STORAGE_PATH/$UUID
  fi
# Perform backup using rsync
rsync -avh $CARD_PATH/ $BACKUP_PATH
# Light orange to indicate that the backup is completed
blinkstick --set-color=ORANGE --brightness=50
fi

#If the camera is detected, transfer photos using gPhoto2
if [ ! -z $CAMERA ]
  if [ ! -d $CAMERA_BACKUP_PATH ]; then
    mkdir $CAMERA_BACKUP_PATH
  fi
cd $CAMERA_BACKUP_PATH
gphoto2 --get-all-files --skip-existing
# Light orange to indicate that the backup is completed
blinkstick --set-color=ORANGE --brightness=50
fi
# Shutdown Raspberry Pi
halt
