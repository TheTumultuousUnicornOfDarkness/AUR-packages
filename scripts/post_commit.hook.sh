#!/usr/bin/bash

############################################################################
#			Hook: post-commit
#
#	A Git hook to commit changes on GitHub and AUR.
############################################################################

GIT_ROOT=$(git rev-parse --show-toplevel)
PACKAGE=$(dirname `git log --pretty=format: --name-only -n1`)
SHA_1=$(git rev-parse HEAD)
COMMIT_MSG=$(git log -1 --pretty=%B)
TMP_DIR="/tmp/aur-repos"

( [[ ! -f "$GIT_ROOT/$PACKAGE/PKGBUILD" ]] || (( $SKIP_POST )) ) && exit 0

if [[ ! -d "$TMP_DIR/$PACKAGE" ]]; then
	git clone ssh+git://aur@aur.archlinux.org/$PACKAGE.git "$TMP_DIR/$PACKAGE"
fi

cd "$TMP_DIR/$PACKAGE"
git --git-dir="$GIT_ROOT/.git" \
	format-patch -k -1 --stdout $SHA_1 | \
	git am -3 -k

cd "$GIT_ROOT/"
export SKIP_POST=1
git commit --amend -m "$PACKAGE: $COMMIT_MSG"
unset SKIP_POST
