#!/bin/bash

# ################################################################################ Hudson

# README:
#
# This script will install Hudson (a continious integration server) on port 8081
#
HELP="

Hudson Installation complete.

Hudson is a continious integration server.  Hudson is running on port 8081.

To restart Hudson:  sudo /etc/init.d/hudson restart

To admin Hudson: http://localhost:8081/

For details on using Hudson with Drupal, see here: http://groups.drupal.org/node/96289
"

cd ~
sudo apt-get update

# Get the package signer key
wget -O /tmp/key http://hudson-ci.org/debian/hudson-ci.org.key
sudo apt-key add /tmp/key

# Get the package and install
wget -O /tmp/hudson.deb http://hudson-ci.org/latest/debian/hudson.deb
sudo dpkg --install /tmp/hudson.deb

# Fix any dependencies
sudo apt-get -y install -f 

# Configure
sudo /etc/init.d/hudson stop
sudo sed -i 's/HUDSON_USER=hudson/HUDSON_USER=quickstart/g'           /etc/default/hudson
sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=8081/g'                       /etc/default/hudson
mkdir /home/quickstart/hudson
sudo sed -i 's/\/var\/lib\/hudson/\/home\/quickstart\/hudson/g'       /etc/default/hudson
sudo /etc/init.d/hudson start

echo "$HELP"
