#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process.  This script shouldn't be run more than once."

# fix bug where needed to manually dhcp network
echo "auto eth0
iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
sudo /etc/init.d/networking restart

# configure repositories for git-core, etc
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ lucid partner"

# php 5.3 doesn't work for Drupal and Aegir.  Downgrade to 5.2 from Karmic (Ubuntu 9.10).
#   set default release
echo 'APT::Default-Release "hardy";' | sudo tee -a /etc/apt/apt.conf.d/01ubuntu
#   enable Karmic repositories
echo "# needed sources for php5.2:
deb http://de.archive.ubuntu.com/ubuntu karmic main restricted
deb-src http://de.archive.ubuntu.com/ubuntu karmic main restricted

deb http://de.archive.ubuntu.com/ubuntu karmic-updates main restricted
deb-src http://de.archive.ubuntu.com/ubuntu karmic-updates main restricted

deb http://de.archive.ubuntu.com/ubuntu karmic universe
deb-src http://de.archive.ubuntu.com/ubuntu karmic universe
deb http://de.archive.ubuntu.com/ubuntu karmic-updates universe
deb-src http://de.archive.ubuntu.com/ubuntu karmic-updates universe

deb http://de.archive.ubuntu.com/ubuntu karmic multiverse
deb-src http://de.archive.ubuntu.com/ubuntu karmic multiverse
deb http://de.archive.ubuntu.com/ubuntu karmic-updates multiverse
deb-src http://de.archive.ubuntu.com/ubuntu karmic-updates multiverse

deb http://security.ubuntu.com/ubuntu karmic-security main restricted
deb-src http://security.ubuntu.com/ubuntu karmic-security main restricted
deb http://security.ubuntu.com/ubuntu karmic-security universe
deb-src http://security.ubuntu.com/ubuntu karmic-security universe
deb http://security.ubuntu.com/ubuntu karmic-security multiverse
deb-src http://security.ubuntu.com/ubuntu karmic-security multiverse
" | sudo tee -a /etc/apt/sources.list.d/karmic.list

#   "Pin" PHP to karmic repositories
PHP_PACKAGES="php5 php5-dev php5-common php5-xsl php5-curl php5-gd php5-pgsql php5-cli php5-mcrypt php5-sqlite php5-mysql libapache2-mod-php5 php-pear php5-xdebug php-apc"
echo '' | sudo tee -a /etc/apt/preferences.d/php5.2  # blank file
for i in $PHP_PACKAGES ; do echo "Package: $i
Pin: release a=karmic
Pin-Priority: 991
" | sudo tee -a /etc/apt/preferences.d/php5_2 > /dev/null; done

# update local cache of repository info
sudo aptitude update
sudo aptitude -y safe-upgrade

# install some dev basics
sudo aptitude -y install cvs subversion git-core bzr
sudo aptitude -y install wget curl 
