docker network create -d macvlan \
    --subnet=192.168.50.0/24 \
    --gateway=192.168.50.1 \
    -o parent=eth0 relay_net

echo
sudo docker-compose up -d
docker ps

# ----> Next Script
./finish.sh