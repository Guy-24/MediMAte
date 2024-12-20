Certainly! Below is the **combined README** that integrates the three components of the **Medimate** project (Flutter Application, Express.js Backend, FastAPI Image Processing) along with the **ESP8266 Alarm and Servo Control System**. This comprehensive README provides an overview of all components, their features, installation instructions, and other essential details.

---

# Medimate Suite

Medimate Suite is a comprehensive collection of applications and systems designed to assist users in managing their medical appointments, reminders, health records, and more. The suite includes a Flutter mobile application, an Express.js backend for alarm management, a FastAPI service for processing medication instruction images using OpenAI's API, and an ESP8266-based Alarm and Servo Control System for IoT-based alarm management.

## Table of Contents

- [Medimate Suite](#medimate-suite)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Components](#components)
    - [1. Flutter Mobile Application](#1-flutter-mobile-application)
    - [2. Express.js Backend](#2-expressjs-backend)
    - [3. FastAPI Image Processing Service](#3-fastapi-image-processing-service)
    - [4. ESP8266 Alarm and Servo Control System](#4-esp8266-alarm-and-servo-control-system)
  - [General Information](#general-information)
    - [License](#license)
    - [Contributions](#contributions)
    - [Acknowledgements](#acknowledgements)
  - [Resources](#resources)

---

## Overview

Medimate Suite integrates multiple technologies to provide a seamless experience for managing medical-related tasks and IoT-based alarm systems:

- **Flutter Mobile Application:** A user-friendly mobile app for managing appointments, reminders, and health records.
- **Express.js Backend:** A RESTful API for alarm management using MongoDB.
- **FastAPI Image Processing Service:** An API for processing images of medication instructions and extracting information using OpenAI's API.
- **ESP8266 Alarm and Servo Control System:** An IoT-based system to manage multiple alarms and control servo motors through a web interface.

---

## Components

### 1. Flutter Mobile Application

Medimate's Flutter application offers a user-friendly interface to manage medical appointments, set reminders, and maintain health records.

#### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter Installed:** Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **Compatible IDE:** Android Studio, IntelliJ IDEA, or Visual Studio Code.

#### Installation

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/Guy-24/Medimate.git
   ```
2. **Navigate to the Flutter Project Directory:**
   ```sh
   cd Medimate/flutter_app
   ```
3. **Install Dependencies:**
   ```sh
   flutter pub get
   ```

#### Running the Application

To run the application on an emulator or physical device, use the following command:

```sh
flutter run
```

#### Features

- **Alarm Notifications:** Set and receive notifications for alarms using the `awesome_notifications` package.
- **Dark Theme:** Enhanced user experience with a dark theme option.
- **User-friendly Interface:** Intuitive navigation with essential functionalities easily accessible.

#### Project Structure

- `lib/main.dart`: The main entry point of the application.
- `lib/screen/home.dart`: The home screen of the application.
- `lib/model/data.dart`: Data models used in the application.

---

### 2. Express.js Backend

The Express.js backend manages alarm data, providing a RESTful API to interact with the Flutter application.

#### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Node.js and npm Installed:** Follow the official [Node.js installation guide](https://nodejs.org/en/download/).

#### Installation

1. **Navigate to the Backend Project Directory:**
   ```sh
   cd Medimate/express_backend
   ```
2. **Install Dependencies:**
   ```sh
   npm install
   ```

#### Running the Application

To run the application, use the following command:

```sh
node index.js
```

#### Features

- **Alarm Management:** Add, update, and fetch alarm data.
- **MongoDB Integration:** Stores alarm data using MongoDB.
- **REST API:** Provides endpoints for interacting with alarm data.

#### API Endpoints

- **POST `/api/add_alarm`:** Add a new alarm.
- **GET `/api/get_all_alarms`:** Fetch all alarms.
- **GET `/api/get_alarm/:id`:** Fetch a specific alarm by ID.
- **PUT `/api/update_alarm/:slot`:** Update an alarm by slot.

#### Project Structure

- `index.js`: The main entry point of the application.
- `models/alarm.js`: Mongoose schema for alarm data.

---

### 3. FastAPI Image Processing Service

The FastAPI service processes images of medication instructions and extracts relevant information using OpenAI's API.

#### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Python 3.7 or Higher Installed.**
- **OpenAI API Key.**

#### Installation

1. **Navigate to the FastAPI Project Directory:**
   ```sh
   cd Medimate/fastapi_service
   ```
2. **Install Dependencies:**
   ```sh
   pip install -r requirements.txt
   ```

#### Setting Up OpenAI API Key

Set your OpenAI API key in the environment variable `OPENAI_API_KEY`:

```sh
export OPENAI_API_KEY='your_openai_api_key'
```

#### Running the Application

To run the application, use the following command:

```sh
uvicorn main:app --reload
```

#### API Endpoints

- **POST `/process-image/`:** Upload an image of medication instructions. The endpoint processes the image and returns the extracted information in JSON format.

#### Project Structure

- `main.py`: The main entry point of the application.
- `requirements.txt`: The dependencies required for the project.

#### Usage

1. **Start the Application.**
2. **Use a Tool Like Postman or `curl` to Upload an Image to the `/process-image/` Endpoint.**
3. **The Application Will Return the Extracted Information in JSON Format.**

#### Example

```sh
curl -X POST "http://127.0.0.1:8000/process-image/" -F "file=@path_to_your_image.jpg"
```

---

### 4. ESP8266 Alarm and Servo Control System

The **ESP8266 Alarm and Servo Control System** is an IoT-based project designed to manage multiple alarms and control servo motors through a web interface. Utilizing the ESP8266 Wi-Fi module, PCF8574 I/O expander, and servos, this system allows for remote alarm management and precise control of servo-operated devices.

#### Overview

The system connects to a local Wi-Fi network to communicate with a server, fetch alarm data, and control servo motors based on alarm schedules. It also provides visual indicators and relay controls for alarm status.

#### Features

- **Wi-Fi Connectivity:** Connects to a local Wi-Fi network to communicate with a server.
- **HTTP Communication:** Fetches alarm data and updates alarm statuses via HTTP requests.
- **Servo Control:** Precisely controls up to four servo motors based on alarm schedules.
- **Alarm Indication:** Activates a relay and indicator LED when alarms are triggered.
- **NTP Time Synchronization:** Ensures accurate timing using Network Time Protocol (NTP).
- **I/O Expansion:** Utilizes the PCF8574 I/O expander for additional GPIO pins.

#### Hardware Components

- **ESP8266 Module:** Microcontroller with built-in Wi-Fi capabilities.
- **PCF8574 I/O Expander:** Provides additional GPIO pins via I2C.
- **Servo Motors:** Four standard 180-degree servos for mechanical control.
- **Relay Module:** Controls high-power devices or indicators.
- **LEDs:** Visual indicators for alarm status.
- **Breadboard and Jumper Wires:** For prototyping and connections.
- **Power Supply:** Appropriate power source for ESP8266 and peripherals.

#### Software Dependencies

Ensure the following libraries are installed in your Arduino IDE:

- [Wire](https://www.arduino.cc/en/Reference/Wire) (included with Arduino)
- [PCF8574](https://github.com/Nayanee/PCF8574) by Nayanee
- [ESP8266WiFi](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WiFi) (included with ESP8266 board package)
- [ESP8266HTTPClient](https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266HTTPClient) (included with ESP8266 board package)
- [ArduinoJson](https://arduinojson.org/) by Benoit Blanchon
- [NTPClient](https://github.com/arduino-libraries/NTPClient) by Fabrice Weinberg
- [WiFiUdp](https://github.com/esp8266/Arduino/tree/master/libraries/WiFiUdp) (included with ESP8266 board package)

#### Wiring Diagram

![Wiring Diagram](https://via.placeholder.com/600x400)

**Connections:**

- **PCF8574 I/O Expander:**
  - **VCC**: Connect to 3.3V on ESP8266
  - **GND**: Connect to GND on ESP8266
  - **SDA**: Connect to D2 (GPIO4) on ESP8266
  - **SCL**: Connect to D1 (GPIO5) on ESP8266

- **Servos:**
  - **Servo 1**: Connect to P0 on PCF8574
  - **Servo 2**: Connect to P1 on PCF8574
  - **Servo 3**: Connect to P2 on PCF8574
  - **Servo 4**: Connect to P3 on PCF8574

- **Relay Module:**
  - **Control Pin**: Connect to P4 on PCF8574
  - **VCC**: Connect to 5V (ensure relay module supports 3.3V logic or use level shifting)
  - **GND**: Connect to GND

- **Indicators and Other Connections:**
  - **D0 (LED Indicator)**: Connect to an LED with appropriate resistor
  - **D3 (Input Pin)**: Connect to a button or sensor as needed

#### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/esp8266-alarm-servo-control.git
   ```

2. **Open in Arduino IDE:**

   - Launch the Arduino IDE.
   - Open the cloned `.ino` file.

3. **Install Required Libraries:**

   - Navigate to **Sketch > Include Library > Manage Libraries**.
   - Search for and install the following:
     - `PCF8574` by Nayanee
     - `ArduinoJson` by Benoit Blanchon
     - `NTPClient` by Fabrice Weinberg

4. **Select the ESP8266 Board:**

   - Go to **Tools > Board > Boards Manager**.
   - Search for `ESP8266` and install the latest version.
   - Select your specific ESP8266 board (e.g., NodeMCU 1.0).

#### Configuration

1. **Wi-Fi Credentials:**

   - Open the `.ino` file.
   - Locate the following lines and replace with your Wi-Fi SSID and password:

     ```cpp
     const char *ssid = "Your_SSID";          // Replace with your Wi-Fi SSID
     const char *password = "Your_Password";  // Replace with your Wi-Fi password
     ```

2. **Server URL:**

   - Update the `apiUrl` with your server's endpoint:

     ```cpp
     const String apiUrl = "http://yourserverip:port/api/get_all_alarms";
     ```

3. **NTP Timezone Offset:**

   - Adjust the `NTPClient` time offset as per your timezone (in seconds). For example, GMT+7 is `25200` seconds.

     ```cpp
     NTPClient timeClient(ntpUDP, "pool.ntp.org", 25200, 60000); // Adjust for your timezone
     ```

4. **Servo Angles and Slots:**

   - The default angles and behavior for each slot are defined in the `controlServoForSlot` function. Modify as needed for your application.

#### Usage

1. **Upload the Code:**

   - Connect your ESP8266 to your computer via USB.
   - Select the correct port in the Arduino IDE under **Tools > Port**.
   - Click the **Upload** button.

2. **Monitor Serial Output:**

   - Open the Serial Monitor (**Tools > Serial Monitor**) and set the baud rate to `9600`.
   - Observe connection status, HTTP requests, and servo actions.

3. **Interacting with the System:**

   - The system fetches alarms from the specified server and triggers servos and alarms based on the received data.
   - Manual alarms can be reset via HTTP PUT requests to the server.

#### Code Structure

##### Libraries and Definitions

```cpp
#include <Wire.h>
#include "PCF8574.h"
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

// Initialize PCF8574 I/O Expander
PCF8574 PCF_1(0x20);

// Define Servo and Relay Pins
const int Servo_pin1 = P0;
const int Servo_pin2 = P1;
const int Servo_pin3 = P2;
const int Servo_pin4 = P3;
const int Relay_pin1 = P4;
```

##### Servo Control Functions

- **writeServoPulse:** Sends a pulse to the servo.
- **setServoAngle:** Maps an angle to pulse width.
- **moveServoToAngle:** Gradually moves servo to target angle.

##### Alarm Functions

- **alarm():** Activates the relay and LED as an alarm indicator.
- **getCurrentTime():** Retrieves current time from NTP.
- **controlServoForSlot():** Controls servo based on alarm slot.
- **resetManualFlag():** Resets the manual flag for an alarm.
- **checkAlarms():** Checks and processes alarms based on current time.

##### Setup and Loop

- **setup():** Initializes serial communication, I/O expander, Wi-Fi connection, and NTP client.
- **loop():** Continuously fetches alarm data from the server, processes alarms, and controls servos and indicators.

---

## General Information

### License

This project is licensed under the [MIT License](LICENSE).

5. **Open a Pull Request**

### Acknowledgements

- **Flutter:** [flutter.dev](https://flutter.dev/)
- **Express.js:** [expressjs.com](https://expressjs.com/)
- **FastAPI:** [fastapi.tiangolo.com](https://fastapi.tiangolo.com/)
- **Mongoose:** [mongoosejs.com](https://mongoosejs.com/)
- **MongoDB:** [mongodb.com](https://www.mongodb.com/)
- **OpenAI:** [openai.com](https://openai.com/)
- **Awesome Notifications:** [pub.dev/packages/awesome_notifications](https://pub.dev/packages/awesome_notifications)
- **Uvicorn:** [uvicorn.org](https://www.uvicorn.org/)
- **ESP8266:** [esp8266.com](https://esp8266.com/)
- **PCF8574:** [PCF8574 GitHub](https://github.com/Nayanee/PCF8574)
- **ArduinoJson:** [arduinojson.org](https://arduinojson.org/)
- **NTPClient:** [NTPClient GitHub](https://github.com/arduino-libraries/NTPClient)

---

## Resources

For more resources and help getting started with each technology, refer to the official documentation:

- **Flutter Documentation:** [docs.flutter.dev](https://docs.flutter.dev/)
- **Express.js Documentation:** [expressjs.com](https://expressjs.com/)
- **FastAPI Documentation:** [fastapi.tiangolo.com](https://fastapi.tiangolo.com/)
- **MongoDB Documentation:** [mongodb.com/docs](https://www.mongodb.com/docs/)
- **OpenAI API Documentation:** [beta.openai.com/docs](https://beta.openai.com/docs/)
- **Uvicorn Documentation:** [uvicorn.org](https://www.uvicorn.org/)
- **ESP8266 Documentation:** [esp8266.com](https://esp8266.com/)
- **PCF8574 Library:** [PCF8574 GitHub](https://github.com/Nayanee/PCF8574)
- **ArduinoJson Documentation:** [arduinojson.org](https://arduinojson.org/)
- **NTPClient Documentation:** [NTPClient GitHub](https://github.com/arduino-libraries/NTPClient)

---

*Developed with ❤️ by [Guy-24](https://github.com/Guy-24)*

---

Feel free to modify or extend this README as needed for your project.
