#!/bin/bash

apt-get update && apt-get dist-upgrade -y && apt-get install git-core rsync gphoto2 python-pip -y

mkdir /media/card
mkdir /media/storage

git clone https://github.com/dmpop/little-backup-box.git
cd little-backup-box
chmod 755 *.sh
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/cardbackup.sh >> /home/pi/little-backup-box/cardbackup.log"; } | crontab -
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/camerabackup.sh >> /home/pi/little-backup-box/camerabackup.log"; } | crontab -
crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/cardcamerabackup.sh >> /home/pi/little-backup-box/cardcamerabackup.log"; } | crontab

pip install blinkstick
blinkstick --add-udev-rule

read -p "Connect your the camera and press [Enter]..."
CAMERA =$(gphoto2 --auto-detect | sed -n '3p' | cut -d ' ' -f 1)
sed -i s/'"USB"'/'"$CAMERA"'/ cardcamerabackup.sh
sed -i s/'"USB"'/'"$CAMERA"'/ camerabackup.sh

echo "All done! Run the crontab -e command, uncomment the desired cron job, and reboot."
