#!/bin/bash

# To install Quickstart Development Environment:
#
# 1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) Paste in these three commands: (install cvs, download from drupal.org, run install.sh)
#
# sudo apt-get -y install cvs
# cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d quickstart contributions/modules/quickstart
# bash ~/quickstart/install-quickstart.sh


# Undo reboot script

sudo sed -i 's/bash -x ~\/quickstart\/install-quickstart-postreboot.sh/# quickstart was here/g' ~/.profile

cd ~

bash -x ~/quickstart/quickstart-5-browsers.sh
bash -x ~/quickstart/quickstart-6-devenv.sh
bash -x ~/quickstart/quickstart-7-config.sh
firefox ~/quickstart/quickstart-8-manualconfig.txt
