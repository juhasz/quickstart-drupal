#!/bin/bash
# I havn't tried this, but it was recommended.  If you try it and it works, let us know!

cd ~

wget -O /tmp/key http://hudson-ci.org/debian/hudson-ci.org.key
sudo apt-key add /tmp/key

wget -O /tmp/hudson.deb http://hudson-ci.org/latest/debian/hudson.deb
sudo dpkg --install /tmp/hudson.deb

sudo apt-get install -f #this just fixes any dependencies, usually just daemon

mkdir /home/quickstart/hudson

zenity --info --text="Around line 15 change the user to: HUDSON_USER=quickstart and around line 40 change the port to HTTP_PORT=8081"

sudo gedit /etc/default/hudson

