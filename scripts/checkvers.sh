#!/bin/bash

###############################################################################
#                            checkvers
#
# Automatically check for newer version of programs
###############################################################################

# Constants
TOP_DIR=$(realpath "$(dirname "$0")/..")
CACHE_DIR="$HOME/.cache/nvchecker"
CONF_FILE="/tmp/nvchecker_aur.toml"

mkdir -p "$CACHE_DIR"
cat > "$CONF_FILE" <<\EOF
[__config__]
oldver = "@CACHE_DIR@/old_ver_aur.json"
newver = "@CACHE_DIR@/new_ver_aur.json"

[cpu-x]
source = "github"
github = "X0rg/CPU-X"
use_latest_release = true
token = "@GITHUB_TOKEN@"

[dmg2dir]
source = "github"
github = "X0rg/dmg2dir"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[frozenway]
source = "regex"
regex = "Version .* - GNU/Linux"
url = "http://www.frozendo.com/frozenway/download"

[exaile]
source = "github"
github = "exaile/exaile"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[libaosd]
source = "github"
github = "atheme-legacy/libaosd"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[memtest86-efi]
source = "regex"
regex = "Version [0-9]+\\.[0-9]+ (?:\\(Build [0-9]+\\))"
url = "https://www.memtest86.com/whats-new.html"

[obs-service-recompress]
source = "github"
github = "openSUSE/obs-service-recompress"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[obs-service-set_version]
source = "github"
github = "openSUSE/obs-service-set_version"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[obs-service-tar_scm]
source = "github"
github = "openSUSE/obs-service-tar_scm"
use_latest_tag = true
token = "@GITHUB_TOKEN@"

[rhythmbox-llyrics]
source = "github"
github = "dmo60/lLyrics"
use_latest_tag = true
token = "@GITHUB_TOKEN@"
EOF
sed -i "s|@CACHE_DIR@|$CACHE_DIR|g"       "$CONF_FILE"
sed -i "s|@GITHUB_TOKEN@|$GITHUB_TOKEN|g" "$CONF_FILE"

cd "$TOP_DIR" || exit 255
shopt -s nullglob
for pkgbuild in */PKGBUILD; do
	grep -q "pkgver()" "$pkgbuild" && continue
	# shellcheck disable=SC1090
	source "$pkgbuild"
	# shellcheck disable=SC2154
	case "$pkgname" in
		cpu-x|dmg2dir|rhythmbox-llyrics)
			ver="v$pkgver"
			;;
		frozenway)
			ver="Version $pkgver - GNU/Linux"
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
nvchecker -c "$CONF_FILE" &> /dev/null
nvcmp     -c "$CONF_FILE"
