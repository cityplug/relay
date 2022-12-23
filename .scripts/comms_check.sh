ping -c4 192.168.50.254 > /dev/null
 
if [ $? != 0 ] 
then
  echo "No network connection, restarting eth0"
  /sbin/ifdown 'eth0'
  sleep 5
  /sbin/ifup --force 'eth0'
fi