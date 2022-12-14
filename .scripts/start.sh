#!/bin/bash

# Raspbian (relay.machine v2.4) setup script.

# --- Remove Bloatware
echo "#  ---  Removing Bloatware  ---  #"
apt-get autoremove && apt-get autoclean -y
rm -rf python_games && rm -rf /usr/games/
apt-get purge --auto-remove libraspberrypi-dev libraspberrypi-doc -y

# --- Disable Services
echo "#  ---  Disabling Bloatware Services  ---  #"
systemctl stop alsa-state.service hciuart.service sys-kernel-debug.mount \
systemd-udev-trigger.service systemd-journald.service \
systemd-fsck-root.service systemd-logind.service wpa_supplicant.service \
bluetooth.service apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service

systemctl disable alsa-state.service hciuart.service sys-kernel-debug.mount \
systemd-udev-trigger.service systemd-journald.service \
systemd-fsck-root.service systemd-logind.service wpa_supplicant.service \
bluetooth.service apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service

# --- Disable Bluetooth/WIFI & Splash
echo "
disable_splash=1
dtoverlay=disable-wifi
dtoverlay=disable-bt" >> /boot/config.txt

# --- Initialzing relay
hostnamectl set-hostname relay.home.local
hostnamectl set-hostname "Relay Host Machine" --pretty
rm -rf /etc/hosts
mv /opt/relay/.scripts/hosts /etc/hosts

# --- Install CockPit
. /etc/os-release
echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > \
    /etc/apt/sources.list.d/backports.list
apt update -y
apt install -t ${VERSION_CODENAME}-backports cockpit
# --- Install Packages
echo "#  ---  Installing New Packages  ---  #"
apt install samba samba-common-bin -y
apt install python3-pip -y
# --- Install Docker & Docker-Compose
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

wget https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-aarch64 -O /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose && apt install docker-compose -y

systemctl enable docker
docker-compose --version && docker --version
usermod -aG docker focal

# --- Addons
echo "#  ---  Running Addons  ---  #"
mkdir -p /relay
mkdir /relay/.AppData/ && chmod -R 777 /relay/.AppData
mkdir /relay/wallet/ && chmod -R 777 /relay/wallet
mkdir /relay/.v_bin/ && chmod -R 777 /relay/.v_bin
mkdir /relay/public && chmod -R 777 /relay/public
chown focal /relay
chown -R focal:sambashare /relay/*
chown -R nobody.nogroup /relay/public

rm -rf /etc/update-motd.d/* && rm -rf /etc/motd
mv /opt/relay/10-uname /etc/update-motd.d/ && chmod +x /etc/update-motd.d/10-uname

# wget https://raw.githubusercontent.com/shellinabox/shellinabox/master/shellinabox/white-on-black.css -O /etc/shellinabox/white-on-black.css
# mv /opt/relay/.scripts/shellinabox /etc/default/shellinabox
# apt install shellinabox -y

# --- Over clcok raspberry pi & increase GPU
# sed -i '40i\over_voltage=6\narm_freq_min=800\narm_freq=1850\n' /boot/config.txt

# --- Security Addons
groupadd ssh-users
usermod -aG ssh-users focal
sed -i '15i\AllowGroups ssh-users\n' /etc/ssh/sshd_config

# --- Create and allocate swap
echo "#  ---  Creating 4GB swap file  ---  #"
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
# --- Add swap to the /fstab file & Verify command
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab' && cat /etc/fstab
sh -c 'echo "apt autoremove -y" >> /etc/cron.monthly/autoremove'
# --- Make file executable
chmod +x /etc/cron.monthly/autoremove
echo "#  ---  4GB swap file created | SYSTEM REBOOTING  ---  #"

# --- Change root password
echo "#  ---  Change root password  ---  #"
passwd root
echo "#  ---  Root password changed  ---  #" 
reboot
# ----> Next Script | security-samba.sh