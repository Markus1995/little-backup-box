#!/bin/bash

sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get install git-core rsync gphoto2 python-pip -y

sudo mkdir /media/sdcard
sudo mkdir /media/storage

git clone https://github.com/dmpop/little-backup-box.git
cd little-backup-box
sudo chmod 755 cardbackup.sh
sudo chmod 755 camerabackup.sh
crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/cardbackup.sh"; } | crontab -
crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/camerabackup.sh"; } | crontab -

sudo pip install blinkstick
sudo blinkstick --add-udev-rule
