#!/bin/bash

DRUSH=7.x-4.3
DRUSH_MAKE=6.x-2.1

# Update drush
echo "Updating Drush to $DRUSH"
cd ~/drush
git checkout master 2> /dev/null;
git pull; 
git checkout $DRUSH 2> /dev/null

# Update drush make
echo "Updating Drush Make to $DRUSH_MAKE"
cd ~/.drush/drush_make
git checkout master 2> /dev/null
git pull;
git checkout $DRUSH_MAKE 2> /dev/null

