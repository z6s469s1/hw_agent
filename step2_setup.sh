#!/bin/sh

if [ `id -u` -ne 0 ]; then
   echo "need root permission!"
   exit 1
fi


#ip forwarding
sudo sysctl -w net.ipv4.ip_forward=1

#dhcp setting
sudo apt install isc-dhcp-server -y

sudo rm /etc/dhcp/dhcpd.conf
sudo cp conf/dhcpd.conf /etc/dhcp/dhcpd.conf

sudo rm /etc/default/isc-dhcp-server
sudo cp conf/isc-dhcp-server  /etc/default/isc-dhcp-server

sudo systemctl restart isc-dhcp-server 
