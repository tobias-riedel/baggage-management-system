################################################################################
# author:	Tobias Riedel
# date:		2015-06-06
#
# This is the readme file that contains instructions on how to install and to
# use this software.
################################################################################

README - BAGGAGE MANAGEMENT SYSTEM (BMS)

===========
I. Contents
===========

1. Configuration
2. Installation
2.1. Used Software
2.2. Automated Installation
2.3. Manual Installation
2.3.1. Preparation
2.3.2. Install BMS
2.3.3. Uninstall
3. Usage
4. Known Issues


================
1. Configuration
================
Be sure to configure the application before doing anything else! 
To configure the web front-end and (un-)installation routine, open the file "config.cfg" with a random text editor and adjust the values.

ATTENTION: Be sure to have JavaScript activated in your browser to use the web front-end.


===============
2. Installation
===============

2.1. Used Software
------------------
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

	
2.2. Automated Installation
---------------------------
Be sure to have the configuration finished before starting the installation (see chapter 1).
For Windows and Linux there are the following (un-)installation files in the "setup" folder to use.

Windows:
- installDB.bat
- uninstallDB.bat

Linux:
- installDB
- uninstallDB

The Linux files might also work for Mac OS X, but this is untested.


2.3. Manual Installation
------------------------
If a manual installation is wanted or needed, follow these upcoming steps. Be sure to having the configuration finished before starting the installation (see chapter 1). 
	
2.3.1. Preparation
..................
After using the same database as recommended, start your MySQL server (>>). If you are using the console (>), type
> "mysqld --event-scheduler=1"
(without quotation marks) to start the server.
You can always shut the server down by typing
> "mysqladmin -u YourUsername -p YourPassword shutdown"

Change to the sql directory of the script and log on to the server.
> "cd sql"
> "mysql -uYourUsername -pYourPassword"

Replace "YourUsername" by your user name and "YourPassword" by your password. Now create a database where you want to install the BMS.
>> "CREATE DATABASE `YourDatabase`;"

Now connect to that database:
>> "USE `YourDatabase`;"

2.3.2 Install BMS
.................
After connecting to the database (step 1.2.4), just use the initilization script to install the BMS.
>> "SOURCE init.sql"

Please have patients for it can take up to five minutes to perform this action. This completes the installation.

2.3.3. Uninstall BMS
....................
To uninstall the BMS simply delete the whole database:
>> "DROP DATABASE `YourDatabase`;"

After that there only remain the files that have to be deleted and the uninstallation is done.


========
3. Usage
========
After starting the HTTP server (see recommended software) access the web front-end via browser using the URL leading to the file "index.php".

There you can use the self-explanatory buttons to interact with the BMS. Every clicked button will cause a SQL query to be used. These will be displayed in the textarea labeled "Queries". You can use these commands in the console as well.


===============
4. Known Issues
===============

Problem: In some cases the image of the web front-end does not update anymore.
Solution: Press [F5] in the browser to refresh the whole website. Though most caching issues have been resolved there is no known solution to date.

Problem: In Firefox the BMS image can flicker when being updated.
Solution: If you have Skype's "Click to Call" installed, uninstalling it might resolve the issue. Other solutions are not known, only a switch to another browser might help.