#!/bin/bash

# clean out downloaded packages
gksudo aptitude clean

# clean up apt cache
sudo rm /var/lib/apt/lists/*   # 44mb -> 12mb compressed

# zero-fill unused sectors on vm disk.  This excludes the sectors from export.  
# Otherwise we are exporting unused sectors for files that could be "undeleted"
sudo dd if=/dev/zero of=/zerofile; sudo rm /zerofile
