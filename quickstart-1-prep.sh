#!/bin/bash

zenity --info --text="These install scripts take several hours, and a couple automated reboots.

Towards the end, the process requires some manual steps, guided by popups like this.

This script shouldn't be run more than once."



## The last password you'll ever need.

# add to sudoers file - careful, this line could brick the box.

echo "quickstart ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

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

