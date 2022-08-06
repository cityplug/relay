#!/bin/bash

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p

chmod +x /opt/relay/.scripts/fanshim/examples/install-service.sh
#./install-service.sh --on-threshold 65 --off-threshold 55 --delay 2 
cd examples/ && ./install-service.sh --on-threshold 70 --off-threshold 60 --delay 3

echo "# --- Enter pihole user password --- #"
docker exec -it pihole pihole -a -p
echo "#  ---  COMPLETED | REBOOT SYSTEM  ---  #"
exit



