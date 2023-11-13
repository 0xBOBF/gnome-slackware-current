#!/bin/bash
#
# build_gnome.sh
#

################ Setup Section ################
BASEDIR="$(pwd)"
SBO_BASE_URL="https://slackbuilds.org/slackbuilds/15.0"
ARCH="$(uname -m)"

# This script will automate the building of the following queuefile:
QUEUEFILE="$BASEDIR/gnome-all.sqf"

# It uses the following repositories for SlackBuilds.
# Highest numbered is highest priority, with SBo default/fallback at
# REPO[0]="$BASEDIR/SBo" (we only fetch SBo builds we need, not the whole tree):
REPO[0]="$BASEDIR/SBo"
REPO[1]="$BASEDIR/SBo-builds-needing-upgrades"
REPO[2]="$BASEDIR/slackbuilds"

# Some builds need special user's and groups. Packages in this list:
USER_GROUP_ADD=( "colord" "avahi" )
# Will get their command arrays parsed and executed in ++order when detected.
# The command array must match their key name in the USER_GROUP_ADD array. As many
# commands as needed can be listed, just keep the array contiguous because
# it stops executing commands at the first blank element.
colord[0]="groupadd -g 303 colord"
colord[1]="useradd -d /var/lib/colord -u 303 -g colord -s /bin/false colord" 
avahi[0]="groupadd -g 214 avahi" 
avahi[1]="useradd -u 214 -g 214 -c \"Avahi User\" -d /dev/null -s /bin/false avahi" 

################ Program Section ##############
# Get a copy of the latest SLACKBUILDS.TXT for the SBo repo parser:
[ ! -d "${REPO[0]}" ] && mkdir "${REPO[0]}"
SBO_TXT="${REPO[0]}/SLACKBUILDS.TXT"
if [ ! -e "$SBO_TXT" ]; then
  ( cd "${REPO[0]}" || exit 1 ; wget "$SBO_BASE_URL/SLACKBUILDS.TXT" || exit 1 )
fi

# Get a new SLACKBUILDS.TXT if its older than 7 days:
if [ "$(( ($(date +%s) - $(stat -c %Y "$SBO_TXT"))/(60*60*24) ))" -ge "7" ]; then
  ( cd "${REPO[0]}" || exit 1 ; rm "$SBO_TXT" && wget "$SBO_BASE_URL/SLACKBUILDS.TXT" || exit 1 )
fi

# Setup any required users and groups:
for flagged_package in "${USER_GROUP_ADD[@]}"; do
  if ( grep -q "^${flagged_package}$" "$QUEUEFILE" ); then
    # Parse the command list:
    CMD_LIST=()
    c=0
    while : ; do
      pkg_cmd=${flagged_package}[$c]
      if [ -n "${!pkg_cmd}" ]; then
        CMD_LIST+=( "${!pkg_cmd}" )
        c=$((c + 1))
      else
        break
      fi
    done
    echo "Detected ${flagged_package}, running the following:"
    for ((i=0;i<$c;i++)); do
      echo "${CMD_LIST[$i]}"
      eval "${CMD_LIST[$i]}"
    done
  fi
done

