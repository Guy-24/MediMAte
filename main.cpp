#include <Wire.h>
#include "PCF8574.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

PCF8574 PCF_1(0x20);

const int Servo_pin1 = P0;
const int Servo_pin2 = P1;
const int Servo_pin3 = P2;
const int Servo_pin4 = P3;
const int Relay_pin1 = P4;

void writeServoPulse(int pin, int pulseWidth)
{
  PCF_1.digitalWrite(pin, HIGH);
  delayMicroseconds(pulseWidth);
  PCF_1.digitalWrite(pin, LOW);
  delayMicroseconds(20000 - pulseWidth);
}

void setServoAngle(int pin, int angle)
{
  int pulseWidth = map(angle, 0, 180, 500, 2000); // mapping for 180 degree servo
  writeServoPulse(pin, pulseWidth);
}

void moveServoToAngle(int pin, int targetAngle, int currentAngle, int speed)
{
  if (speed <= 0)
    speed = 1;                                      // Ensure speed is positive and non-zero
  int step = (targetAngle > currentAngle) ? 1 : -1; // Determine direction of movement

  // Gradually move to the target angle
  for (int angle = currentAngle; angle != targetAngle; angle += step)
  {
    setServoAngle(pin, angle); // Set the servo angle
    delay(speed);              // Delay determines the speed
  }

  setServoAngle(pin, targetAngle); // Ensure it stops exactly at the target angle
}

void alram()
{
  PCF_1.digitalWrite(Relay_pin1, HIGH);
  digitalWrite(D0, HIGH);
  delay(1000);

  PCF_1.digitalWrite(Relay_pin1, LOW);
  digitalWrite(D0, LOW);
  delay(1000);
}

WiFiClient wifiClient;                                      // Create a WiFiClient object
WiFiUDP ntpUDP;                                             // UDP instance for NTP
NTPClient timeClient(ntpUDP, "pool.ntp.org", 25200, 60000); // Adjust the time offset for your timezone

const char *ssid = "Ar";                                              // Replace with your Wi-Fi SSID
const char *password = "87654321";                                    // Replace with your Wi-Fi password
const String apiUrl = "http://192.168.112.66:2000/api/get_all_alarms"; // Replace with your server's URL

bool alarmProcessed[5] = {false, false, false, false, false}; // Index 0 unused

// Function to get the current time from NTP
void getCurrentTime(int &hour, int &minute)
{
  timeClient.update(); // Ensure the time is up to date
  unsigned long epochTime = timeClient.getEpochTime();

  // Convert epoch time to hours and minutes
  hour = (epochTime % 86400L) / 3600; // Hours
  minute = (epochTime % 3600) / 60;   // Minutes

  Serial.printf("Current Time: %02d:%02d\n", hour, minute);
}

void controlServoForSlot(int slot)
{
  if (slot == 1)
  {
    moveServoToAngle(Servo_pin1, 0, 130, 10);
    delay(10000);
    moveServoToAngle(Servo_pin1, 130, 0, 10);
    delay(500);
  }
  else if (slot == 2)
  {
    moveServoToAngle(Servo_pin2, 130, 0, 10);
    delay(10000);
    moveServoToAngle(Servo_pin2, 0, 130, 10);
    delay(500);
  }
  else if (slot == 3)
  {
    // Add code for slot 3
    moveServoToAngle(Servo_pin3, 0, 130, 10);
    delay(10000);
    moveServoToAngle(Servo_pin3, 130, 0, 10);
    delay(500);
  }
  else if (slot == 4)
  {
    // Add code for slot 4
    moveServoToAngle(Servo_pin4, 130, 0, 10); 
    delay(10000);
    moveServoToAngle(Servo_pin4, 0, 130, 10);
    delay(500);
  }
}
void resetManualFlag(int slot)
{
  HTTPClient http;
  String updateUrl = "http://192.168.112.66:2000/api/update_alarm/" + String(slot);

  String jsonPayload = "{\"manual\": false}";

  http.begin(wifiClient, updateUrl);
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.PUT(jsonPayload);

  if (httpResponseCode > 0)
  {
    Serial.printf("Manual reset response: %d\n", httpResponseCode);
  }
  else
  {
    Serial.println("Error resetting manual flag");
  }
  http.end();
}

// bool  checkManual(JsonArray alarms)
// {
//   int currentHour, currentMinute;
//   getCurrentTime(currentHour, currentMinute);

//   // int currentTimeInMinutes = currentHour * 60 + currentMinute;

//   for (JsonObject alarm : alarms)
//   {

//     int manual = alarm["manual"];
//     int slot = alarm["slot"];
//     Serial.println(slot);
//     Serial.println(manual);
//     if (manual)
//     {
//       controlServoForSlot(slot);
//       return 1;
//     }
//     else
//     {
//       return 0;
//     }
//     // int alarmHour = alarm["hour"];
//     // int alarmMinute = alarm["min"];

//     // int alarmTimeInMinutes = alarmHour * 60 + alarmMinute;
//     // int timeDifference = currentTimeInMinutes - alarmTimeInMinutes;
//     // Serial.printf("Time Difference: %d minutes\n", timeDifference);

