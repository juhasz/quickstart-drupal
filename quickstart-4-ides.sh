#!/bin/bash

# Install java - ?mb
sudo apt-get -y install default-jre

# Download and install netbeans - ?mb
NETBEANS_URL="http://services.netbeans.org/bouncer/index.php?product=netbeans-6.8-ml-php&os=linux"
sudo apt-get -y install wget
cd ~/Desktop
wget -O netbeans.sh $NETBEANS_URL
chmod +x ./netbeans.sh
zenity --info --text="The Netbeans PHP installer will start now.  Accept the defaults.  Uncheck 'register' on last screen."
bash ./netbeans.sh
rm netbeans.sh
cd ~

# Download and install eclipse - About 512 mb
sudo add-apt-repository ppa:yogarine/eclipse/ubuntu && sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive aptitude -yq install eclipse eclipse-pdt eclipse-plugin-cvs eclipse-subclipse

# Install graphics editors - weights about 120mb
sudo apt-get -y install gimp

# Install graphical version control - weighs about 70mb
sudo add-apt-repository ppa:rabbitvcs/ppa && sudo apt-get update
sudo apt-get -y install rabbitvcs-nautilus
sudo killall nautilus

# FIXME
# http://wiki.netbeans.org/HowToConfigureXDebug

