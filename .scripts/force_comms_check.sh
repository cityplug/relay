ping -c4 192.168.50.254 > /dev/null
 
if [ $? != 0 ] 
then
  sudo /sbin/shutdown -r now
fi