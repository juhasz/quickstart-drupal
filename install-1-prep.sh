#!/bin/bash

# get up to date
sudo aptitude update
sudo aptitude -y safe-upgrade

sudo aptitude -y install cvs subversion wget curl  # dev basics
