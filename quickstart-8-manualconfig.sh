#!/bin/bash

# Create example site.
cd ~/websites
drush qc --domain=example.dev


# final size
df -h -T > ~/quickstart/quickstart-size-end.txt


# Manual config instructions.
firefox ~/quickstart/quickstart-8-manualconfig.txt


