# Gnome for Slackware Current
## Overview
This project provides the GNOME desktop in "SlackBuild" format for use on Slackware Current

Before starting the build you will need to create a 'colord' group and user, which is needed by the colord dependency for the GNOME desktop. Use the following commands as root to set this up:
```bash
 groupadd -g 303 colord
 useradd -d /var/lib/colord -u 303 -g colord -s /bin/false colord
```

## Warning
Some of the builds in this repo require updated versions of software on slackbuilds.org. These updated versions are temporarilly stored in this repo under the 'SBo-builds-needing-upgrades' directory. If you attempt to use this repo then you will have to read the notes in the gnome-all.sqf file.
