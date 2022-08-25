#!/bin/bash

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

echo "#  ---  Running Fan Control  ---  #"
cd fanshim && chmod +x install.sh && ./install.sh

chmod +x /opt/relay/.scripts/fanshim/examples/install-service.sh
cd examples/ && ./install-service.sh --on-threshold 60 --off-threshold 50 --delay 3 --brightness 30

echo "# --- Enter pihole user password --- #"
docker exec -it pihole pihole -a -p
echo "#  ---  COMPLETED | REBOOT SYSTEM  ---  #"
exit



