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
gnome-video-effects # Added this package from core
cheese # Upgraded to 43.0

# GNOME Control Center and deps:
colord-gtk # Needs to be updated to 0.3.0, ask the maintainer.
gsound # Moved up, since its now a dep for gnome-bluetooth.
libadwaita # Moved up, since its a dep for gnome-bluetooth
gnome-bluetooth # Upgraded and patched to use older upower while we are stuck at 0.99.13.
# libhandy # Removed, since its in -current now
xdg-dbus-proxy
libwpe
wpebackend-fdo
bubblewrap
webkit2gtk4.1 # Upgrading to webkit2gtk4.1 so we can keep upgrading gnome-43 and beyond
gtksourceview5 # Needs to be here, new rest needs it. Also needs to be upgraded to 5.6.2, for gnome-text-editor later in build
rest # Need a newer rest for gnome-online-accounts and gnome-maps, deps on gtksourceview5
gnome-online-accounts # Upgraded to 3.46.0, required new rest
cups-pk-helper
libnma-gtk4 # Need libnma's gtk4 library to build control-center.
webp-pixbuf-loader # Added to support gnome-control-center's backgrounds loading
xdg-desktop-portal-gnome # Added to support gnome-control center. E.g. switching light/dark mode.
gnome-control-center # Updated to 43.4.1

# GNOME Shell and deps:
libgdata
# libgweather4 # Remove, since its now a dep earlier in the build
libsoup3 # This is a Slackware package that needs upgrade! It also adds sysprof-capture-4 as a dep!
webkit2gtk5.0 # Added, its the same as webkit2gtk4.1, but with the USE_GTK4 switch
evolution-data-server # Upgrade to 3.46.4 to use the newer webkit2gtk4.1 dep. *** Trying patched build to use older libsoup3
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
libosinfo # NOTE: This needs to be upgraded to 1.10.0 or later, for the gnome-boxes build.
totem-pl-parser
tracker-miners # Keep at same version until maintainer of tracker updates

# GNOME Files:
libcloudproviders # Added to please nautilus. 
nautilus # Updated to 43.2, but requires libportal >= 0.5 (currently at 0.3, then libportal requires gi-docgen and deps)

# gnome-shell extensions:
# gnome-menus # No longer needed?
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
yelp              # SBO version from willy needs "--with-webkit2gtk-4-0" removed from the build options.

# GNOME Terminal Emulator:
gnome-terminal # Upgraded to 3.46.8

# GNOME System Monitor:
gnome-system-monitor

# GNOME Weather (Also provides weather in the panel menu):
gnome-weather # Upgraded to 43.0

# GNOME Clocks:
#libgweather # removed. Only needed for older gnome-clocks. Newer will use libgweather4
gnome-clocks # Needs to be upgraded on SBo

# GNOME Disks:
gnome-disk-utility # Upgraded to 43.0

# GNOME Disk Usage Analyzer
baobab # Upgraded to 43.0

# GNOME Scanner Utility:
simple-scan

# GNOME Calendar:
#libdazzle # Removed, since newer gnome-calendar versions do not use it.
gnome-calendar # Upgraded to 43.1. Note: Depends on newer evolution-data-server on SBo. 

# GNOME Calculator:
#gtksourceview5 # Using 5 now (was 4 before)
gnome-calculator # Upgraded to 43.0.1

# gedit is an editor for GNOME:
gtksourceview4 # Added here, since gedit needs it still
libpeas
gedit  # Note: gedit is not in gnome-core 43.x

# Eye of Gnome image viewer:
eog # Upgraded to 43.2. Version on SBo is at 41.X 

# Evince document viewer:
evince # SBo version is 41.x. Builds okay but could be upgraded to 43.x

# Evolution email/calendar/organizer client:
gspell
cmark
libpst
lua53
highlight
ytnef
libchamplain
evolution # Upgraded to 3.46.4 to match evolution-data-server and get away from webkit2gtk-4.0 api. SBo version is 3.44.4 NOTE: Evolution is not in the gnome-core build.

# File-Roller archive manager:
file-roller

# GNOME Maps:
telepathy-glib
folks
libshumate # Added for newer gnome-maps version.
gnome-maps # Upgraded to 43.4

# GNOME Photos:
grilo
#gfbgraph # Dropped. No longer needed by gnome-photos , it seems.
gnome-photos # Upgraded to 44.0, which had the fix for not finding newer versions of babl in the meson build.

# Seahorse GNOME Keyring manager:
seahorse # Not in gnome-core

# GNOME Screenshot:
gnome-screenshot # Not in gnome-core

# Some games for GNOME: Not in gnome-core
#libgnome-games-support
#gnome-chess
#gnome-klotski
#gnome-mahjongg
#gnome-mines
#iagno

# GNOME Calls and Deps: Adding from gnome-core
callaudiod
feedbackd
gom
sofia-sip
calls

# Cantarell Font
cantarell-fonts

# GNOME Boxes:
libosinfo # Needs to be upgraded to 1.10.0 on SBo for gnome-boxes.
yajl
libvirt
libvirt-glib
spice-protocol
spice
spice-gtk # Needs to be upgraded to 0.41, SBo version is 0.40
gnome-boxes # 43.2

# GNOME Characters:
gnome-characters # Added build

# GNOME Clocks:
gnome-clocks # Upgraded to 43.0. SBo version is 41.x

# GNOME Color Profile Manager:
gnome-color-manager # Added build

# GNOME Connections
gtk-vnc
gnome-connections # Version 43.0. Note: Builds a bundled version of gtk-frdp

# GNOME Console
vte-gtk4
gnome-console

# GNOME Contacts:
gnome-contacts

# GNOME Fonts:
gnome-font-viewer

# GNOME Initial Setup:
gnome-inital-setup # Note: Test this! Seems like it might be incompatible with Slackware methodology

# GNOME Logs:
#gnome-logs # Not using this, since its a systemd journal viewer.

# GNOME Music:
libmediaart
grilo-plugins
gnome-music

# GNOME Remote Desktop:
tpm2-tss
nv-codec-headers
libfdk-aac
gnome-remote-desktop

# GNOME Software:
AppStream
PackageKit # Added myself. Could also disable in gnome-software meson options
#fwupd and friends:
libjcat
protobuf3
protobuf
libsmbios
gcab
libxmlb
fwupd
#flatpak and friends:
xdg-desktop-portal-gtk
appstream-glib
ostree
flatpak
gnome-software

# GNOME Text Editor:
#gtksourceview5 needs to be upgraded on SBo.
gnome-text-editor

# GNOME Tour:
gnome-tour

# GNOME User Share:
#avahi # Note: Builds without avahi but will not work at runtime without avahi or howl.
gnome-user-share

# Rygel and deps:
gssdp # On SBo
gupnp # On SBo
gupnp-av # Added a build
gupnp-dlna # Added a build
gst-editing-services # On SBo
rygel

# Orca:
orca

# Sushi
sushi

# Epiphany:
epiphany

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
