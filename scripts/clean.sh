#!/bin/bash

###############################################################################
#                            clean
#
# Remove all ignored files
###############################################################################

# Constants
TOP_DIR=$(realpath "$(dirname "$0")/..")
PACKAGES=$(ssh aur list-repos | sort)

# Main
for package in $PACKAGES; do
	cd "$TOP_DIR/$package"
	echo -e "\033[34mCleaning $package directory...\033[0m"
	git clean -dfX
done
