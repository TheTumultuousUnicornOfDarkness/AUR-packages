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
WWW="elinks -dump -no-references -no-home -verbose 0"

# Global variables
cpt=0
ign=0
[[ "$1" == "-q" ]] && quiet=true || quiet=false
[[ "$1" == "-c" ]] && checkupdates_fmt=true || checkupdates_fmt=false


# Functions

gitHub_Api() {
	local repo="$1"
	curl --silent --user "$GITHUB_TOKEN:x-oauth-basic" "https://api.github.com/repos/$repo/tags" | jq -r '.[] | select(.name|test("[0-9].[0-9]")) | .name' | head -n1 | cut -d "v" -f2
}

showver() {
	local pkgname="$1"
	local newver="$2"
	local ignver="$3"

	unset pkgver _pkgver
	if [[ -f "$1/PKGBUILD" ]]; then
		source "$1/PKGBUILD"
	else
		if ! $quiet; then
			printf "$COLOR_RED%35s: PKGBUILD not found$COLOR_DEFAULT\n" "$pkgname"
		fi
		((ign++))
		return
	fi

	if [[ -z "$newver" ]]; then
		newver="unknown"
	fi

	if [[ -n "$_pkgver" ]]; then
		pkgver="$_pkgver"
	fi

	if $checkupdates_fmt; then
		if [[ "$newver" != "$ignver" ]] && [[ "$newver" != "$pkgver" ]]; then
			echo "$pkgname $pkgver -> $newver"
		fi
	elif ! $quiet; then
		if [[ -z "$newver" ]]; then
			colpkgver=$COLOR_YELLOW
			colprgver=$COLOR_RED
			((cpt++))
		elif [[ "$newver" == "$ignver" ]]; then # When ignver is set
			colpkgver=$COLOR_GREEN
			colprgver=$COLOR_YELLOW
			((ign++))
		elif [[ "$pkgver" == "$newver" ]]; then
			colpkgver=$COLOR_GREEN
			colprgver=$COLOR_GREEN
		else
			colpkgver=$COLOR_RED
			colprgver=$COLOR_GREEN
			((cpt++))
		fi
		printf "%35s: $colpkgver%12s$COLOR_DEFAULT | $colprgver%12s$COLOR_DEFAULT\n" "$pkgname" "$pkgver" "$newver"
	fi
}


# Main

cd "$TOP_DIR" || exit 255
if ! $quiet && ! $checkupdates_fmt; then
	printf "%36s %12s   %12s\n" "Package" "PkgVer" "PrgVer"
fi

# CPU-X
newver=$(gitHub_Api X0rg/CPU-X)
showver "cpu-x" "$newver"

# DMG2DIR
newver=$(gitHub_Api X0rg/dmg2dir)
showver "dmg2dir" "$newver"

# Exaile
newver=$(gitHub_Api exaile/exaile)
showver "exaile" "$newver"

# FrozenWay
newver=$($WWW "http://www.frozendo.com/frozenway/download" 2> /dev/null \
	| grep -E "Version .* - GNU/Linux" --color=never | awk '{ print $2 }')
showver "frozenway" "$newver"

# LibAOSD
newver=$(gitHub_Api atheme-legacy/libaosd)
showver "libaosd" "$newver"

# MemTest86
newver=$($WWW "https://www.memtest86.com/whats-new.html" 2> /dev/null \
	| grep -E "Version [1-9]\.[1-9]" | awk 'NR==1{print $2}')
showver "memtest86-efi" "$newver"

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
	printf "\n%-20s: $col%i$COLOR_DEFAULT\n" "Out-of-date packages" "$cpt"

	[[ $ign == 0 ]] && col=$COLOR_GREEN || col=$COLOR_YELLOW
	printf "%-20s: $col%i$COLOR_DEFAULT\n" "Ignored packages" "$ign"
fi
