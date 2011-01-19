#!/bin/bash

# dev and server

# Remove unneeded packages
sudo apt-get autoremove

# Clean out downloaded packages
sudo apt-get clean

# Clean up apt cache
sudo rm /var/lib/apt/lists/*   # 44mb
sudo rm /var/lib/apt/lists/partial/*

# empty trash
sudo rm -rf ~/.local/share/Trash/files/*
sudo rm -rf ~/.local/share/Trash/info/*

# Zero-fill unused sectors on vm disk
# Zero-filled sectors compress very nice :-)  
# No need to export sectors for files that could be "undeleted"
sudo dd if=/dev/zero of=/zerofile; sudo rm /zerofile
