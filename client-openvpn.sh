#!/bin/bash
# set the hostname to "client"
echo "client" > /etc/hostname

# make an update
apt update

# go into the path and remove all not needed server documents
cd /etc/openvpn/ 
rm -r server.crt
rm -r server.key
rm -r server.conf
rm -r dh.pem
rm -r server

# copy the client KEY and CERT into the openvpn path
cp /root/my_ca/pki/issued/client01.crt /etc/openvpn/
cp /root/my_ca/pki/private/client01.key /etc/openvpn/

# path of the client.conf
clientpath="/etc/openvpn/client.conf"

# asking for the IP
echo Server-IP?
read Sip

# config
echo "remote $Sip 1194" > $clientpath
echo "proto udp" >> $clientpath
echo "dev tun" >> $clientpath
echo "ca ca.crt" >> $clientpath
echo "cert client01.crt" >> $clientpath
echo "key client01.key" >> $clientpath
echo "ping-timer-rem" >> $clientpath
echo "keepalive 20 180" >> $clientpath

# restart the opvenpn service
systemctl restart openvpn
