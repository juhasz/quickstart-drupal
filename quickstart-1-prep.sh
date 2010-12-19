#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process.  This script shouldn't be run more than once."


## Upgrade

# Do this here because update-manager seems to interupt apt
sudo apt-get -y update
sudo apt-get -y upgrade

# Install virtual kernel.  Better performance.
# Removed for 10.10 - http://bugs.launchpad.net/ubuntu/+source/linux/+bug/69224
#sudo apt-get -y install linux-virtual linux-headers-virtual 

# Install guest additions - dkms recommended on virtualbox.org for upgrade compatibility
sudo apt-get -y install build-essential linux-headers-$(uname -r)
sudo apt-get -y install dkms
sudo apt-get -y install virtualbox-ose-guest-x11


## Networking fixes
# Removed for 10.10 - not a problem anymore - DELETEME FIXME

# Fix bug where needed to manually dhcp network
#echo "auto eth0
#iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
# Fix bug with Avahi and .local - http://drupal.org/node/822542 - don't completely understand this.  This is for bridged networking?
#sudo sed -i 's/.local/.alocal/g'     /etc/avahi/avahi-daemon.conf
# Restart networking
#sudo /etc/init.d/networking restart


## Disk size Accounting

# Starting size:
df -h -T > ~/quickstart/quickstart-size-start.txt


## Some configuration

# turn off screen saver
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type=bool false

# turn off sounds - first 2 are event sounds (bongos).  last is login sound (hummm) - brutish but works.
gconftool-2 -s /apps/gdm/simple-greeter/settings-manager-plugins/sound/active --type=bool false
gconftool-2 -s /gnome/sound/event_sounds --type=bool false
sudo mv /usr/share/gnome/autostart/libcanberra-login-sound.desktop /usr/share/gnome/autostart/libcanberra-login-sound.desktop.old

