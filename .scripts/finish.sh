#!/bin/bash

echo "#  ---  Running Fan Control  ---  #"
cd fanshim && chmod +x install.sh && ./install.sh

chmod +x /opt/relay/.scripts/fanshim/examples/install-service.sh
cd examples/ && ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 5 --brightness 10

# --- Build Homer
docker stop homer
rm -rf /relay/.AppData/homer/*
mv /opt/relay/.scripts/homer/assets /relay/.AppData/homer/assets
docker start homer

# Setting failover
mv /opt/relay/.scripts/soft_restart /usr/local/bin/comms_check
mv /opt/relay/.scripts/hard_restart /usr/local/bin/force_comms_check

echo "
*/5 * * * * /usr/bin/sudo -H /usr/local/bin/comms_check.sh >> /dev/null 2>&1
0 2 * * * /usr/bin/sudo -H /usr/local/bin/force_comms_check.sh >> /dev/null 2>&1" >>/etc/crontab
sed -i '19i\./comms_check \n' /etc/rc.local
sed -i '20i\./force_comms_check.sh \n' /etc/rc.local

echo "# --- Enter pihole user password --- #"
docker exec -it pihole pihole -a -p
echo "#  ---  COMPLETED | REBOOT SYSTEM  ---  #"
exit



