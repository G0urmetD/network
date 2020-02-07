#!/bin/bash

echo "client" > /etc/hostname

apt update

cd /etc/openvpn/ 
rm -r server.crt
rm -r server.key
rm -r server.conf
rm -r dh.pem
rm -r server

cp /root/my_ca/pki/issued/client01.crt /etc/openvpn/
cp /root/my_ca/pki/private/client01.key /etc/openvpn/

clientpath="/etc/openvpn/client.conf"

echo Server-IP?
read Sip

echo "remote $Sip 1194" > $clientpath
echo "proto udp" >> $clientpath
echo "dev tun" >> $clientpath
echo "ca ca.crt" >> $clientpath
echo "cert client01.crt" >> $clientpath
echo "key client01.key" >> $clientpath
echo "dh dh.pem" >> $clientpath
echo "ping-timer-rem" >> $clientpath
echo "keepalive 20 180" >> $clientpath

systemctl restart openvpn
