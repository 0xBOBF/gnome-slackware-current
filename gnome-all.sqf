# gnome-all.sqf
#
# This is the 'gnome-all' build. It pulls in all the gnome packages from slackbuilds.org,
# and builds them in appropriate order, enabling as many features as possible.
#
# The list is grouped into relevant dependencies, and commented with details.
# Note that some builds have shared deps. This list has cropped duplicates, leaving only
# the first occurance, so all deps are met without rebuilding any packages.
#
# Good Luck! - Bob Funk

# gi-docgen and deps:
python-smartypants
python3-typogrify
python-toml
gi-docgen

# GNOME Settings Daemon and deps:
libgusb
colord
gnome-desktop # Needs to be updated for newer gnome-control-center
geocode-glib2 # Changed to geocode-glib2, which uses soup3 instead of soup2
geoclue2
libgweather4 # Updated to libgweather4 for gnome-settings-daemon. Note: Ozan has soup2=true, which will build soup2 symbols linked to gnome-settings-daemon, and thus cause gnome-shell crash when it sees both soup2 and 2 symbols. Modify to only soup 3, and use the geocode-glib2 dep for soup3.
gcr4 # Added for gnome-settings-daemon, deps on gi-docgen
gnome-settings-daemon # Update to 43.0 

# Mutter compositor:
zenity
xvfb-run
mutter # Upgraded to 43.3

# Cheese is GNOME's webcam application:
# NOTE: Build this before GNOME Control Center to build in webcam support to GNOME Control 
#       Center, which is used in user profile pic settings
cogl
clutter
clutter-gtk
clutter-gst
cheese # Upgraded to 43.0

# GNOME Control Center and deps:
colord-gtk # Needs to be updated to 0.3.0, ask the maintainer.
gsound # Moved up, since its now a dep for gnome-bluetooth.
libadwaita # Moved up, since its a dep for gnome-bluetooth
gnome-bluetooth # Use older gtk3 version, and patch gnome-cc. unless upower ever moves above 0.99.13.
# libhandy # Removed, since its in -current now
xdg-dbus-proxy
libwpe
wpebackend-fdo
bubblewrap
webkit2gtk # Staying on this version, unless goa updates.
gtksourceview5 # Needs to be here, new rest needs it.
rest # Need a newer rest for gnome-maps, try using that. Deps on libadwaita now... Nope, leave at older version for now, too much breaks without it.
gnome-online-accounts
cups-pk-helper
libnma-gtk4 # Need libnma's gtk4 library to build control-center.
webp-pixbuf-loader # Added to support gnome-control-center's backgrounds loading
xdg-desktop-portal-gnome # Added to support gnome-control center. E.g. switching light/dark mode.
gnome-control-center # Updated to 43.4.1 Patched to allow building with older gnome-bluetooth

# GNOME Shell and deps:
libgdata
# libgweather4 # Remove, since its now a dep earlier in the build
evolution-data-server
gnome-autoar
# adobe-source-code-pro-font # Skip for now, think this was just for gnome-41
gnome-shell # Updated to 43.3, patched to build with older gcr-3

# GNOME Session Manager:
gnome-session # Updated to 43.0

# GNOME Display Manager:
libdaemon
blocaled
gdm # Updated to 43.0

# GNOME Tweaks:
gnome-tweaks # Updated to 42.beta

# tracker:
libportal # Upgraded to 0.6 for nautilus upgrade
tracker

# tracker-miners enables thumbnails in GNOME Files (nautilus):
exempi
libgxps
libiptcdata
osinfo-db-tools
osinfo-db
libosinfo
totem-pl-parser
tracker-miners # Keep at same version until maintainer of tracker updates

# GNOME Files:
libcloudproviders # Added to please nautilus. Note: No maintainer for this on SBo (i.e. its orphaned)
nautilus # Updated to 43.2, but requires libportal >= 0.5 (currently at 0.3, then libportal requires gi-docgen and deps)

# gnome-shell extensions:
gnome-menus # Still needed for extensions like arc menu and applications menu.
gnome-shell-extensions # Upgraded to 43.1

# gnome-browser-connector and deps:
jq
p7zip
gnome-browser-connector

# Some GNOME Shell extensions to include by default:
#gnome-shell-extension-appindicator   # Skipping these in the -current build, since they will all be newer than their 41.x versions.
#gnome-shell-extension-arc-menu
#gnome-shell-extension-dash-to-panel
#gnome-shell-extension-gsconnect
#gnome-shell-extension-sound-output-device

# GNOME Backgrounds:
gnome-backgrounds # Upgraded to 43.1

# Yelp:
lxml
yelp-xsl
yelp-tools
yelp

# GNOME Terminal Emulator:
gnome-terminal # Upgraded to 3.46.8

# GNOME System Monitor:
gnome-system-monitor

# GNOME Weather (Also provides weather in the panel menu):
gnome-weather # Upgraded to 43.0

# GNOME Clocks:
#libgweather # removed. Only needed for older gnome-clocks. Newer will use libgweather4
gnome-clocks

# GNOME Disks:
gnome-disk-utility # Upgraded to 43.0

# GNOME Disk Usage Analyzer
baobab # Upgraded to 43.0

# GNOME Scanner Utility:
simple-scan

# GNOME Calendar:
#libdazzle # Removed, since newer gnome-calendar versions do not use it.
geocode-glib # Older calendar needs this older version. Lets hope it doesnt break gnome-shell...
gnome-calendar # Upgraded to 42.2. Note: Newer 43.x versions need evolution-data-server >= 3.45.1

# GNOME Calculator:
#gtksourceview5 # Using 5 now (was 4 before)
gnome-calculator # Upgraded to 43.0.1

# gedit is an editor for GNOME:
gtksourceview4 # Added here, since gedit needs it still
libpeas
gedit

# Eye of Gnome image viewer:
# eog # Removed for now, since this older version is not building. Will wait for maintainer to upgrade.

# Evince document viewer:
evince

# Evolution email/calendar/organizer client:
gspell
cmark
libpst
lua53
highlight
ytnef
libchamplain
evolution

# File-Roller archive manager:
file-roller

# GNOME Maps:
telepathy-glib
folks
#geocode-glib2 # Added for newer gnome-maps version.
#libshumate # Added for newer gnome-maps version.
#rest # This is version 0.9.1, which gnome-maps needs. The older version is still in the queue, used by webkit2gtk, and gfbgraph.
gnome-maps # Skip Upgrade to 43.4, due to rest conflicts.

# GNOME Photos:
# libsoup3 # Removed, since its in -current now.
grilo
gfbgraph
libdazzle # gnome-photos still needs this
geocode-glib2 # newer gnome-photos needs it.
gnome-photos # Upgraded to 43.0

# Seahorse GNOME Keyring manager:
seahorse

# GNOME Screenshot:
gnome-screenshot

# Some games for GNOME:
libgnome-games-support
gnome-chess
gnome-klotski
gnome-mahjongg
gnome-mines
iagno

# GNOME Builder: # Skipping the rest of this for now
#sysprof
#sphinx_rtd_theme
#sphinxcontrib-serializinghtml
#sphinxcontrib-qthelp
#sphinxcontrib-jsmath
#sphinxcontrib-htmlhelp
#sphinxcontrib-devhelp
#sphinxcontrib-applehelp
#snowballstemmer
#pytz
#python3-babel
#imagesize
#alabaster
#Sphinx
#libgit2
#libgit2-glib
#template-glib
#python-smartypants
#python3-typogrify
#python-toml
#gi-docgen
#jsonrpc-glib
#gnome-builder
