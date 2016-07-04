#!/bin/bash

# sudo apt-get update && sudo apt-get install rsync

# Das Script beim starten ausführen:
# sudo chmod 755 cardbackup.sh
# crontab -e
# Den folgenden Cronjob hinzufügen
# @reboot sudo /path/to/cardbackup.sh
# Crontab Datei speichern

# ACT LED mit Heartbeat starten, wenn das Script bereit ist.
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

STORAGE_DEV="sda1"
STORAGE_PATH="/media/storage"
CARD_DEV="sdb1"
CARD_PATH="/media/card"

# Auf einen USB-Speicher warten (z.B. einen USB-Stick)
DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

# Wenn ein USB-Speicher erkannt wurde, diesen einbinden.
mount /dev/$STORAGE_DEV $STORAGE_PATH

# Wenn der USB-Speicher eingebunden wurde, die LED im 1000ms Takt blinken lassen.
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Auf Kartenleser warten.
DEVICE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
while [ -z ${DEVICE} ]
  do
  sleep 1
  DEVICE=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
done

  # Wenn der Kartenleser gefunden worden ist, einbinden und seine UUID erhalten
  mount /dev/$CARD_DEV $CARD_PATH
  UUID=$(ls -l /dev/disk/by-uuid/ | grep $CARD_DEV | cut -d" " -f9)

  # ACT LED in einem Takt von 500ms blinken lassen, wenn der Kartenleser eingebunden worden ist.
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"

# Wenn keine UUID vorhanden ist, die ID-Datei der Speicherkarte lesen und diese als Verzeichnissname hernehmen.
# Ansosten wird die UUID als Verzeichnissname hergenommen.
if [ -z $UUID ]; then
  read -r ID < $CARD_PATH/id
  BACKUP_PATH=$STORAGE_PATH/"$ID"
else
  BACKUP_PATH=$STORAGE_PATH/$UUID
fi

# Backup mit Rsync durchführen.
rsync -avh $CARD_PATH/ $BACKUP_PATH

# ACT LED ausschalten, wenn das Backup fertig ist.
sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"

# Raspberry Pi herunterfahren.
shutdown -h now
