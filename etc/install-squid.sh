#!/bin/bash

# This script will install a caching proxy server between drush and ftp.drupal.org
# This saves time and bandwidth.  It's been used by many people, but I not ready
# for on-by-default yet.

# Install caching proxy server
sudo apt-get -y install squid3

# Configure Ubuntu to use proxy
sudo iptables -t nat -F # clear table

# normal transparent proxy
sudo iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 80 -j
REDIRECT --to-port 3127

# handle connections on the same box (SQUIDIP is a loopback instance)
GID=`id -g proxy`
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner
$GID -j ACCEPT
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT
--to-destination 127.0.0.1:3127

# Configure proxy to only cache files.drupal.org
sudo cp /etc/squid3/squid.conf /etc/squid3/squid.conf.old
echo "
### Quickstart settings

# servers to cache
acl drushservers dstdomain ftp.drupal.org

# Tell squid to enter "intercept" mode:
http_port 3127 intercept

# only cache those servers
# cache deny all
cache allow drushservers

# turn on for everybody
http_access allow all
#htcp_access allow localhost
#icp_access allow localhost
" | sudo tee /etc/squid3/squid.conf > /dev/null

sudo /etc/init.d/squid3 restart

