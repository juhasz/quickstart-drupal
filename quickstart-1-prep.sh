#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process.  This script shouldn't be run more than once."

## Networking fixes

# Fix bug where needed to manually dhcp network
echo "auto eth0
iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
# Fix bug with Avahi and .local - http://drupal.org/node/822542 - don't completely understand this.  This is for bridged networking?
sudo sed -i 's/.local/.alocal/g'     /etc/avahi/avahi-daemon.conf
# Restart networking
sudo /etc/init.d/networking restart



## Disk size Accounting

# Starting size:
df -h -T > ~/quickstart/quickstart-size-start.txt



## Some configuration

# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false
# auto-login
zenity --info --text="Configure auto-login.  Unlock -> 'quickstart' -> Uncheck 'play sound', select 'login as quickstart automatically', uncheck 'Allow x seconds...'"
gdmsetup



## Upgrade

# Do this here because update-manager seems to interupt apt
sudo apt-get -y update
sudo apt-get -y upgrade
