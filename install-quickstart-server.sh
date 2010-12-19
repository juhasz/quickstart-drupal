#!/bin/bash

# To install Quickstart Server:
#
# 1) Install server (e.g. AMI on Amazon)
#
#    Process:  
#      http://www.ardentsoft.com/blog/2009/3/3/lamp-on-ec2-part-1-setting-up-amazon-web-services.html
#    AMI:  
#      http://developer.amazonwebservices.com/connect/entry.jspa?externalID=3101
#      US West AMI ID:  	ami-c997c68c
#        64-bit, ebs
#      Login user: ubuntu
#
# 2) Paste in these three commands: (install cvs, download from drupal.org, run install.sh)
#
# sudo apt-get -y install cvs
# cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d quickstart contributions/modules/quickstart
# bash ~/quickstart/install-quickstart-server.sh

cd ~

# bash -x ~/quickstart/quickstart-1-prep.sh
# bash -x ~/quickstart/quickstart-2-slim.sh
bash -x ~/quickstart/quickstart-3-lamp.sh
# bash -x ~/quickstart/quickstart-4-ides.sh
# bash -x ~/quickstart/quickstart-5-browsers.sh
# bash -x ~/quickstart/quickstart-6-devenv.sh
# bash -x ~/quickstart/quickstart-7-config.sh
# firefox ~/quickstart/quickstart-8-manualconfig.txt

