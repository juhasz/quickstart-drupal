#!/bin/bash

# Create example site.  This done after previous reboot to avoid error.
cd ~/websites
drush qc --domain=example.dev


# final size
df -h -T > ~/quickstart/quickstart-size-end.txt


# Manual config instructions.
firefox ~/quickstart/quickstart-8-manualconfig.txt


