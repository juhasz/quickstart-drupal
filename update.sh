cd ~/quickstart

QUICKSTART=master
DRUSH=7.x-4.4
DRUSH_MAKE=6.x-2.2

# Update Quickstart.  Master is always tag of latest version
echo "Updating Quickstart"
git checkout $QUICKSTART 2> /dev/null;

# Update drush
echo "Updating Drush to $DRUSH"
cd ~/drush
git checkout $DRUSH 2> /dev/null

# Update drush make
echo "Updating Drush Make to $DRUSH_MAKE"
cd ~/.drush/drush_make
git checkout $DRUSH_MAKE 2> /dev/null

