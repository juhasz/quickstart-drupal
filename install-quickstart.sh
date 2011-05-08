#!/bin/bash

# To install Quickstart Development Environment:
#
# 1) Open a terminal window in the virtual machine (Applications->Accessories->Terminal)
#
# 2) bash ~/quickstart/install-quickstart.sh


# ################################################################################ Shorten prompt and set version
echo "qs10" | sudo tee /etc/hostname


# ################################################################################ Reboot functions
function reboot {
  echo "gnome-terminal -x bash -c \"~/quickstart/install-quickstart.sh $1\" &" >> ~/.profile
  echo "*** REBOOTING ***" | tee -a ~/quickstart/quickstart-install.log
  sleep 2
  sudo reboot now
  exit
}

# Undo any previous reboot script
sed -i 's/gnome-terminal -x bash -c/# deleteme /g' ~/.profile

# ################################################################################ Install it!
# this switch statement handles reboots.
cd ~
case "$1" in
"")
  bash -x ~/quickstart/quickstart-1-prep.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  bash -x ~/quickstart/quickstart-1a-guest.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  reboot 2
  ;;
"2")
  bash -x ~/quickstart/quickstart-2-slim.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  bash -x ~/quickstart/quickstart-2a-update.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  reboot 3
  ;;
"3")
  bash -x ~/quickstart/quickstart-3-lamp.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  bash -x ~/quickstart/quickstart-4-ides.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  reboot 5
  ;;
"5")
  bash -x ~/quickstart/quickstart-5-browsers.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  bash -x ~/quickstart/quickstart-6-devenv.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  bash -x ~/quickstart/quickstart-7-config.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  reboot 8
  ;;
"8")
  bash -x ~/quickstart/quickstart-8-manualconfig.sh  2>&1 | tee -a ~/quickstart/quickstart-install.log
  ;;
*)
  echo " *** BAD BAD BAD SOMETHING WENT WRONG!  CALL A DOCTOR! *** "
  ;;
esac


