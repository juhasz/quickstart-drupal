#!/bin/bash

NETBEANS_URL="http://services.netbeans.org/bouncer/index.php?product=netbeans-6.8-ml-php&os=linux"

# install java
sudo aptitude -y install default-jre

# download and install netbeans
cd ~/Desktop
wget -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
zenity --info --text="The Netbeans PHP installer will start now.  Accept the defaults.  Uncheck 'register' on last screen."
bash ./netbeans.sh
rm netbeans.sh
cd ~

# install graphics editors - weights about 120mb
sudo aptitude -y install gimp

# install graphical version control - weighs about 70mb
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo aptitude update
sudo aptitude -y install rabbitvcs-nautilus
sudo killall nautilus

# FIXME
# http://wiki.netbeans.org/HowToConfigureXDebug

