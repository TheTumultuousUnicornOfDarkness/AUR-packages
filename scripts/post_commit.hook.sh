#!/bin/bash

############################################################################
#			Hook: post-commit
#
#	A Git hook to commit changes on GitHub and AUR.
############################################################################

GIT_ROOT=$(git rev-parse --show-toplevel)
PACKAGE=$(dirname `git log --pretty=format: --name-only -n1 | head -n1`)
COMMIT_MSG=$(git log -1 --pretty=%B)
TMP_DIR="/tmp/aur-repos"

( [[ ! -f "$GIT_ROOT/$PACKAGE/PKGBUILD" ]] || [[ $SKIP_POST == 1 ]] ) && exit 0

unset GIT_DIR
cd "$GIT_ROOT/$PACKAGE"
git add .SRCINFO PKGBUILD

export SKIP_POST=1
git commit --no-verify --amend --no-edit
unset SKIP_POST
SHA_1=$(git rev-parse HEAD)


if [[ ! -d "$TMP_DIR/$PACKAGE" ]]; then
	git clone ssh+git://aur@aur.archlinux.org/$PACKAGE.git "$TMP_DIR/$PACKAGE"
fi

cd "$TMP_DIR/$PACKAGE"
git --git-dir="$GIT_ROOT/.git" \
	format-patch -k -1 --stdout $SHA_1 | \
	git am -3 -k

if [[ -d "$PACKAGE" ]]; then
	git mv "$PACKAGE"/* .
	git commit --no-verify --amend --no-edit
	rm -rf "$PACKAGE"
fi

cd "$GIT_ROOT/"
export SKIP_POST=1
git commit --no-verify --amend -m "$PACKAGE: $COMMIT_MSG"
unset SKIP_POST
