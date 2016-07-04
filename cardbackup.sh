#!/bin/bash

# sudo apt-get update && sudo apt-get install rsync

# To run the script on boot:
# sudo chmod 755 cardbackup.sh
# crontab -e
# Add the following cronjob:
# @reboot sudo /path/to/cardbackup.sh
# Save the crontab file.

# Set the ACT LED to heartbeat, wenn das Script bereit ist.
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

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
mount /dev/$STORAGE_DEV $STORAGE_PATH

# Set the ACT LED to blink at 1000ms to indicate that the storage device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Wait for a card reader
DEVICE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
done

  # When the card reader is detected, mount it and obtain its UUID
  mount /dev/$CARD_DEV $CARD_PATH
  UUID=$(ls -l /dev/disk/by-uuid/ | grep $CARD_DEV | cut -d" " -f9)

  # Set the ACT LED to blink at 500ms to indicate that the card has been mounted
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"

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

# Turn off the ACT LED to indicate that the backup is completed
sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"

# Shutdown Raspberry Pi
shutdown -h now
