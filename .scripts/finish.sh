#!/bin/bash

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

echo "#  ---  Running Fan Control  ---  #"
cd fanshim && chmod +x install.sh && ./install.sh

chmod +x /opt/relay/.scripts/fanshim/examples/install-service.sh
cd examples/ && ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 5 --brightness 10

echo "# --- Enter pihole user password --- #"
docker exec -it pihole pihole -a -p
echo "#  ---  COMPLETED | REBOOT SYSTEM  ---  #"
exit



