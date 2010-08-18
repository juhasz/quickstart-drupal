#!/bin/bash

# Database home page can be found here at http://<ip>:8080/apex  username: system

echo "deb http://oss.oracle.com/debian unstable main non-free" | sudo tee -a /etc/apt/sources.list
wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle -O- | sudo apt-key add - 
sudo apt-get update
sudo apt-get install oracle-xe
sudo /etc/init.d/oracle-xe configure
