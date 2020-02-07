#!/bin/bash
apt install openvpn -y

echo "server" > /etc/hostname

cd /usr/share/doc/easy-rsa/
make-cadir /root/my_ca
cd /root/my_ca

./easyrsa clean-all
./easyrsa build-ca nopass
./easyrsa gen-dh

./easyrsa build-server-full server nopass
./easyrsa build-client-full client01 nopass
./easyrsa build-client-full client02 nopass

cp /root/my_ca/pki/private/server.key /etc/openvpn/
cp /root/my_ca/pki/issued/server.crt /etc/openvpn/
cp /root/my_ca/pki/ca.crt /etc/openvpn/
cp /root/my_ca/pki/dh.pem /etc/openvpn/

path="/etc/openvpn/server.conf"

echo "server 192.168.0.0 255.255.255.0" > $path
echo "port 1194" >> $path
echo "proto udp" >> $path
echo "dev tun" >> $path
echo "ca ca.crt" >> $path
echo "cert server.crt" >> $path
echo "key server.key" >> $path
echo "dh dh.pem" >> $path
echo "ping-timer-rem" >> $path
echo "keepalive 20 180" >> $path