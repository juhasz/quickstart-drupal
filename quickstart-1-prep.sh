#!/bin/bash

# TODO: find better solution for user promting, zenity is a gnome GUI tool, not enough flexible. 
#zenity --info --text="These install scripts take several hours, and a couple automated reboots.
#Towards the end, the process requires some manual steps, guided by popups like this.
#This script shouldn't be run more than once."



## The last password you'll ever need.

# add to sudoers file - careful, this line could brick the box.
# TODO: make this configurable.
echo "quickstart ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

## Disk size Accounting

# Starting size:
df -h -T > ~/quickstart/quickstart-size-start.txt


## Some configuration
# TODO: make this configurable.
