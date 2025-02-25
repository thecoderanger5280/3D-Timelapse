# RPi Camera Timelapse Creator
---
## This is a wireless Rapsberry Pi camera that is controlled by a Prusa 3D printer.
---
## What you will need
- Raspberry Pi
-- I am using a 4 Model B
- An ESP32 Dev Board
- A Prusa GPIO Hackerboard

## Steps for Install
---
### Prerequisites
- Have mosquitto broker installed on the raspberry pi and configured.
- **Optional**
-- Have the Raspberry pi set up for SSH.
*This will make it easier while programming the esp32 board.*

1. Download these files to home directory of the Raspberry Pi.
- start.sh
- timelapse.service

2. Edit timelapse.service with your favorite text editor.
-- I'm using nano for the purpose of this project.

- `sudo nano /home/USERNAME/timelapse.service`

- Where USERNAME is the name of the user.

- Replace USER with the name of the user in the file.

- Exit the file with CTRL + X, when you are prompted to save press Y and then ENTER.
  
3. While in your home directory, move timelapse.service to /etc/systemd/system/ with a command similar to this.
 
- `sudo mv /home/USERNAME/timelapse.service /etc/systemd/system`

- Where USERNAME is the name of the user.

4. Edit start.sh with the same text editor.

- `sudo nano /home/USERNAME/start.sh`

- Whre USERNAME is the name of the user.

- Replace "user" and "pass" with the username and password for the mosquitto server.
--**If you dont want to use the username and password feature you can ignore this step.**
**However you will need to edit the code to not use the username and password when it is calling the `mosqutto_sub` command**

- Replace /path/to/file/ with the file path you want the timelapses saved.
--**There are 4 places to edit this, 2 are commented out.**

- Exit the file with CTRL + X, when you are prompted to save press Y and then ENTER.

5. For the next steps we will need the IP address of the Raspberry Pi.
*Alternitively you can use the hostame of the Raspberry Pi if you prefer*

**Optional: If you dont want to use a esp32 board and just want it wired directly to the Pi.**
**Uncomment the code block that is commented, and comment out the current code block.**
**By doing this, you will need to configure the pin numbers with the pin numbers you want to control.**
**You will also need to still edit the /path/to/file/ parts of the code.**
***You can also skip all steps about setting up the esp32 board.***

6. Before you enable the service for the Raspberry Pi, setup your esp32 board with the following steps.

7. On your computer download the .ino file and open it in the arduino ide.
- In the arduino ide you will need to update the wifi credentials to match your wifi. As well as update the pins to the pins you will be using.
- You will also need to update the server address to the IP address of your Raspberry Pi.
-- You can also change the topic if you prefer.
*This will require you to change the topic in the start.sh file on the Raspberry Pi as well.*
- You will finally need to update the user and pass variables to the Username and Password of the Mosquitto Server if you are using a username and password.
- Compile the code to make sure there are no errors.

8. Flash the code to the esp32

9. Back on the Raspberry Pi, use this command to double check that the esp32 is brodcasting the data through MQTT.
-  `mosquitto_sub -t "esp32/data"` or `mosquitto_sub -t "esp32/data" -u USERNAME -P PASSWORD` Where USERNAME and PASSWORD are the username and password of the server, if you are using a username and password.
- *You will need to substitute the topic if you changed it in the esp32's code.*
- If everything worked correctly, you will see an output of 3 digit binary numbers.
- *These numbers should be '111' unless you have connected any of the input pins on the esp32 to ground.*
- To get out of the never ending output press CTRL + C.

10. Once you have confirmed the data is being sent and correct, you can enable the service with the following commands.
- `sudo systemctl daemon-reload`
- `sudo systemctl enable timelapse.service`

11. To verify the service is running use the following command.
- `sudo sytemctl status timelapse.service`
- To get out of the status menu press CRTL + C.

12. To get PrusaSlicer up and running with the GPIO Hackerboard, edit the Start, End, and Layer Change GCODE with the following code. Feel free to add it wherever you prefer in the sequence, I added mine to come before any other GCODE.
-- *You can use either Before or After Layer Change GCODE, I used After Layer Change*
- **Start GCODE**
```
; initialize pins as outputs
M262 P0 B0
M262 P1 B0
M262 P2 B0

; set pins low
M264 P0 B0
M264 P1 B0
M264 P2 B0

; start the timelapse
M265 P0
G4 P150
M265 P0
```
- **End GCODE**
```
; end timelapse
M265 P2
G4 P150
M265 P2
```
- **Layer Change**
```
; take picture
M265 P1
G4 P150
M265 P1
```

11. The files will be formated in this structure wherever you decided to have them saved.
- Timelapse folders will be named sequentially: timelapse0 timelapse1 etc...
- In timelapse folders the pictures will be named sequencially: pic0 pic1 etc...
