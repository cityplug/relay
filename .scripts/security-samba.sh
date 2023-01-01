#!/bin/bash

# --- Setup samba share and config

echo "#  ---  Create samba user password --- #"
smbpasswd -a focal
echo "#  ---  Create GUEST samba user password --- #"
smbpasswd -a home

echo "#  ---  Setting up samba share --- #"
usermod -aG sambashare focal
chmod -R 777 /relay/*

systemctl stop smbd
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
mv /opt/relay/.scripts/smb.conf /etc/samba/

echo
/etc/init.d/smbd restart && /etc/init.d/nmbd restart
echo "#  ---  Samba share created --- #"

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

# ----> Next Script
./relay_net.sh