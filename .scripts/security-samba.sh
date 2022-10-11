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

# ----> Next Script
./relay_net.sh

# --- Mount USB
#echo "UUID=dfc48d93-5c04-45fb-a987-e82107d09081 /relay/tank/  auto   defaults,user,nofail  0   0" >> /etc/fstab
#mount -a
