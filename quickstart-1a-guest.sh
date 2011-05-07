#!/bin/bash

## install guest additions 
echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee -a /etc/apt/sources.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# Install virtual kernel.  Better performance.
# Removed for 10.10 - http://bugs.launchpad.net/ubuntu/+source/linux/+bug/69224
#sudo apt-get -yq install linux-virtual linux-headers-virtual 

# dkms recommended on virtualbox.org for upgrade compatibility
sudo apt-get -yq install build-essential linux-headers-$(uname -r)
sudo apt-get -yq install dkms
sudo apt-get -yq install virtualbox-ose-guest-x11

## Shared folders

# Setup shared folders between virtualbox host and virtualbox guest
# Note difference between shared and vbox-shared.  That's important.  Requires reboot
sudo sed -i 's/# By default this script does nothing./mount -t vboxsf -o uid=1000,gid=1000 shared \/mnt\/vbox-shared/g'     /etc/rc.local
sudo mkdir /mnt/vbox-shared
sudo chmod 777 /mnt/vbox-shared
cat > /mnt/vbox-shared/readme.txt <<END
If you are seeing this file, then virtualbox's shared folders are not configured correctly.

1) Power down the Quickstart virtual machine.
2) On the host computer, start the Virtualbox management UI.
3) right-click Quickstart -> settings -> shared folders -> click the folder with the green plus on the right
4) Set the "Folder Path" to a path on the host computer.  Give full read/write access.
5) Set the "Folder Name" to "shared".  no caps.  no vbox-
6) Ok -> Ok -> start Quickstart vm and this file should disappear.  
7) Test by moving a file in the host computer into the host shared folder.
END

