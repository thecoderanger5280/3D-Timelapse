#!/bin/bash

#pinctrl set 17 ip pu
#pinctrl set 22 ip pu
#pinctrl set 27 ip pu

topic_name="esp32/data"
user="onua5280"
pass="Maxldr23"

d=0

#while true; do
  #if [ $(pinctrl lev 22) == 0 ]; then
    #mkdir /home/onua5280/t$d
    #n=0
    #. ./save_pic.sh
    #while true; do
      #if [ $(pinctrl lev 17) == 0 ]; then
        #sleep 0.1
        #libcamera-jpeg -t 1 -o /home/onua5280/t$d/pic$n.jpg --nopreview
        #((n++))
        #sleep 0.1
      #fi
      #if [ $(pinctrl lev 27 == 0); then
        #break
      #fi
      #sleep 0.5
    #done
    #((d++))
  #fi
#done
while true; do
  while read data; do
    if [ ${data:0:1} == 0 ]; then
      mkdir -p /home/onua5280/timelapse$d
      p=0
      while read data1; do
        if [ ${data1:1:1} == 0 ]; then
          libcamera-still -t .1 -o /home/onua5280/timelapse$d/pic$p.jpg
          if [ -f /home/onua5280/timelapse$d/pic$p.jpg ]; then
            ((p++))
          fi
        fi
        if [ ${data1:2:1} == 0 ]; then
          ffmpeg -y -framerate 10 -i /home/onua5280/timelapse0/pic%d.jpg /home/onua5280/timelapse$d.mp4
          rm -rf /home/onua5280/timelapse$d
          break
        fi
      done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
      ((d++))
    fi
    #((d++))
  done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
done
