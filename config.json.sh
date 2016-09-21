#!/bin/bash

if [ -z "$MAX_INSTANCES" ]; then
  MAX_INSTANCES=1
fi

#Mesos Variable
if [ -n "$PORT0" ]; then
  NODE_PORT=$PORT0
fi
if [ -n "$HOST" ]; then
  NODE_HOST=$HOST
fi

#Blank by default 
HOST_LINE=
if [ -n "$NODE_HOST" ]; then
  HOST_LINE="\"host\": \"$NODE_HOST\","
fi

if [ -z "$NODE_PORT" ]; then
  NODE_PORT=5555
fi

cat << EOF
{
  "capabilities": [
    {
      "browserName": "chrome",
      "maxInstances": $MAX_INSTANCES,
      "seleniumProtocol": "WebDriver"
    },
    {
      "browserName": "firefox",
      "maxInstances": $MAX_INSTANCES,
      "seleniumProtocol": "WebDriver"
    }
  ],
  "configuration": {
    "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
    "maxSession": $MAX_INSTANCES,
    $HOST_LINE
    "port": $NODE_PORT,
    "register": true,
    "registerCycle": 5000
  }
}
EOF
