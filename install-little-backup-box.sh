#!/bin/bash

sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get install git-core rsync gphoto2 python-pip -y

sudo mkdir /media/card
sudo mkdir /media/storage

git clone https://github.com/dmpop/little-backup-box.git
cd little-backup-box
sudo chmod 755 *.sh
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/cardbackup.sh >> /home/pi/little-backup-box/cardbackup.log"; } | crontab -
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/camerabackup.sh >> /home/pi/little-backup-box/camerabackup.log"; } | crontab -
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/cardcamerabackup.sh >> /home/pi/little-backup-box/cardcamerabackup.log"; } | crontab

sudo pip install blinkstick
sudo blinkstick --add-udev-rule
