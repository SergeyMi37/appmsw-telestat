![](https://github.com/SergeyMi37/appmsw-telestat/blob/main/doc/appmsw-tele.png)
## appmsw-telestat
[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/appmsw-telestat-1)

Ineroperability manages a Telegram Admin_bot and Informant_bot in providing content.

Telestat solution based on project
https://github.com/intersystems-community/TelegramAlerts

During the installation and configuration process, we will create an informant bot and an admin bot, which will allow the informant bot to provide users with the requested content.

## Installation with ZPM

zpm:USER>install appmsw-telestat

## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/appmsw-telestat.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
$ docker-compose exec iris iris session iris
```

## Before starting the installation

If you do not have a Telegram messenger account, then this is just a reason to create it.
So, let's create an administrator bot answering the questions of the BotsFather.

![](https://github.com/SergeyMi37/appmsw-telestat/blob/main/doc/Screenshot_1.png)

Then we will create an informant bot and save their names and tokens to enter when installing the module using the package manager.

### Open IRIS terminal:

```
USER>
USER>zpm
zpm:USER>install appmsw-telestat

[appmsw-telestat]       Module object refreshed.
[appmsw-telestat]       Validate START
[appmsw-telestat]       Validate SUCCESS
[appmsw-telestat]       Compile START
[appmsw-telestat]       Compile SUCCESS
[appmsw-telestat]       Activate START
[appmsw-telestat]       Configure START
Shall we enter names and tokens ? [y,n] <y> y

Enter the username of the admin bot IrisContestAdminInformerbot 
Enter the token to access of the admin bot 794:AAGjZjag9Yr6LzYVbRESIBqk3HIbc 
Enter the number phone of the admin bot 77777777 [7777777]
Enter the username of the informer bot IrisContestInformerbot [IrisContestInformerbot]
Enter the token to access of the informer bot sY5NxkS0QXRXdjxmbrIWJWLOA 

If you make a mistake, or BotFather changed the token, you can always retry later by performing a utility ##class(appmsw.telestat.API.util).Init()
Product items changed successfully

[appmsw-telestat]       Configure SUCCESS
[appmsw-telestat]       Activate SUCCESS
```
After that, we will open the product and launch it.

![](https://github.com/SergeyMi37/appmsw-telestat/blob/main/doc/Screenshot_7.png)

Find the created admin bot in Telegram, connect to it and execute the command /start

And we will show him our phone number. Exactly the one that we entered during the installation.

If all is well, we will receive a message:
Your number has been successfully accepted OK
 
otherwise:
Your number is not included in the allowed table. Check the correctness of the initial data

Now ChatId is attached to the administrator's phone.
You can test notifications to the Admin bot with a command in the terminal

user>zwrite ##class(appmsw.telestat.API.service).ToAdmin("Contest")


