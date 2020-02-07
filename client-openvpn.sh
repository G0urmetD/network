#!/bin/bash

echo "client" > /etc/hostname

apt update

cd /etc/openvpn/ rm -r server.crt
cd /etc/openvpn/ rm -r server.key
cd /etc/openvpn/ rm -r server.conf
cd /etc/openvpn/ rm -r dh.pem
cd /etc/openvpn/ rm -r server

cp /root/my_ca/pki/issued/client01.crt
cp /root/my_ca/pki/private/client01.key

clientpath="/etc/openvpn/client.conf"

echo "remote 10.16.203.223 1194" > $clientpath
echo "proto udp" >> $clientpath
echo "dev tun" >> $clientpath
echo "ca ca.crt" >> $clientpath
echo "cert client01.crt" >> $clientpath
echo "key client01.key" >> $clientpath
echo "dh dh.pem" >> $clientpath
echo "ping-timer-rem" >> $clientpath
echo "keepalive 20 180" >> $clientpath
