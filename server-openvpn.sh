#!/bin/bash
# install the openvpn service
apt install openvpn -y
clear

# set the hostname to "server"
echo "server" > /etc/hostname

# create the CA and needed KEYS/CERTS
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

# just the path of the server.conf
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

# restarts the openvpn service
systemctl restart openvpn

# install apache2 for sharing the client site documents
apt install apache2 -y
clear
cd /var/www/html/
rm -r index.html

cp /root/my_ca/pki/ca.crt /var/www/html/
cp /root/my_ca/pki/private/client02.key /var/www/html/
cp /root/my_ca/pki/issued/client02.crt /var/www/html/

cd /var/www/html/
chown www-data:www-data ./*
