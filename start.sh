#!/bin/bash

topic_name="esp32/data"
user="user"
pass="pass"

d=0
while true; do
  while read data; do
    if [ ${data:0:1} == 0 ]; then
      mkdir -p /path/to/timelapse$d
      p=0
      while read data1; do
        if [ ${data1:1:1} == 0 ]; then
          libcamera-still -t .1 -o /path/to/timelapse$d/pic$p.jpg
          if [ -f /path/to/timelapse$d/pic$p.jpg ]; then
            ((p++))
          fi
        fi
        if [ ${data1:2:1} == 0 ]; then
          ffmpeg -y -framerate 10 -i /path/to/files/timelapse0/pic%d.jpg /path/to/save/timelapse$d.mp4
          rm -rf /path/to/timelapse$d
          break
        fi
      done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
      ((d++))
    fi
    #((d++))
  done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
done
