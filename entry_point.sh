#!/bin/bash

source /opt/bin/functions.sh

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

#Generate Config
./opt/selenium/config.json.sh | sudo tee /opt/selenium/config.json

#### Marathon Configuration #####
if [ -n "$MARATHON_URL" ]; then
  MARATHON_CREDENTIALS_TOKEN=""
  if [ -n "$MARATHON_CREDENTIALS" ]; then
    MARATHON_CREDENTIALS_TOKEN="-u $MARATHON_CREDENTIALS"
  fi

  if [ -z "$HUB_APPID" ]; then
    echo "Does not specify HUB_APPID" 1>&2
    exit 1 
  fi

  #Encode slash in hub id
  HUB_APPID=`echo $HUB_APPID | sed s#/#%2F#g`
  
  HUB_MARATHON=`curl $MARATHON_CREDENTIALS_TOKEN $MARATHON_URL/v2/apps/$HUB_APPID/tasks`
  echo $HUB_MARATHON

  HUB_PORT_4444_TCP_PORT=`echo $HUB_MARATHON | jq '.tasks[0].ports[0]'`
  HUB_PORT_4444_TCP_ADDR=`echo $HUB_MARATHON | jq -r '.tasks[0].ipAddresses[0].ipAddress'`
fi

if [ -z "$HUB_PORT_4444_TCP_ADDR" ]; then
  echo "Not linked with a running Hub container (HUB_PORT_4444_TCP_ADDR)" 1>&2
  exit 1
fi

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

REMOTE_HOST_PARAM=""
if [ ! -z "$REMOTE_HOST" ]; then
  echo "REMOTE_HOST variable is set, appending -remoteHost"
  REMOTE_HOST_PARAM="-remoteHost $REMOTE_HOST"
fi

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

# TODO: Look into http://www.seleniumhq.org/docs/05_selenium_rc.jsp#browser-side-logs

SERVERNUM=$(get_server_num)
xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
    -role node \
    -hub http://$HUB_PORT_4444_TCP_ADDR:$HUB_PORT_4444_TCP_PORT/grid/register \
    ${REMOTE_HOST_PARAM} \
    -nodeConfig /opt/selenium/config.json \
    ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID

