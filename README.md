Sure! Below is a combined README file that integrates the three separate README drafts for the **Medimate** project, encompassing the Flutter application, Express.js backend, and FastAPI image processing components.

---

# Medimate

Medimate is a comprehensive application suite designed to help users manage their medical appointments, reminders, and health records. It consists of a Flutter mobile application, an Express.js backend for alarm management, and a FastAPI service for processing medication instruction images using OpenAI's API.

## Table of Contents

- [Medimate](#medimate)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Components](#components)
    - [1. Flutter Application](#1-flutter-application)
      - [Prerequisites](#prerequisites)
      - [Installation](#installation)
      - [Running the Application](#running-the-application)
      - [Features](#features)
      - [Project Structure](#project-structure)
    - [2. Express.js Backend](#2-expressjs-backend)
      - [Prerequisites](#prerequisites-1)
      - [Installation](#installation-1)
      - [Running the Application](#running-the-application-1)
      - [Features](#features-1)
      - [API Endpoints](#api-endpoints)
      - [Project Structure](#project-structure-1)
    - [3. FastAPI Image Processing](#3-fastapi-image-processing)
      - [Prerequisites](#prerequisites-2)
      - [Installation](#installation-2)
      - [Setting Up OpenAI API Key](#setting-up-openai-api-key)
      - [Running the Application](#running-the-application-2)
      - [API Endpoints](#api-endpoints-1)
      - [Project Structure](#project-structure-2)
      - [Usage](#usage)
      - [Example](#example)
  - [General Information](#general-information)
    - [License](#license)
    - [Contributions](#contributions)
    - [Acknowledgements](#acknowledgements)
  - [Resources](#resources)

---

## Overview

Medimate integrates multiple technologies to provide a seamless experience for managing medical-related tasks:

- **Flutter Application:** A mobile app for managing appointments, reminders, and health records.
- **Express.js Backend:** A RESTful API for alarm management using MongoDB.
- **FastAPI Service:** An API for processing images of medication instructions and extracting information using OpenAI's API.

---

## Components

### 1. Flutter Application

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
   cd Medimate/
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

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/Guy-24/Medimate.git
   ```
2. **Navigate to the Backend Project Directory:**
   ```sh
   cd Medimate/
   ```
3. **Install Dependencies:**
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

### 3. FastAPI Image Processing

The FastAPI service processes images of medication instructions and extracts relevant information using OpenAI's API.

#### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Python 3.7 or Higher Installed.**
- **OpenAI API Key.**

#### Installation

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/Guy-24/Medimate.git
   ```
2. **Navigate to the FastAPI Project Directory:**
   ```sh
   cd Medimate/
   ```
3. **Install Dependencies:**
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
python API.py
```

#### API Endpoints

- **POST `/process-image/`:** Upload an image of medication instructions. The endpoint processes the image and returns the extracted information in JSON format.

#### Project Structure

- `API.py`: The main entry point of the application.
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

## General Information

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Contributions

Contributions are welcome! Please open an issue or submit a pull request for any changes or additions.

### Acknowledgements

- **Flutter:** [flutter.dev](https://flutter.dev/)
- **Express.js:** [expressjs.com](https://expressjs.com/)
- **FastAPI:** [fastapi.tiangolo.com](https://fastapi.tiangolo.com/)
- **Mongoose:** [mongoosejs.com](https://mongoosejs.com/)
- **MongoDB:** [mongodb.com](https://www.mongodb.com/)
- **OpenAI:** [openai.com](https://openai.com/)
- **Awesome Notifications:** [pub.dev/packages/awesome_notifications](https://pub.dev/packages/awesome_notifications)
- **Uvicorn:** [uvicorn.org](https://www.uvicorn.org/)

---

## Resources

For more resources and help getting started with each technology, refer to the official documentation:

- **Flutter Documentation:** [docs.flutter.dev](https://docs.flutter.dev/)
- **Express.js Documentation:** [expressjs.com](https://expressjs.com/)
- **FastAPI Documentation:** [fastapi.tiangolo.com](https://fastapi.tiangolo.com/)
- **MongoDB Documentation:** [mongodb.com/docs](https://www.mongodb.com/docs/)
- **OpenAI API Documentation:** [beta.openai.com/docs](https://beta.openai.com/docs/)
- **Uvicorn Documentation:** [uvicorn.org](https://www.uvicorn.org/)

---

Feel free to modify or extend this README as needed for your project.
