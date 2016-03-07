#!/bin/bash

############################################################################
#			Hook: pre-push
#
#	A Git hook to push on AUR before pushing on GitHub.
############################################################################

PACKAGE=$(dirname `git log --pretty=format: --name-only -n1 | head -n1`)
TMP_DIR="/tmp/aur-repos"

[[ ! -f "$TMP_DIR/$PACKAGE/PKGBUILD" ]] && exit 0

cd "$TMP_DIR/$PACKAGE"
git push
