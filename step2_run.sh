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



#iptables

#SNAT
sudo iptables -t nat -A POSTROUTING -s 192.168.2.10 -d 0.0.0.0/0 -o eth0 -j MASQUERADE

#DNAT, Rpi 8080 forward to FPGA 8080
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.2.10:8080

#Drop all packets
sudo iptables -t filter -A INPUT -s 0.0.0.0/0  -d 0.0.0.0/0  -j DROP
sudo iptables -t filter -A OUTPUT -s 0.0.0.0/0  -d 0.0.0.0/0  -j DROP
sudo iptables -t filter -A FORWARD -s 0.0.0.0/0  -d 0.0.0.0/0 -j DROP


#Allow localhost 
sudo iptables -t filter -I INPUT -s 127.0.0.1  -j ACCEPT
sudo iptables -t filter -I OUTPUT -d 127.0.0.1  -j ACCEPT

#Allow 8.8.8.8 for Rpi
sudo iptables -t filter -I INPUT -s 8.8.8.8  -j ACCEPT
sudo iptables -t filter -I OUTPUT -d 8.8.8.8  -j ACCEPT

#Allow 8.8.8.8 for FPGA
sudo iptables -t filter -I FORWARD -s 8.8.8.8  -j ACCEPT
sudo iptables -t filter -I FORWARD -d 8.8.8.8  -j ACCEPT

#Allow 8080 port for FPGA
sudo iptables -t filter -I FORWARD -p tcp --sport 8080 -s 192.168.2.10  -j ACCEPT
sudo iptables -t filter -I FORWARD -p tcp --dport 8080 -d 192.168.2.10  -j ACCEPT

