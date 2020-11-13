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
So, let's create an administrator bot answering the questions of the Father of Bots
![](https://github.com/SergeyMi37/appmsw-telestat/blob/main/doc/appmsw-tele.png)


Open IRIS terminal:

```

USER>
USER>zpm
zpm:USER>install appmsw-telestat
```




