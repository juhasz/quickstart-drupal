#!/bin/bash
# I havn't tried this, but it was recommended.  If you try it and it works, let us know!

cd ~

wget -O /tmp/key http://hudson-ci.org/debian/hudson-ci.org.key
sudo apt-key add /tmp/key

wget -O /tmp/hudson.deb http://hudson-ci.org/latest/debian/hudson.deb
sudo dpkg --install /tmp/hudson.deb

sudo apt-get install -f #this just fixes any dependencies, usually just daemon

mkdir /home/quickstart/hudson

sudo /etc/init.d/hudson stop
# ######################################### Configure

sudo sed -i 's/HUDSON_USER=hudson/HUDSON_USER=quickstart/g'     /etc/default/hudson
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8081/g'       /etc/default/hudson
sudo sed -i 's/\/var\/lib\/hudson/\/home\/quickstart\/hudson/g'       /etc/default/hudson

sudo /etc/init.d/hudson start
sleep 3s
zenity --info --text="*** Opening Husdon ***"
firefox http://localhost:8081
