#!/bin/sh

if [ `id -u` -ne 0 ]; then
   echo "need root permission!"
   exit 1
fi

#requirement
#sudo apt-get upgrade
sudo apt-get update --allow-releaseinfo-change
sudo apt-get install gedit -y

#ip setting
sudo rm /etc/dhcpcd.conf
sudo cp conf/dhcpcd.conf /etc/dhcpcd.conf

sudo reboot
