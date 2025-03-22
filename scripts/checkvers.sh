#!/bin/bash

###############################################################################
#                            checkvers
#
# Automatically check for newer version of programs
###############################################################################

set -euo pipefail

# Constants
TOP_DIR=$(realpath "$(dirname "$0")/..")
CACHE_DIR="$HOME/.cache/nvchecker"
CONF_DIR="$HOME/.config/nvchecker"
CONF_FILE="/tmp/nvchecker_aur.toml"

mkdir -p "$CACHE_DIR"
cat > "$CONF_FILE" <<\EOF
[__config__]
oldver  = "@CACHE_DIR@/old_ver_aur.json"
newver  = "@CACHE_DIR@/new_ver_aur.json"
keyfile = "@CONF_DIR@/keyfile.toml"

[afancontrol]
source = "github"
github = "KostyaEsmukov/afancontrol"
use_latest_release = true

[exaile]
source = "github"
github = "exaile/exaile"
use_latest_release = true

[memtest86-efi]
source = "regex"
regex = "Version [0-9]+\\.[0-9]+ (?:\\(Build [0-9]+\\))"
url = "https://www.memtest86.com/whats-new.html"
EOF
sed -i "s|@CACHE_DIR@|$CACHE_DIR|g" "$CONF_FILE"
sed -i "s|@CONF_DIR@|$CONF_DIR|g"   "$CONF_FILE"

cd "$TOP_DIR" || exit 255
shopt -s nullglob
for pkgbuild in */PKGBUILD; do
	grep -q "pkgver()" "$pkgbuild" && continue
	# shellcheck disable=SC1090
	source "$pkgbuild"
	# shellcheck disable=SC2154
	case "$pkgname" in
		dmg2dir|rhythmbox-llyrics)
			ver="v$pkgver"
			;;
		memtest86-efi)
			if [[ "$pkgver" == *"build"* ]]; then
				ver="Version $(echo "$pkgver" | awk -F 'build' '{print $1}') (Build $(echo "$pkgver" | awk -F 'build' '{print $2}'))"
			else
				ver="Version $pkgver"
			fi
			;;
		*)
			ver="$pkgver"
	esac
	nvtake -c "$CONF_FILE" "$pkgname=$ver"
done
nvchecker -c "$CONF_FILE" --logging error
nvcmp     -c "$CONF_FILE"
