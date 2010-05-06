#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process."

# fix bug where needed to manually dhcp network
echo "auto eth0
iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
sudo /etc/init.d/networking restart

# configure repositories for git-core, etc
sudo add-apt-repository "deb http://archive.ubuntu.com/ lucid partner"

# php 5.3 doesn't work for Drupal and Aegir.  Downgrade to 5.2 from Karmic (Ubuntu 9.10).
#   enable Karmic repositories
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic main restricted"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic main restricted"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic-updates main restricted"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic universe"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic-updates universe"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic multiverse"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ karmic-updates multiverse"
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu/ karmic-security main restricted"
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu/ karmic-security universe"
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu/ karmic-security multiverse"
#   "Pin" PHP to karmic repositories
PHP_PACKAGES=php5 php5-dev php5-common php5-xsl php5-curl php5-gd php5-pgsql php5-cli php5-mcrypt php5-sqlite php5-mysql libapache2-mod-php5 php-pear php5-xdebug php-apc
echo ''>/etc/apt/preferences.d/php5.2  # blank file
for i in $PHP_PACKAGES ; do echo "Package: $i
Pin: release a=karmic
Pin-Priority: 991
">>/etc/apt/preferences.d/php5.2; done

# update local cache of repository info
sudo aptitude update
sudo aptitude -y safe-upgrade

# install some dev basics
sudo aptitude -y install cvs subversion git-core bzr
sudo aptitude -y install wget curl 
