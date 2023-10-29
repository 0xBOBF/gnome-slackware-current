# Gnome for Slackware Current
## Overview
This project provides the GNOME desktop in "SlackBuild" format for use on Slackware Current.

To build the desktop, follow the order of packages in the gnome-all.sqf queue. Build from SBo's repos, except where there is a newer version of the package in the slackbuilds/ or SBo-builds-needing-upgrades/ subdirectories.

There is a helper script called 'build-gnome.sh'. If this script is run from an intact copy of this repo then it *should* be able to parse and install all the packages in the gnome-all.sqf queue. It will prioritize packages from this repo, and fallback to SBo packages for the rest. With any luck this will build the entire queue in one pass.

## Warning
This repo doesn't "track current". It is built against current in a particular point in time, then current moves on without it. If you try to build this repo and current has had major changes since last repo update then expect problems. This repo is a testing ground to see where slackware-current and gnome's compatibility are at. It is not intended for end users. If you do run it you may need some troubleshooting/debugging experience.
