#!/bin/bash

# To install Quickstart Development Environment:
#
# 1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) Paste in these three commands: (install cvs, download from drupal.org, run install.sh)
#
# sudo aptitude -y install cvs
# cvs -z6 -d:pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib checkout -d quickstart contributions/modules/quickstart
# bash ~/quickstart/install-quickstart.sh

cd ~

bash -x ~/quickstart/quickstart-1-prep.sh
bash -x ~/quickstart/quickstart-2-slim.sh
bash -x ~/quickstart/quickstart-3-lamp.sh
bash -x ~/quickstart/quickstart-4-ides.sh
bash -x ~/quickstart/quickstart-5-browsers.sh
bash -x ~/quickstart/quickstart-6-devenv.sh
bash -x ~/quickstart/quickstart-7-config.sh
firefox ~/quickstart/quickstart-8-manualconfig.txt

