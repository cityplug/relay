#### Grant new user account with privileges & assign new privileges
    sudo usermod -aG sudo,root focal && sudo visudo
#### Add the following underneath User privilege specification 
        focal	ALL=(ALL:ALL) ALL 
#### Add the following to the bottom of file under includedir /etc/sudoers.d 
        focal ALL=(ALL) NOPASSWD: ALL
#### Copy ssh key to server
    sudo su
    mkdir -p /home/focal/.ssh/ && touch /home/focal/.ssh/authorized_keys
    curl https://github.com/cityplug.keys >> /home/focal/.ssh/authorized_keys
#### Secure SSH Server by changing default port
    nano -w /etc/ssh/sshd_config
#### Find the line that says “#Port 22” and change it to desired port 
#### Scroll down until you find the line that says “PermitRootLogin” and change to “no” 
#### PermitRootLogin “no”
#### Scroll down further and find “PasswordAuthentication” and again change to “no” 
#### PasswordAuthentication “no”
    apt update && apt full-upgrade -y && reboot
--------------------------------------------------------------------------------
### Run the following scripts
    sudo su
    cd /opt && apt install git -y && git clone https://github.com/cityplug/relay && chmod +x relay/.scripts/*
------------------------------------------------------------------------------
### Run the following scripts
    cd relay/.scripts/ && ./start.sh
    sudo su
    cd /opt/relay/.scripts/ && ./security-samba.sh
--------------------------------------------------------------------------------
    docker exec zerotier zerotier-cli join 8bd5124fd6badc1f
--------------------------------------------------------------------------------
    echo "
    interface eth0
    static ip_address=192.168.50.254/24
    static routers=192.168.50.1" >> /etc/dhcpcd.conf
------------------------------------------------------------------------------
