#!/bin/bash

# sudo apt-get update && sudo apt-get install rsync

# To run the script on boot:
# sudo chmod 755 cardbackup.sh
# crontab -e
# Add the following cronjob:
# @reboot sudo /path/to/sdcardbackup.sh
# Save the crontab file.

# If BlinkStick (https://www.blinkstick.com) is installed,
# Blink green to indicate that the script is ready.
blinkstick --repeats 3 --blink green

STORAGE_DEV="sda1"
STORAGE_PATH="/media/storage"
CARD_DEV="sdb1"
CARD_PATH="/media/card"

# Wait for a USB storage device (e.g., a USB stick)
DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

# When the USB storage device is detected, mount it
mount /dev/$STORAGE_DEV -t ext2 $STORAGE_PATH

# Blink blue to indicate that the storage device has been mounted
blinkstick --repeats 3 --blink blue

# Wait for a card reader
DEVICE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
done

# When the card reader is detected, mount it and obtain its UUID
mount /dev/$CARD_DEV -t vfat $CARD_PATH
UUID=$(ls -l /dev/disk/by-uuid/ | grep $CARD_DEV | cut -d" " -f9)

# Blink yellow to indicate that the storage device has been mounted
blinkstick --repeats 3 --blink yellow

# If UUID doesn't exist, read the id file on the card and use it as a directory name in the backup path
# Otherwise use the UUID as a directory name in the backup path
if [ -z $UUID ]; then
  read -r ID < $CARD_PATH/id
  BACKUP_PATH=$STORAGE_PATH/$ID
else
  BACKUP_PATH=$STORAGE_PATH/$UUID
fi

# Perform backup using rsync
rsync -avh $CARD_PATH/ $BACKUP_PATH

# Blink magenta to indicate that the backup is completed
blinkstick --repeats 3 --blink magenta

# Shutdown Raspberry Pi
halt
