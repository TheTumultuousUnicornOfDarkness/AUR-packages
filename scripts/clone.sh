#!/bin/bash

###############################################################################
#                            clone
#
# Clone all packages of (configured) maintainer
###############################################################################

# Constants
TOP_DIR=$(realpath "$(dirname "$0")/..")
PACKAGES=$(ssh aur list-repos | sort)
GETPKG="$TOP_DIR/scripts/getpkg.sh"

# Main
for package in $PACKAGES; do
	"$GETPKG" "$package"
	echo
done
