FROM python:3.9-slim
LABEL maintainer="Lkas Wolfsteiner <lukas@wolfsteiner.media>"
LABEL org.opencontainers.image.source=https://github.com/dotWee/docker-adb-mqtt-bridge

ENV LANG C.UTF-8

ENV MQTT_SERVER localhost
ENV MQTT_PORT 1883
ENV TOPIC AdbMqttBridge
ENV USER mqttuser
ENV PASSWORD mqttpass
ENV ADB_DEVICE 192.168.1.243
ENV POLL_INTERVAL 5

RUN apt-get update && \
    apt-get install -y android-tools-adb mosquitto-clients jq python python-pip && \
    pip install paho-mqtt

# adb settings must be persistant
VOLUME /config
RUN ln -s /config /root/.android

# Copy data for add-on
COPY adb_monitor.py /
RUN chmod a+x /adb_monitor.py

CMD [ "/adb_monitor.py" ]
