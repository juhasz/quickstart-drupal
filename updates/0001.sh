#!/bin/bash

# Update drush
cd ~/drush
git checkout master;
git pull; 
git checkout 7.x-4.3

# Update drush make
cd ~/.drush/drush_make
git checkout master;
git pull;
git checkout 6.x-2.1

