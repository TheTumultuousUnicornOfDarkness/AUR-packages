#!/usr/bin/bash

############################################################################
#			Hook: pre-push
#
#	A Git hook to push on AUR before pushing on GitHub.
############################################################################

PACKAGE=$(dirname `git log --pretty=format: --name-only -n1 | head -n1`)
TMP_DIR="/tmp/aur-repos"

cd "$TMP_DIR/$PACKAGE"
git push
