#include <PubSubClient.h>
#include <WiFi.h>

const char* ssid = "YourWifiSSID";
const char* password = "YourWifiPass";

const char* mqtt_server = "RPIServerIP";

const char* user = "user";
const char* pass = "pass";

WiFiClient espClient;
PubSubClient client(espClient);

const int startpin = 13;
const int picpin = 12;
const int stoppin = 14;

String rawdata = "";
String orawdata = "";

const char* data;

const char* odata;

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP32Client",user,pass)) {
      Serial.println("connected");
      // Subscribe
      //client.subscribe("esp32/data");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  // while(!Serial);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  
  pinMode(startpin, INPUT_PULLUP);
  pinMode(picpin, INPUT_PULLUP);
  pinMode(stoppin, INPUT_PULLUP);

  orawdata += digitalRead(startpin);
  orawdata += digitalRead(picpin);
  orawdata += digitalRead(stoppin);

  odata = orawdata.c_str();

  client.publish("esp32/data",odata);
}

void loop() {
  //put your main code here, to run repeatedly:
  if(!client.connected()){
    reconnect();
  }
  client.loop();

  rawdata = "";
  rawdata += digitalRead(startpin);
  rawdata += digitalRead(picpin);
  rawdata += digitalRead(stoppin);

  if(orawdata != rawdata){
    orawdata = rawdata;
    
    data = rawdata.c_str();
  
    client.publish("esp32/data",data);

    Serial.println(data);
  }
  // data = rawdata.c_str();
  
  // client.publish("esp32/data",data);
  


  //delay(50);
  // delay(2000);
  // client.publish("esp32/data","011");
  // delay(1000);
  // client.publish("esp32/data","100");
  // delay(1000);
  // client.publish("esp32/data","010");
  // delay(1000);
}
