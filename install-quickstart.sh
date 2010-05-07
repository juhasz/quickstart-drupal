#!/bin/bash

# To install Quickstart:
#
# 1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) Paste in these three commands: (install cvs, download from drupal.org, run install.sh)
#
# sudo aptitude -y install cvs
# cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d quickstart contributions/modules/quickstart
# bash ~/quickstart/install-quickstart.sh

cd ~

bash ~/quickstart/quickstart-1-prep.sh
bash ~/quickstart/quickstart-2-slim.sh
bash ~/quickstart/quickstart-3-lamp.sh
bash ~/quickstart/quickstart-4-ides.sh
bash ~/quickstart/quickstart-5-browsers.sh
bash ~/quickstart/quickstart-6-devenv.sh
# Show manual config steps
gedit ~/quickstart/quickstart-7-manualconfig.txt &
# Show documentation on use
firefox http://drupal.org/node/788080 &

