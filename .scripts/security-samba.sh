#!/bin/bash

# --- Security Addons
groupadd ssh-users
usermod -aG ssh-users shay
sed -i '15i\AllowGroups ssh-users\n' /etc/ssh/sshd_config

mv /opt/relay/.scripts/jail.local /etc/fail2ban/jail.local
# --- Setup samba share and config
echo "#  ---  Setting up samba share --- #"
groupadd sambashare
usermod -aG sambashare shay
chmod -R 777 /relay/*

systemctl stop smbd
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
mv /opt/relay/.scripts/smb.conf /etc/samba/
echo "#  ---  Create samba user password --- #"
smbpasswd -a shay
echo
/etc/init.d/smbd restart && /etc/init.d/nmbd restart
# --- Mount USB
echo "UUID=D8D3-CE07 /relay/storage/  auto   defaults,user,nofail  0   0" >> /etc/fstab
mount -a
echo "#  ---  Samba share created --- #"

# ----> Next Script
./relay_net.sh