//     // // Check if current time is equal to or more than 5 minutes past the alarm time and not already processed
//     // // if (timeDifference <= 5 && !alarmProcessed[slot])
//     // if (((currentHour == alarmHour && (alarmMinute <= currentMinute <= alarmMinute + 15))))
//     // {
//     //   if (((currentHour == alarmHour && (alarmMinute = currentMinute )))){
//     //     alram()
//     //   }
//     //   Serial.printf("Alarm Time: %02d:%02d\n", alarmHour, alarmMinute);
//     //   Serial.printf("Current Time: %02d:%02d\n", currentHour, currentMinute);
//     //   Serial.printf("Time Difference: %d minutes\n", timeDifference);
//     //   Serial.printf("Hi Slot: %d\n", slot);
//     //   controlServoForSlot(slot);

//     //   // Check if D3 input is HIGH
//     //   //   if (digitalRead(D3) == LOW)
//     //   //   {
//     //   //     controlServoForSlot(slot);
//     //   //     alarmProcessed[slot] = true; // Mark alarm as processed
//     //   //   }
//     //   // }
//     //   // if (digitalRead(D3) == HIGH)
//     //   // {
//     //   //   digitalWrite(D0, HIGH);
//     //   // }
//     //   // else
//     //   // {
//     //   //   digitalWrite(D0, LOW);
//     //   // }
//     // }
//   }
// }

void checkAlarms(JsonArray alarms)
{
  int currentHour, currentMinute;
  getCurrentTime(currentHour, currentMinute);

  int currentTimeInMinutes = currentHour * 60 + currentMinute;

  for (JsonObject alarm : alarms)
  {
    int slot = alarm["slot"];
    int alarmHour = alarm["hour"];
    int alarmMinute = alarm["min"];

    int alarmTimeInMinutes = alarmHour * 60 + alarmMinute;
    int timeDifference = currentTimeInMinutes - alarmTimeInMinutes;
    Serial.printf("Time Difference: %d minutes\n", timeDifference);
    if ((currentHour == alarmHour && (alarmMinute == currentMinute)))
    {
      alram();
    }
    // Check if current time is equal to or more than 5 minutes past the alarm time and not already processed
    // if (timeDifference <= 5 && !alarmProcessed[slot])
    if (digitalRead(D3) == LOW)
    {
      if (((currentHour == alarmHour && (alarmMinute <= currentMinute <= alarmMinute + 15))))
      {
        if ((currentHour == alarmHour && (alarmMinute == currentMinute)))
        {
          alram();
        }

        Serial.printf("Alarm Time: %02d:%02d\n", alarmHour, alarmMinute);
        Serial.printf("Current Time: %02d:%02d\n", currentHour, currentMinute);
        Serial.printf("Time Difference: %d minutes\n", timeDifference);
        Serial.printf("Hi Slot: %d\n", slot);
        controlServoForSlot(slot);

        // Check if D3 input is HIGH
        //   if (digitalRead(D3) == LOW)
        //   {
        //     controlServoForSlot(slot);
        //     alarmProcessed[slot] = true; // Mark alarm as processed
        //   }
        // }
        // if (digitalRead(D3) == HIGH)
        // {
        //   digitalWrite(D0, HIGH);
        // }
        // else
        // {
        //   digitalWrite(D0, LOW);
        // }
      }
    }
  }
}

void setup()
{
  Serial.begin(9600);

  PCF_1.begin();
  PCF_1.pinMode(Servo_pin1, OUTPUT);
  PCF_1.pinMode(Servo_pin2, OUTPUT);
  PCF_1.pinMode(Servo_pin3, OUTPUT);
  PCF_1.pinMode(Servo_pin4, OUTPUT);
  PCF_1.pinMode(Relay_pin1, OUTPUT);

  pinMode(D0, OUTPUT);
  pinMode(D3, INPUT);

  WiFi.begin(ssid, password);

  // Connect to Wi-Fi
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi");

  // Initialize NTP Client
  timeClient.begin();
  Serial.println("NTP client initialized.");
}

void loop()
{
  if (WiFi.status() == WL_CONNECTED)
  { // Check Wi-Fi connection
    HTTPClient http;

    // Make a GET request to the API
    http.begin(wifiClient, apiUrl); // Pass the WiFiClient object
    int httpCode = http.GET();
    int M = false;
    // int httpCode
    if (httpCode > 0)
    { // Check the returning code
      Serial.printf("HTTP Response code: %d\n", httpCode);
      if (httpCode == HTTP_CODE_OK)
      {
        String payload = http.getString();
        Serial.println("Response payload:");
        Serial.println(payload);

        // Parse JSON response
        StaticJsonDocument<2048> doc; // Adjust size if needed
        DeserializationError error = deserializeJson(doc, payload);

        if (error)
        {
          Serial.print("JSON deserialization failed: ");
          Serial.println(error.f_str());
        }
        else
        {
          JsonArray alarms = doc["data"].as<JsonArray>();
          for (JsonObject alarm : alarms)
          {

            int manual = alarm["manual"];
            int slot = alarm["slot"];
            Serial.println(slot);
            Serial.println(manual);
            if (manual)
            {
              controlServoForSlot(slot);
              resetManualFlag(slot);

              M = 1;
            }
            else
            {
              M = 0;
            }

            if (M)
            {
              digitalWrite(D0, HIGH);
            }
            // if (digitalRead(D3) == LOW)
            // {
            digitalWrite(D0, HIGH);
            checkAlarms(alarms);
            // }
            // else
            // {
            //   digitalWrite(D0, LOW);
            // }
            // Check alarms against the current time
          }
        }
      }
      else
      {
        Serial.printf("HTTP GET failed: %s\n", http.errorToString(httpCode).c_str());
      }
      http.end();
    }
    else
    {
      Serial.println("Wi-Fi not connected");
    }

    delay(100); // Delay for 10 seconds before the next request
  }
}