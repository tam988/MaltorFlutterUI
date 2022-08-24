# Android Intrusion Detection System

The Android Intrusion Detection System is a mobile application on Android devices. It scan applications' APK found and displays whether the application is malicious or benign using an AI model. 

## Table of Contents
- [Getting Started](#getting-started)
- [Reqirements](#requirements)
- [Libraries and Dependencies](#libraries-and-dependencies)
    - [PHP](#php)
    - [Flutter](#flutter)
    - [Python](#python)
- [Features](#features)
- [Installation Guide](#installation-guide)
    - [Preparation](#preparation)
    - [Installation](#installation) 
- [License](#license)
- [Team](#team)



## Getting Started
This project is part of a research from the Security Engineering Lab. 

Developers can use this repository to install the application and run it on Android devices and/or emulators.

The Flutter project is responsible for the user inrterface and front-end of the application. The backend consists of PHP and Python codes that connect to the MySQL database. The PHP code is mainly responsible for searching for the desired APKs and adding them to the databse. The Python code is an API that converts the APK installed into greyscale and RGB images, scans them for security using an AI model, and sends the prediction to the PHP code.  


## Requirements:
- [Flutter](https://docs.flutter.dev/get-started/install) and ([Dart](https://dart.dev/overview)) SDK version: 2.8.1
- [Android Studio Arctic Fox](https://developer.android.com/studio) 2020.3.1 Patch 4
- [PHP](https://www.php.net/downloads) version: 8.1.1
- [Python](https://www.python.org/downloads/) version: 3.9.9
- [pip](https://pip.pypa.io/en/stable/installation/) version: 22.1 
- [Visual Studio Code](https://code.visualstudio.com/) version: 1.67.1
- [XAMPP](https://www.apachefriends.org/download.html) version: 3.2.4
- MySQL
- [Git](https://git-scm.com/) version: 2.34.1.windows.1


## Libraries and Dependencies
This is a list of all the libraries and dependencies used for this project. There are three sections outlined. One for PHP libraries, another for Flutter libraries and dependencies, and the last section for Python dependencies. 

### PHP
- cURL library
- Xpath Library

### Flutter
- http: ^0.13.3
- flutter:
   sdk: flutter
- flutter_localizations: 
   sdk: flutter         
- firebase_core: ^1.3.0
- firebase_analytics: ^8.1.2
-  firebase_auth: ^1.4.1
-  cloud_firestore: ^2.2.2
-  firebase_database: ^7.1.1
-  cupertino_icons: ^1.0.3
-  device_info: ^2.0.3
-  settings_ui: ^2.0.1
-  shared_preferences: ^2.0.12
-  provider: ^6.0.2
-  flutter_settings_screens: ^0.3.2-null-safety
-  getwidget: ^2.0.4
-  vertical_navigation_bar: ^0.0.2
-  flutter_test:
     sdk: flutter

### Python
For the python libraries, use pip in the command line to install the library to your device and be able to use it in the application. The syntax is as follows: 
```
$ pip install [name of library]
```
- os
- io 
- typing
- PIL 
- fastapi 
- prediction 
- fastapi_utils
- sqlalchemy.orm
- keras
- numpy
- sys
- math
- argparse
- queue 
- threading 
- requests
- json
- pydantic 
- uvicorn
- tensorflow 


## Features

Below are a list of the main features of the application: 
- Simple and Easy to Use Interface
- Scans security behaviour of Android applications via their names before installation
- Supports both Arabic and English Versions
- Displays Important and Relevant device information
- Displays Results of scan in an understandable view


## Installation Guide
In this Section, we explain the steps needed to install the code and the application to your local device. 

Before installing the code and application, make sure to download Android Studio with the Flutter and Dart SDK and Visual Studio Code for the Python and PHP codes. Additionally, import the required dependencies and libraries into your device. 

### Preparation 

First, clone the git repository to the local device using the following command in the command prompt. 

```
$ git clone https://github.com/tam988/IDS-SEL-Project.git
```
You can move the downloaded folder to your desired path. 

In order to use the application on a physical device, make sure your machine acts as a local server through the following steps:
1- Open XAMPP
2- In the Apache service module, click on the "Config" button and choose "Apache (httpd.conf)" option in the drop-down list
   NOTE: Make sure Apache module is turned off
   
3- This option opens a text file. In the text file, search for the keyword "directory" using Find and Replace (Ctrl+F)

4- You should search the file until you find the following block of code and change the path in DocumentRoot and Directory based on the location of the repository:
```xml
DocumentRoot "C:\path\to\code"
<Directory "C:\path\to\code">
    #
    # Possible values for the Options directive are "None", "All",
    # or any combination of:
    #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
    #
    # Note that "MultiViews" must be named *explicitly* --- "Options All"
    # doesn't give it to you.
    #
    # The Options directive is both complicated and important.  Please see
    # http://httpd.apache.org/docs/2.4/mod/core.html#options
    # for more information.
    #
    Options Indexes FollowSymLinks Includes ExecCGI

    #
    # AllowOverride controls what directives may be placed in .htaccess files.
    # It can be "All", "None", or any combination of the keywords:
    #   AllowOverride FileInfo AuthConfig Limit
    #
    AllowOverride All

    #
    # Controls who can get stuff from this server.
    #
    Require all granted
</Directory>
```
5- Save the text file

---

#### Database Configuration
Since your local device will act as the server, you need to configure the database in order for the application to function. This section explains how to import the file and configure the database. 

1- Open Xampp and start the modules for both “Apache” and “MySQL”. 

2- Click the “Admin” button for MySQL in the XAMPP dashboard. This will open the phpMyAdmin in your default browser. 

3- In the phpMyAdmin screen, click on the “Databases” 

4- Under the “Create Database” section, enter the following name: sel_api     

5- Open the newly created database and click on the “Import” tab. This opens the import page where you should add the .sql file.

6- Open the folder titled “SQL Database” after cloning the repository

7- Click and drag the .sql onto the Import page of phpMyAdmin

8- Click on “Structure” to check if the table was added 

You can find more information and detailed guide [here](https://www.cs.virginia.edu/~up3f/cs4750/supplement/DB-setup-xampp.html) 

---

### Installation

1- Before running the program, open the dart file named scan_app.dart and change the following line of code in Lines 49-53:

```dart
Future<void> _searchAppOnServer(String _appName) async {
    _app = App(id: "", name: "", sec: "", apkURL: "", accuracy: "");
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://[Desired IP Address]/apk_scraper.php'));
    request.fields.addAll({'appName': _appName});
```

As you can see in the code snippet, you can add the IP address of the machine to connect to the server. 

2- Once you add the changes to the codes, open XAMPP to run the Apache and MySQL modules and start the server. Additionally, open the file, main.py, and run the program to start the prediction model.

3- Open the Flutter project on Android Studio 

4- In the flutter terminal, write the following command to create an APK of the application:

```
$ flutter build apk --split-per-abi
```

 NOTE: You can find more information in the [Flutter Documentation](https://docs.flutter.dev/deployment/android#build-an-apk)
 
 5- [Follow these steps to install it on your Android Device](https://www.wikihow.com/Install-APK-Files-from-a-PC-on-Android)
 
 
 ## License
 
 MIT License

Copyright (c) [2022] [Tala Hesham Almashat]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
 ## Team
 
 Dr. Walid Elshafai, Eng. Tala Hesham Almashat, Lina AlBaroudi
