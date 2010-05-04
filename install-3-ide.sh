#!/bin/bash

# install java
sudo aptitude -y install default-jre

# download and install netbeans
cd ~/Desktop
wget -O netbeans.sh "http://services.netbeans.org/bouncer/index.php?product=netbeans-6.8-ml-php&os=linux"
chmod +x ./netbeans.sh
# MESSAGE: Accept defaults
bash ./netbeans.sh
rm netbeans.sh
cd ~

# install graphics editors - Nice idea, but weights about 200mb
#sudo aptitude -y install inkscape gimp

# install graphical version control - weighs about 70mb
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo aptitude update
sudo aptitude -y install rabbitvcs-nautilus
sudo killall nautilus

# FIXME
# http://wiki.netbeans.org/HowToConfigureXDebug

