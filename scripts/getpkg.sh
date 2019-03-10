#!/bin/bash

###############################################################################
#                            getpkg
#
# Retrieve an existing package and install Git hooks
###############################################################################

# Constants
AUR_URL="ssh://aur@aur.archlinux.org"
TOP_DIR=$(realpath "$(dirname "$0")/..")
HOOKS="$TOP_DIR/scripts/*.hook.sh"

# Main
package="$1"
if [[ -z "$package" ]]; then
	echo "$(basename "$0"): package name is required."
	exit 1
fi

# Get package
cd "$TOP_DIR" || exit 255
if [[ -d "$package" ]]; then
	echo -e "\033[34mUpdating \033[1m$package\033[0;34m package...\033[0m"
	git -C "$package" pull
else
	echo -e "\033[34mDownloading $package package...\033[0m"
	git clone "$AUR_URL/$package.git"
fi

# Install hooks
cd "$package/.git/hooks" || exit 255
echo -e "\033[34mSetting up hooks in \033[1m${PWD/${TOP_DIR}\/}\033[0;34m directory...\033[0m"
for hook in $HOOKS; do
	basehook=$(basename "$hook")
	ln -vsf "../../../scripts/$basehook" "${basehook/.hook.sh}"
done
