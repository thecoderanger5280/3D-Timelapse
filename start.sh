#!/bin/bash

#pinctrl set 17 ip pu
#pinctrl set 22 ip pu
#pinctrl set 27 ip pu

topic_name="esp32/data"
user="user"
pass="pass"

d=0

#while true; do
  #if [ $(pinctrl lev 22) == 0 ]; then
    #mkdir /path/to/file/t$d
    #n=0
    #. ./save_pic.sh
    #while true; do
      #if [ $(pinctrl lev 17) == 0 ]; then
        #sleep 0.1
        #libcamera-jpeg -t 1 -o /path/to/file/t$d/pic$n.jpg --nopreview
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
      mkdir -p /path/to/file/timelapse$d
      p=0
      while read data1; do
        if [ ${data1:1:1} == 0 ]; then
          libcamera-still -t .11 -o /path/to/file/timelapse$d/pic$p.jpg
          ((p++))
        fi
        if [ ${data1:2:1} == 0 ]; then
          break
        fi
      done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
      ((d++))
    fi
    #((d++))
  done < <(mosquitto_sub -t $topic_name -u $user -P $pass)
done
