Run on docker

    docker run -e "HUB_PORT_4444_TCP_ADDR=139.59.226.189" -e "HUB_PORT_4444_TCP_PORT=31245" -e "HOST=188.166.217.113" -e "PORT0=55" -e "MAX_INSTANCES=5" --net host  selenium-node
