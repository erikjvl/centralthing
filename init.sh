# CentralThing 01 :: init.sh

mkdir nodered
mkdir grafana
mkdir nginx
mkdir influxdb


chmod 777 nodered
chmod 777 grafana
chmod 777 nginx
chmod 777 influxdb

chmod +r grafana.ini


alias u="sudo docker-compose up -d"
alias p="sudo docker-compose ps"
alias d="sudo docker-compose down"

RUNNINGONPLATFORM=$(uname -m | cut -b -3)
if [ "$RUNNINGONPLATFORM" = 'arm' ]; then 
    echo "It's a Pi"
    rm docker-compose.yml.old
    mv docker-compose.yml docker-compose.yml.old
    cp docker-compose-pi.yml docker-compose.yml
else
    echo "No Pi this time!"
    rm docker-compose.yml.old
    mv docker-compose.yml docker-compose.yml.old
    cp docker-compose-x86.yml docker-compose.yml
    sudo curl -L https://github.com/docker/compose/releases/download/1.23.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo docker-compose --version
fi

sudo docker-compose pull