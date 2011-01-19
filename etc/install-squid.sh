#!/bin/bash

# This script will install a caching proxy server between drush and ftp.drupal.org
# This saves time and bandwidth.  It's been used by many people, but I not ready
# for on-by-default yet.

# Install caching proxy server
sudo apt-get update
sudo apt-get -y install squid3

echo "http_proxy=\"http://localhost:3128\"" >> /etc/environment

echo "*** REBOOT TO TAKE EFFECT ***"
