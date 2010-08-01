#!/bin/bash

# Change default theme
gconftool-2 -s /apps/metacity/general/theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/gtk_theme --type=string Radiance
gconftool-2 -s /desktop/gnome/interface/icon_theme --type=string ubuntu-mono-light
# Config gedit-2
gconftool-2 -s /apps/gedit-2/preferences/editor/auto_indent/auto_indent --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/bracket_matching/bracket_matching --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/line_numbers/display_line_numbers --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/current_line/highlight_current_line --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/right_margin/display_right_margin --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/wrap_mode/wrap_mode --type=string GTK_WRAP_NONE
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/insert_spaces --type=bool true
gconftool-2 -s /apps/gedit-2/preferences/editor/tabs/tabs_size --type=integer 2
gconftool-2 -s /apps/gedit-2/preferences/editor/save/auto_save --type=bool true
# gnome terminal
gconftool-2 -s /apps/gnome-terminal/profiles/Default/scrollback_unlimited --type=bool true
# automatic updates.  apply security.  download updates
echo "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
" | sudo tee /etc/apt/apt.conf.d/10periodic
# setup icons on top of screen
gconftool-2 --load ~/config/my-panel-setup.entries
