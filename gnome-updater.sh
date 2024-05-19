#!/bin/bash
#
# gnome-updater.sh
#
# Updates gnome sources automatically, along with some other convenient tasks.
#


GNOME_BRANCH="45"
GNOME_VERSION="45.6"
GNOME_SOURCE_URL="https://download.gnome.org/core/${GNOME_BRANCH}/${GNOME_VERSION}/sources/"

LOCAL_DIR[0]="slackbuilds"
LOCAL_DIR[1]="SBo-builds-needing-upgrades"

PKGURL=()
PKGTAR=()
PKGNAM=()
PKGVER=()
LOOKUP=()

get_namechange () {
  case "$1" in
    "libgweather")
      echo "libgweather4"
      ;;
    "libsoup")
      if ( echo "$2" | grep -q "^2.*" ); then echo "libsoup2"; fi
      if ( echo "$2" | grep -q "^3.*" ); then echo "libsoup3"; fi
      ;;
    "gcr")
      if ( echo "$2" | grep -q "^4.*" ); then echo "gcr4"; else echo "gcr"; fi
      ;;
    "glib")
      if ( echo "$2" | grep -q "^2.*" ); then echo "glib2"; else echo "glib"; fi
      ;;
    "gtk+")
      if ( echo "$2" | grep -q "^2.*" ); then echo "gtk+2"; 
      elif ( echo "$2" | grep -q "^3.*" ); then echo "gtk+3";
      else echo "gtk+"; fi
      ;;
    "gtk")
      if ( echo "$2" | grep -q "^4.*" ); then echo "gtk4"; else echo "gtk"; fi
      ;;
    "gtkmm")
      if ( echo "$2" | grep -q "^2.*" ); then echo "gtkmm2";
      elif ( echo "$2" | grep -q "^3.*" ); then echo "gtkmm3";
      elif ( echo "$2" | grep -q "^4.*" ); then echo "gtkmm4";
      else echo "gtkmm"; fi
      ;;
    "gtksourceview")
      if ( echo "$2" | grep -q "^3.*" ); then echo "gtksourceview3";
      elif ( echo "$2" | grep -q "^4.*" ); then echo "gtksourceview4";
      elif ( echo "$2" | grep -q "^5.*" ); then echo "gtksourceview5";
      else echo "gtksourceview"; fi
      ;;
    "libpeas")
      if ( echo "$2" | grep -q "^2.*" ); then echo "libpeas2";
      else echo "libpeas"; fi
      ;;
    *) 
      echo "$1" 
      ;;
  esac
}

get_upstream () {
  local i=0
  while read -r line; do
    local url="$line"
    local tar="$(echo $url | rev | cut -d/ -f1 | rev)"
    local nam="$(echo $tar | rev | cut -d- -f2- | rev)"
    local ver="$(echo $tar | rev | cut -d- -f1 | rev | sed 's/\.tar\..*$//g')"
    local realnam="$(get_namechange "${nam}" "${ver}")"
    PKGURL+=( "$url" )
    PKGTAR+=( "$tar" )
    PKGNAM+=( "$realnam" )
    PKGVER+=( "$ver" )
    LOOKUP+=( "${i}:${realnam}" )
    i=$((i + 1))
  #done < <(sed -n '/References/,$p' ./test | grep 'tar\..z' | sed -n 's/^.*\(https:.*$\)/\1/p' | sed 's/%2B/+/g')
  done < <(lynx -dump "$GNOME_SOURCE_URL" | sed -n '/References/,$p' | grep 'tar\..z' | sed -n 's/^.*\(https:.*$\)/\1/p' | sed 's/%2B/+/g')
}

check_installed () {
  get_upstream
  for i in ${!PKGURL[@]}; do
    #printf "%s version %s from %s at %s\n" "${PKGNAM[$i]}" "${PKGVER[$i]}" "${PKGTAR[$i]}" "${PKGURL[$i]}"
    #printf "%s %s\n" "${LOOKUP[$i]}" "${PKGVER[$i]}"
    echo -n "Looking for ${PKGNAM[$i]} ${PKGVER[$i]} "
    result=$(find "/var/lib/pkgtools/packages" -type f -name "${PKGNAM[$i]}-[0-9]*")
    if [ -n "$result" ]; then
      echo "$result"
    else
      echo "not found."
    fi
  done
}

update_local_repos () {
  get_upstream
  for i in ${!LOCAL_DIR[@]}; do
    echo "Checking packages in ${LOCAL_DIR[$i]}"
    while read -r line; do
      pkg=$(basename $line)
      index=$(echo "${LOOKUP[@]}" | grep -o "[0-9]*:${pkg} " | cut -d: -f1)
      (
        cd "$line"
        source ./${pkg}.info
        if [ -n "$index" ]; then
          if [ "$VERSION" != "${PKGVER[$index]}" ]; then
            echo "$PRGNAM $VERSION -> ${PKGVER[$index]}"
            TMPDIR=$(mktemp -d)
            NEWMD5=$(cd "$TMPDIR" && wget -q "${PKGURL[$index]}" && md5sum "${PKGTAR[$index]}" | cut -d' ' -f1)
            
            # Update the info files version, download url, and md5sum:
            if [ -n "$DOWNLOAD" ]; then
              sed -i "s|VERSION=.*$|VERSION=\"${PKGVER[$index]}\"|g" "${pkg}.info"
              sed -i "s|DOWNLOAD=.*$|DOWNLOAD=\"${PKGURL[$index]}\"|g" "${pkg}.info"
              sed -i "s|MD5SUM=.*$|MD5SUM=\"${NEWMD5}\"|g" "${pkg}.info"
            elif [ -n "DOWNLOAD_x86_64" ]; then
              sed -i "s|VERSION=.*$|VERSION=\"${PKGVER[$index]}\"|g" "${pkg}.info"
              sed -i "s|DOWNLOAD_x86_64=.*$|DOWNLOAD_x86_64=\"${PKGURL[$index]}\"|g" "${pkg}.info"
              sed -i "s|MD5SUM_x86_64=.*$|MD5SUM_x86_64=\"${NEWMD5}\"" "${pkg}.info"
            fi

            # Update the slackbuild's version, and reset the build number to 1:
            sed -i "s|VERSION=.*$|VERSION=\${VERSION:-${PKGVER[$index]}}|g" "${pkg}.SlackBuild"
            sed -i "s|BUILD=.*$|BUILD=\${BUILD:-1}|g" "${pkg}.SlackBuild"
            rm -rf "$TMPDIR"
          fi
        fi
      )
    done < <(find "${LOCAL_DIR[$i]}" -type d -maxdepth 1 -mindepth 1)
  done
}
update_local_repos
