#!/bin/bash

# This script will install a caching proxy server between drush and ftp.drupal.org
# This saves time and bandwidth.  It's been used by many people, but I not ready
# for on-by-default yet.

cd ~
sudo apt-get update

# Install caching proxy server
sudo apt-get -y install squid3

echo "http_proxy=\"http://localhost:3128\"" | sudo tee -a /etc/environment > /dev/null

echo "*** REBOOT TO TAKE EFFECT ***"
