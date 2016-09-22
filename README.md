Run on docker

    docker run -e "HUB_PORT_4444_TCP_ADDR=<ip>" -e "HUB_PORT_4444_TCP_PORT=31245" -e "HOST=<host>" -e "PORT0=55" -e "MAX_INSTANCES=5" --net host  selenium-node
    docker run -e "MARATHON_URL=http://<ip>:8080" -e "MARATHON_CREDENTIALS=<user>:<pass>" -e "HUB_APPID=/selgrid01/hub"  "MAX_INSTANCES=5" --net host  varokas/selenium-node
