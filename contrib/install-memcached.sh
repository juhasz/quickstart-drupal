#!/bin/bash

# ################################################################################ memcached

# README:
#
# This script will install memcached (a memory object caching system) on port 11211
#
HELP="

Memcached Installation complete.

Memcached is a memory object caching system.  It is running on port 11211.

To restart memcached:  sudo /etc/init.d/memcached restart

For details on using memcached with Drupal, see here: http://drupal.org/project/memcache
"

cd ~
sudo apt-get update

# Install memcached and the php5 module
sudo apt-get install -y memcached php5-memcached

# Restart Apache
sudo /etc/init.d/apache2 restart

echo "$HELP"
