#!/bin/bash

# To install Quickstart:
#
# 1) open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) Paste in these three commands: (install cvs, download from drupal.org, run install.sh)
#
# sudo aptitude -y install cvs
# cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d quickstart contributions/modules/quickstart
# bash ~/quickstart/install.sh

cd ~

bash ~/quickstart/install-1-prep.sh
bash ~/quickstart/install-2-lamp.sh
bash ~/quickstart/install-3-ide.sh
bash ~/quickstart/install-4-browsers.sh
bash ~/quickstart/install-5-devenv.sh
# manual config steps
gedit ~/quickstart/install-6-manualconfig.txt &
# documentation on use
firefox http://drupal.org/node/788080 &