# Function to handle a build:
handle_build () {
  PKG_SOURCE_DIR="$1"
  cd "$PKG_SOURCE_DIR" || return 1
  source "./${pkg}.info"
  if ( find /var/lib/pkgtools/packages/ -type f -name "$PRGNAM-$VERSION-*" | grep -q . ); then
    echo "[${p}/${QUEUEFILE_LENGTH}] Skipping $pkg build, already installed."
  else
    echo "[${p}/${QUEUEFILE_LENGTH}] Building $pkg from '$PKG_SOURCE_DIR'"
    SOURCE_LIST=()
    MD5SUM_LIST=()
    if [ "$ARCH" = "x86_64" -o "$ARCH" = "aarch64" ] && [ -n "$DOWNLOAD_x86_64" ]; then
      for SOURCE_FILE in ${DOWNLOAD_x86_64}; do
        SOURCE_LIST+=( "$SOURCE_FILE" )
      done
      for MD5 in ${MD5SUM_x86_64}; do
        MD5SUM_LIST+=( "$MD5" )
      done
    else
      for SOURCE_FILE in ${DOWNLOAD}; do
        SOURCE_LIST+=( "$SOURCE_FILE" )
      done
      for MD5 in ${MD5SUM}; do
        MD5SUM_LIST+=( "$MD5" )
      done
    fi

    for i in "${!SOURCE_LIST[@]}"; do
      SOURCE="$(basename "${SOURCE_LIST[$i]}")"
      if [ ! -e "$SOURCE" ]; then
        wget "${SOURCE_LIST[$i]}"
      fi
      echo "${MD5SUM_LIST[$i]} $SOURCE"
      if ! ( echo "${MD5SUM_LIST[$i]} $SOURCE" | md5sum --status -c - ); then
        echo "Failed md5sum for $SOURCE. Aborting."
        return 1
      fi
    done

    if ! ( sh "${pkg}".SlackBuild ); then
      return 1
    fi

    if ! ( installpkg /tmp/"${pkg}"-*.t?z ); then
      return 1
    fi

  fi
  return 0
}

# Function to cleanup/download/extract sbo tarballs:
fetch_sbo_repo () {
  SBO_LOCATION="$(grep "SLACKBUILD LOCATION.*/${1}$" "$SBO_TXT" | sed 's/^.*\.\///g')"
  SBO_URL="$SBO_BASE_URL/${SBO_LOCATION}.tar.gz"
  SBO_TARBALL="${1}.tar.gz"
  ( 
    cd "${REPO[0]}" || exit 1
    rm -rf "$SBO_TARBALL" "${1}"
    wget "$SBO_URL" || exit 1
    tar xvf "./$SBO_TARBALL" || exit 1
  ) || exit 1
}
# Check if we have a copy of a SlackBuild from SBo, and that its of the latest SBo version:
# If its not the latest version, or not present, get the latest copy.
check_sbo_repo () {
  SBO_VERSION="$(grep -A 3 "SLACKBUILD NAME: ${1}$" "$SBO_TXT" | sed -n 's/SLACKBUILD VERSION: //p')"
  if [ -e "${REPO[0]}/${1}/${1}.info" ]; then
    # We have a copy, check if its up to date:
    source "${REPO[0]}/${1}/${1}.info"
    if [ "$SBO_VERSION" = "$VERSION" ]; then 
      return 0
    else
      echo "[${1}] Local SBo version $VERSION is out of sync with upstream SBo version ${SBO_VERSION}"
      echo "Fetching new $1 tarball." 
      fetch_sbo_repo "${1}"
    fi
  else
    echo "$1 SlackBuild not found. Fetching latest $1 tarball."
    fetch_sbo_repo "${1}" 
  fi
}

# Iterate through the build file:
p=1
QUEUEFILE_LENGTH=$(grep -cvE '^#|^$' "$QUEUEFILE")
for pkg in $(sed '/^#.*$/d;/^$/d;s/ #.*$//g' "$QUEUEFILE"); do
  # Iterate though the repo array, high to low:
  for ((i=${#REPO[@]};i>0;i--)); do
    SELECTED_REPO="${REPO[$((i-1))]}"
    if [ -e "$SELECTED_REPO/${pkg}/${pkg}.info" ] && [ "$i" -gt "1" ]; then
      if ! ( handle_build "$SELECTED_REPO/${pkg}" ); then
        echo "$pkg failed!"
        exit 1
      fi
      break
    elif [ "$i" = "1" ]; then
      # Handle the SBo repo differently, since its maintained upstream:
      check_sbo_repo "$pkg"
      if ! ( handle_build "$SELECTED_REPO/${pkg}" ); then
        echo "$pkg failed!"
        exit 1
      fi
      break
    fi
  done
  p=$((p + 1))
done
