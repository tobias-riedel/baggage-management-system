# README - BAGGAGE MANAGEMENT SYSTEM (BMS)

Author: Tobias Riedel
Date: 2015-06-06

This is the readme file that contains instructions on how to install and to
use this software.

## Contents

- [README - BAGGAGE MANAGEMENT SYSTEM (BMS)](#readme---baggage-management-system-bms)
  - [Contents](#contents)
  - [Configuration](#configuration)
  - [Installation](#installation)
    - [Used Software](#used-software)
    - [Automated Installation](#automated-installation)
    - [Manual Installation](#manual-installation)
      - [Preparation](#preparation)
      - [Install BMS](#install-bms)
      - [Uninstall BMS](#uninstall-bms)
  - [Usage](#usage)
  - [Known Issues](#known-issues)

## Configuration

Be sure to configure the application before doing anything else!
To configure the web front-end and (un-)installation routine, open the file "config.cfg" with a random text editor and adjust the values.

ATTENTION: Be sure to have JavaScript activated in your browser to use the web front-end.

## Installation

### Used Software

This BMS was created and tested using the following software. It is recommended to use these as well.

- Operating Systems
  - Windows 8.1 Professional 64 Bit
  - Linux Mint 17.1 64 Bit
- Server software:
  - Apache 2.4.10 (Win32)
  - MySQL 5.6.20
  - PHP 5.5.15
- Browser software:
  - Firefox 38.0.5
  - Chrome 43.0.2357.81 m
  - Internet Explorer 11.0.9600.17801
- Client software:
  - jQuery 2.1.4
  - jQuery: UI Plugin 1.11.4
  - jQuery: qTip² Plugin 2.2.1
  - phpMyAdmin 4.2.7.1

### Automated Installation

Be sure to have the configuration finished before starting the installation (see chapter "Configuration").
For Windows and Linux there are the following (un-)installation files in the "setup" folder to use.

Windows:

- installDB.bat
- uninstallDB.bat

Linux:

- installDB
- uninstallDB

The Linux files might also work for Mac OS X, but this is untested.

### Manual Installation

If a manual installation is wanted or needed, follow these upcoming steps. Be sure to having the configuration finished before starting the installation (see chapter "Configuration").

#### Preparation

After using the same database as recommended, start your MySQL server. If you are using the console (>), type

```sh
mysqld --event-scheduler=1
```

to start the server.

You can always shut the server down by typing:

```sh
mysqladmin -u YourUsername -p YourPassword shutdown
```

Change to the sql directory of the script and log on to the server.

```sh
cd sql
mysql -uYourUsername -pYourPassword
```

Replace "YourUsername" by your user name and "YourPassword" by your password. Now create a database where you want to install the BMS.

```sql
CREATE DATABASE `YourDatabase`;
```

Now connect to that database:

```sql
USE `YourDatabase`;
```

#### Install BMS

After connecting to the database (step 1.2.4), just use the initilization script to install the BMS.

```sql
SOURCE init.sql;
```

Please have patience for it can take up to five minutes to perform this action. This completes the installation.

#### Uninstall BMS

To uninstall the BMS simply delete the whole database:

```sql
DROP DATABASE `YourDatabase`;
```

After that there only remain the files that have to be deleted and the uninstallation is done.

## Usage

After starting the HTTP server (see recommended software) access the web front-end via browser using the URL leading to the file "index.php".

There you can use the self-explanatory buttons to interact with the BMS. Every clicked button will cause a SQL query to be used. These will be displayed in the textarea labeled "Queries". You can use these commands in the console as well.

## Known Issues

**Problem:** Big parts of the front-end are missing.\
**Solution:** Enable "HD" extionsion in **php.ini**. For that Open the **php.ini** of your Apache server and check if the entry `extension=gd` is commented or not. If it is commented out by a leading semicolon (;), remove that semicolon and restart the server. Then refresh your browser.

**Problem:** In some cases the image of the web front-end does not update anymore.\
**Solution:** Press [F5] in the browser to refresh the whole website. Though most caching issues have been resolved there is no known solution to date.

**Problem:** In Firefox the BMS image can flicker when being updated.\
**Solution:** If you have Skype's "Click to Call" installed, uninstalling it might resolve the issue. Other solutions are not known, only a switch to another browser might help.
