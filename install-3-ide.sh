#!/bin/bash

# install java
sudo aptitude -y install default-jre

# download and install netbeans
cd ~/Desktop
wget "http://services.netbeans.org/bouncer/index.php?product=netbeans-6.8-ml-php&os=linux"
chmod +x ./netbeans-6.8-ml-php-linux.sh
# MESSAGE: Accept defaults
bash ./netbeans-6.8-ml-php-linux.sh
rm netbeans-6.8-ml-php-linux.sh
cd ~

# install graphics editors
sudo aptitude -y install inkscape gimp

# install graphical version control
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo aptitude update
sudo aptitude -y install rabbitvcs-nautilus
sudo killall nautilus

# FIXME
# http://wiki.netbeans.org/HowToConfigureXDebug

