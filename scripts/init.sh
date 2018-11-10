# CentralThing 02 :: init.sh

mkdir -p ../influxdb


chmod 777 ../nodered
chmod 777 ../grafana
chmod 777 ../nginx
chmod 777 ../influxdb

chmod +r ../grafana/grafana.ini
chmod -R a+rw ../nodered 

rm -f ../docker-compose.yml
RUNNINGONPLATFORM=$(uname -m | cut -b -3)
if [ "$RUNNINGONPLATFORM" = 'arm' ]; then 
    echo "It's a Pi"
    cp docker-compose-pi.yml ../docker-compose.yml
else
    echo "A X86 system this time"
    cp docker-compose-x86.yml ../docker-compose.yml
fi

cd ..
docker-compose up -d
docker-compose ps

docker exec -it centralthing_influxdb_1 curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE "centralthing"'
docker exec -it centralthing_influxdb_1 curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=SHOW DATABASES'

#docker exec -it centralthing_nodered_1 sh /data/installinflux.sh
#docker-compose restart nodered


echo "Copy and run: alias u=\"sudo docker-compose up -d\" && alias p=\"sudo docker-compose ps\" && alias d=\"sudo docker-compose down\" && alias r=\"sudo docker-compose restart \" && alias s=\"sudo docker-compose stop \"" 
