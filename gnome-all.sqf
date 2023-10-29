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

# GNOME Settings Daemon and deps:
libgusb
colord
gnome-desktop # Needs to be updated for newer gnome-control-center
geoclue2
geocode-glib2
libgweather4 # Must be set for libsoup3 (uses soup2 currently)
gcr4 # Needs to be added to SBo
gnome-settings-daemon

# GNOME Control Center and deps:
colord-gtk
gsound
libxmlb
AppStream
libadwaita # Needs to be upgraded to 1.3.X
gnome-bluetooth
xdg-dbus-proxy
libwpe
wpebackend-fdo
bubblewrap
# libavif and its deps are a dep for webkit2gtk-6.0 API:
libyuv
svt-av1
dav1d
aom
libavif
unifdef
webkit2gtk6.0 # Needs to be added to SBo, >= 2.41.1 to build epiphany later in queue
webkit2gtk4.1 # Need older gtk3 version for some apps
gtksourceview5
rest # Needs newer version of rest for g-o-a
gnome-online-accounts
libnma-gtk4 # Needs to be added to SBo
cups-pk-helper
gnome-color-manager
libgnomekbd
webp-pixbuf-loader
xdg-desktop-portal-gnome
gnome-control-center

# GNOME Shell and deps:
xvfb-run
python3-attrs
libei
mutter
evolution-data-server
gnome-autoar # needs an upgrade to 0.4.4 (sbo at 0.4.3)
gnome-shell

# GNOME Session Manager:
gnome-session

# GNOME Display Manager:
libdaemon
blocaled
gdm

# gnome-shell extensions:
gnome-menus
gnome-shell-extensions

# gnome-browser-connector
gnome-browser-connector

# GNOME Files (nautilus):
libportal
tracker
exempi
libgxps
libiptcdata
osinfo-db-tools
osinfo-db
libosinfo
totem-pl-parser
tracker-miners
libcloudproviders
nautilus

# GNOME Backgrounds:
gnome-backgrounds

# GNOME Tweaks:
gnome-tweaks

# Yelp:
python3-webencodings
html5lib
python-toml
python2-setuptools-scm
functools-lru-cache
python2-soupsieve
python2-BeautifulSoup4
python3-flit_core
python3-installer
python3-wheel
python-zipp
python-importlib_metadata
python3-pyproject-hooks
python3-build
python3-calver
python3-trove-classifiers
python3-pluggy
python3-pathspec
python3-editables
python3-hatchling
python3-soupsieve
BeautifulSoup4
lxml
yelp-xsl
yelp-tools
yelp # SBO version from willy needs "--with-webkit2gtk-4-0" removed from the build options.

# Cheese is GNOME's webcam application:
#cogl
#clutter
#clutter-gtk
#clutter-gst
#gnome-video-effects
#cheese

# eog has been replaced by loupe for gnome 45 releases:
loupe

# GNOME Terminal Emulator:
gnome-terminal

# GNOME System Monitor:
gnome-system-monitor

# GNOME Weather (Also provides weather in the panel menu):
gnome-weather

# GNOME Clocks:
gnome-clocks # Needs to be upgraded on SBo

# GNOME Disks:
gnome-disk-utility

# GNOME Disk Usage Analyzer
baobab

# GNOME Scanner Utility:
simple-scan

# GNOME Calendar:
gnome-calendar # Depends on newer evolution-data-server on SBo. 

# GNOME Calculator:
gnome-calculator

# Note: gedit is no longer in gnome-core, replaced by gnome-text-editor
# gedit is an editor for GNOME:
#gtksourceview4 # Added here, since gedit needs it still
#libpeas
#gedit

# Eye of Gnome image viewer:
#eog # Needs upgrade on SBo 

# Evince document viewer:
evince # Needs upgrade on SBo

# Evolution email/calendar/organizer client:
#gspell
#cmark
#libpst
#lua53
#highlight
#ytnef
#libchamplain
#evolution # NOTE: Evolution is not in gnome-core

# File-Roller archive manager:
file-roller

# Sysprof:
libdex # Needs upgrade to 0.4.0 on  SBo
libpanel # Not on SBo yet.
sysprof # Upgraded from SBo version.

# GNOME Maps:
libshumate
gnome-maps

# Note: gnome-photos is replaced by loupe in gnome 45
# GNOME Photos:
#libdazzle
#gnome-photos

# Seahorse GNOME Keyring manager:
#seahorse # Not in gnome-core

# GNOME Screenshot:
#gnome-screenshot # Not in gnome-core, built into gnome-shell >= 42.0

# GNOME Snapshot is the new cheese:
snapshot


# Zenity: Not part of gnome-core
#zenity

# GNOME Calls and Deps: Adding from gnome-core
callaudiod
feedbackd
telepathy-glib
folks
gom
sofia-sip
libpeas
calls

# Cantarell Font
cantarell-fonts

# GNOME Characters:
gnome-characters

# GNOME Connections
gtk-vnc
gnome-connections

# GNOME Console
vte-gtk4
gnome-console

# GNOME Contacts:
gnome-contacts

# GNOME Fonts:
gnome-font-viewer

# GNOME Initial Setup:
#gnome-inital-setup # Note: Test this! Seems like it might be incompatible with Slackware methodology

# GNOME Logs:
#gnome-logs # Not using this, since its a systemd journal viewer.

# GNOME Music:
libmediaart
grilo
grilo-plugins
gnome-music

# GNOME Remote Desktop:
tpm2-tss
nv-codec-headers
libfdk-aac
gnome-remote-desktop

# GNOME Text Editor:
gnome-text-editor

# GNOME Tour:
# Have to use 44.0 version, since 45.0 version requires pango >= 1.51 (Slackware on 1.50.14)
gnome-tour

# GNOME User Share:
avahi
mod_dnssd
gnome-user-share

# Rygel and deps:
gssdp
gupnp
gupnp-av
gupnp-dlna
gst-editing-services
rygel

# Totem, aka GNOME Videos:
totem

# Orca:
orca

# Sushi
gtksourceview4
sushi

# Epiphany:
epiphany # Version 45.0 needs webkit2gtk6.0 to be >= 2.41.1, fallback to 44.7 to use 2.40.5

# GNOME Boxes:
yajl
libvirt
libvirt-glib
spice-protocol
spice
spice-gtk
gnome-boxes

# GNOME Software: NOTE: Still built against libsoup2:
# Skipping, due to package management side of this being
# utterly broken on Slackware:
#libxmlb
#AppStream
#PackageKit # Added myself. Testing with disabled
#malcontent # Not present. Testing with disabled
#fwupd and friends: Not building fwupd, due to gcab issues causing FTB of fwupd on -current. Wait till maintainer fixes fwupd.
#  libjcat
#  python-smartypants
#  python3-typogrify
#  python-toml
#  protobuf3
#  protobuf-c
#  libsmbios
#  gcab
# fwupd
#flatpak and friends: Note: Builds against libsoup2, so gnome-software must also use soup2
#  xdg-desktop-portal-gtk
#  appstream-glib
#  ostree
# flatpak
# valgrind
#gnome-software # set to use soup2

# GNOME Builder: # Skipping the rest of this for now
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
