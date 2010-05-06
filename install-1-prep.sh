#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process.  This script shouldn't be run more than once."

# fix bug where needed to manually dhcp network
echo "auto eth0
iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
sudo /etc/init.d/networking restart

# configure repositories for git-core, etc
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ lucid partner"

# update local cache of repository info
sudo aptitude update
sudo aptitude -y safe-upgrade

# install some dev basics
sudo aptitude -y install cvs subversion git-core bzr
sudo aptitude -y install wget curl 
