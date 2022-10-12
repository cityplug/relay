#!/bin/bash

mv /opt/relay/.scripts/jail.local /etc/fail2ban/jail.local

# --- Setup samba share and config
echo "#  ---  Setting up samba share --- #"
usermod -aG sambashare shay
chmod -R 777 /relay/*

systemctl stop smbd
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
mv /opt/relay/.scripts/smb.conf /etc/samba/

echo "#  ---  Create samba user password --- #"
smbpasswd -a shay
echo
/etc/init.d/smbd restart && /etc/init.d/nmbd restart
echo "#  ---  Samba share created --- #"

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

# ----> Next Script
./relay_net.sh