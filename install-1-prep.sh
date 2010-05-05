#!/bin/bash

zenity --info --text="This process requires some manual steps.  Popups like this one will give instructions to help the process."

# get up to date
sudo aptitude update
sudo aptitude -y safe-upgrade

sudo aptitude -y install cvs subversion wget curl  # dev basics
