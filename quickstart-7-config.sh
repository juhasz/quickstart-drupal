#!/bin/bash

# Remove fancy high-falutin new 3d-glasses scrollbars.  In my day we just had arrow keys!
sudo apt-get -y remove overlay-scrollbar liboverlay-scrollbar-0.1-0

# automatic updates.  apply security.  download updates
echo "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
" | sudo tee /etc/apt/apt.conf.d/10periodic > /dev/null

# final size
df -h -T > ~/quickstart/quickstart-size-end.txt

# get rid of subversion commit keyring.  Store passwords plain on disk
sudo sed -i 's/# password-stores = gnome-keyring,kwallet/password-stores = /g' ~/.subversion/config
sudo sed -i 's/# store-plaintext-passwords = no/store-plaintext-passwords = yes/g' ~/.subversion/servers

