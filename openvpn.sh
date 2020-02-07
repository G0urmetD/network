#!/bin/bash

apt update
apt install openvpn -y

echo "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto enp0s3" >> /etc/network/interfaces
echo "iface enp0s3 inet static" >> /etc/network/interfaces
echo "address 10.16.203.223" >> /etc/network/interfaces
echo "netmask 255.0.0.0" >> /etc/network/interfaces
echo "gateway 10.16.1.245" >> /etc/network/interfaces

echo "nameserver 10.16.1.253" > /etc/resolv.conf

systemctl restart networking
