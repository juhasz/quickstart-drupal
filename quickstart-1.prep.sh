#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process.  This script shouldn't be run more than once."

# Fix bug where needed to manually dhcp network
echo "auto eth0
iface eth0 inet dhcp" | sudo tee -a /etc/network/interfaces
sudo /etc/init.d/networking restart

# Starting size:
df -h -T > ~/quickstart/quickstart-size-start.txt

