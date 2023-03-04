FROM python:3.11-alpine
LABEL org.opencontainers.image.source=https://github.com/i8beef/docker-adb-mqtt-bridge

ENV LANG C.UTF-8

ENV MQTT_SERVER localhost
ENV MQTT_PORT 1883
ENV TOPIC AdbMqttBridge
ENV USER mqttuser
ENV PASSWORD mqttpass
ENV ADB_DEVICE 192.168.1.45
ENV POLL_INTERVAL 5

WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY adb_monitor.py .
RUN apk update && \
    apk add --no-cache android-tools mosquitto-clients jq

# adb settings must be persistant
VOLUME [ "/config" ]
RUN ln -s /config ~/.android

CMD [ "python", "./adb_monitor.py" ]