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
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/cardandcamera.sh >> /home/pi/little-backup-box/cardandcamera.log"; } | crontab

sudo pip install blinkstick
sudo blinkstick --add-udev-rule

read -p "Connect your the camera and press [Enter]..."
CAMERA =$(gphoto2 --auto-detect | sed -n '3p' | cut -d ' ' -f 1)
sed -i s/'"USB"'/'"$CAMERA"'/ cardcamerabackup.sh
sed -i s/'"USB"'/'"$CAMERA"'/ camerabackup.sh

echo "All done! Run the crontab -e command, uncomment the desired cron job, and reboot."
