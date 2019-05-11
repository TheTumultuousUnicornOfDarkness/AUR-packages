#!/bin/bash

###############################################################################
#                            checkvers
#
# Automatically check for newer version of programs
###############################################################################

# Constants
TOP_DIR=$(realpath "$(dirname "$0")/..")
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_DEFAULT="\033[0m"

# Global variables
cpt=0
ign=0
[[ "$1" == "-q" ]] && quiet=true || quiet=false
[[ "$1" == "-c" ]] && checkupdates_fmt=true || checkupdates_fmt=false


# Functions

gitHub_Api() {
	local repo="$1"
	curl --silent "https://api.github.com/repos/$repo/tags" | jq -r '.[0].name' | cut -d "v" -f2
}

showver() {
	local pkgname="$1"
	local curver
	local newver="$2"
	local ignver="$3"
	curver=$(grep --color=never "pkgver=" "$1/PKGBUILD" | cut -d "=" -f2)

	if $checkupdates_fmt; then
		if [[ "$newver" != "$ignver" ]] && [[ "$newver" != "$curver" ]]; then
			echo "$pkgname $curver -> $newver"
		fi
	elif ! $quiet; then
		if [[ -z "$newver" ]]; then
			colpkgver=$COLOR_YELLOW
			colprgver=$COLOR_RED
			newver="unknown"
			((cpt++))
		elif [[ "$newver" == "$ignver" ]]; then # When ignver is set
			colpkgver=$COLOR_GREEN
			colprgver=$COLOR_YELLOW
			((ign++))
		elif [[ "$curver" == "$newver" ]]; then
			colpkgver=$COLOR_GREEN
			colprgver=$COLOR_GREEN
		else
			colpkgver=$COLOR_RED
			colprgver=$COLOR_GREEN
			((cpt++))
		fi
		printf "%35s: $colpkgver%8s$COLOR_DEFAULT | $colprgver%8s$COLOR_DEFAULT\n" "$pkgname" "$curver" "$newver"
	fi
}


# Main

cd "$TOP_DIR" || exit 255
if ! $quiet && ! $checkupdates_fmt; then
	printf "%36s %8s   %8s\n" "Package" "PkgVer" "PrgVer"
fi

# CPU-X
newver=$(gitHub_Api X0rg/CPU-X)
showver "cpu-x" "$newver"

# DMG2DIR
newver=$(gitHub_Api X0rg/dmg2dir)
showver "dmg2dir" "$newver"

# Exaile
newver=$(gitHub_Api exaile/exaile)
showver "exaile" "$newver" "4.0.0-rc4"

# FrozenWay
newver=$(elinks -dump -no-references "http://www.frozendo.com/frozenway/download" \
	| grep "Version" --color=never | awk '{ print $2 }' | tail -n1)
showver "frozenway" "$newver"

# LibAOSD
newver=$(gitHub_Api atheme-legacy/libaosd)
showver "libaosd" "$newver"

# MemTest86
newver=$(elinks -dump -no-references "http://www.memtest86.com/download.htm" | grep -E "MemTest86 v.* Free Edition Download" \
	| cut -d "v" -f2 | cut -d " " -f1 | head -n1)
showver "memtest86-efi" "$newver"

# RadeonTop
newver=$(gitHub_Api clbr/radeontop)
showver "radeontop" "$newver"

# Rhythmbox lLyrics
newver=$(gitHub_Api dmo60/lLyrics)
showver "rhythmbox-llyrics" "$newver"

# Summary
if $quiet; then
	echo -e "$cpt"
elif $checkupdates_fmt; then
	exit 0
else
	[[ $cpt == 0 ]] && col=$COLOR_GREEN || col=$COLOR_RED
	printf "\n%-20s: $col%i$COLOR_DEFAULT\n" "Out-of-date packages" $cpt

	[[ $ign == 0 ]] && col=$COLOR_GREEN || col=$COLOR_YELLOW
	printf "%-20s: $col%i$COLOR_DEFAULT\n" "Ignored packages" $ign
fi
