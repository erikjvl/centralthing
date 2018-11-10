# CentralThing 01 :: init.sh

mkdir -p nodered
mkdir -p grafana
mkdir -p nginx
mkdir -p influxdb


chmod 777 nodered
chmod 777 grafana
chmod 777 nginx
chmod 777 influxdb

chmod +r grafana.ini

RUNNINGONPLATFORM=$(uname -m | cut -b -3)
if [ "$RUNNINGONPLATFORM" = 'arm' ]; then 
    echo "It's a Pi"
    rm -f docker-compose.yml.old
    [ -f docker-compose.yml ] && mv docker-compose.yml docker-compose.yml.old
    cp docker-compose-pi.yml docker-compose.yml
else
    echo "No Pi this time!"
    rm -f docker-compose.yml.old
    [ -f docker-compose.yml ] && mv docker-compose.yml docker-compose.yml.old
    cp docker-compose-x86.yml docker-compose.yml
    # sudo curl -L https://github.com/docker/compose/releases/download/1.23.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    # sudo chmod +x /usr/local/bin/docker-compose
    # sudo docker-compose --version
fi

docker-compose pull
docker-compose up -d
docker-compose ps

docker exec -it centralthing_influxdb_1 curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE "centralthing"'
docker exec -it centralthing_influxdb_1 curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=SHOW DATABASES'

docker exec -it centralthing_nodered_1 curl cd /data && npm install node-red-contrib-influxdb

echo "Copy and run: alias u=\"sudo docker-compose up -d\" && alias p=\"sudo docker-compose ps\" && alias d=\"sudo docker-compose down\"" 
