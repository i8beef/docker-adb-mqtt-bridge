# docker-adb-mqtt-bridge

![github status](https://img.shields.io/github/workflow/status/dotwee/docker-adb-mqtt-bridge/build%20and%20publish%20docker%20image/master?logo=GitHub)
![github activity](https://img.shields.io/github/last-commit/dotwee/docker-adb-mqtt-bridge?logo=github)
![github open issues](https://badgen.net/github/open-issues/dotwee/docker-adb-mqtt-bridge?icon=github)
![github license](https://badgen.net/github/license/dotwee/docker-adb-mqtt-bridge?icon=github)
![docker pulls](https://badgen.net/docker/pulls/dotwee/adb-mqtt-bridge?icon=docker&label=pulls)

Control Android devices with MQTT using ADB. 

This docker image creates a very basic cli proxy to remote control one or more android devices using MQTT.

Based upon [@marcelveldt](https://github.com/marcelveldt)'s initial work on the [docker-image-adb-mqtt-proxy](https://github.com/marcelveldt/docker-image-adb-mqtt-proxy) project.

## pulling

### from [**docker hub**](https://hub.docker.com/r/dotwee/adb-mqtt-bridge)

```bash
$ docker pull dotwee/adb-mqtt-bridge:latest
```

### from [**github packages**](https://github.com/dotWee/docker-adb-mqtt-bridge/pkgs/container/adb-mqtt-bridge)

```bash
$ docker pull ghcr.io/dotwee/adb-mqtt-bridge:latest
```

### available tags

- `linux/arm/v6`
- `linux/arm/v7`
- `linux/arm64`
- `linux/amd64`

## running

environmental arguments:

- `MQTT_SERVER`: hostname/IP of MQTT broker
- `MQTT_PORT`: port of the mqtt broker
- `MQTT_CLIENT`: clientname to use for mqtt communication (falls back to hostname if ommitted)
- `TOPIC`: base MQTT topic
- `USER`: mqtt username
- `PASSWORD`: mqtt password
- `ADB_DEVICE`: ip of the device to control (for multiple devices, seperate with commas)

```bash
$ docker run \
    --name adb-mqtt-bridge \
    -v "${PWD}":/config \
    -e MQTT_SERVER=192.168.1.55 \
    -e TOPIC=AdbMqttBridge \
    -e ADB_DEVICE=192.168.1.45 \
    --restart always \
    dotwee/adb-mqtt-bridge:latest
```

using [docker-compose](./docker-compose.yml):

```yaml
version: '3.2'

services:
  adb-mqtt-bridge:
    container_name: adb-mqtt-bridge
    hostname: adb-mqtt-bridge
    image: dotwee/adb-mqtt-bridge:latest
    environment:
      - MQTT_SERVER=192.168.1.55
      - MQTT_PORT=1883
      - MQTT_CLIENT=adb-mqtt-bridge
      - TOPIC=AdbMqttBridge
      - USER=YourMQTTUser
      - PASSWORD=YourMQTTUserPass
      - ADB_DEVICE=192.168.1.45
      - POLL_INTERVAL=5
    volumes:
      - ./config:/config:rw
    restart: always
```

## mqtt messages


```
The powerstate of each device will be pubished to:

<TOPIC>/<IP_OF_ADB_DEVICE>/stat
```


```
Commands for each device can be sent to:

<TOPIC>/<IP_OF_ADB_DEVICE>/cmd
```

```
For basic power commands, you can simply issue a ON/OFF command to the command topic.

topic:   AdbMqttBridge/192.168.1.45/cmd
payload: ON
```

```
You can also send shell commands to the command topic

topic:   AdbMqttBridge/192.168.1.45/cmd
payload: shell input keyevent KEYCODE_VOLUME_UP
```


