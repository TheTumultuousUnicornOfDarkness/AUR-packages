#!/usr/bin/bash

############################################################################
#			Hook: pre-commit
#
#	A Git hook to help to update a package.
############################################################################

GIT_ROOT=$(git rev-parse --show-toplevel)
PACKAGE=$(dirname `git log --pretty=format: --name-only -n1`)

[[ ! -f "$GIT_ROOT/$PACKAGE/PKGBUILD" ]] && exit 0

cd "$GIT_ROOT/$PACKAGE"

if [[ $SUM != 0 ]]; then
	ls -1 > /tmp/fileslist
	echo -e "\033[36mUpdate sums\033[0m"
	updpkgsums
	ls -1 >> /tmp/fileslist
	
	to_delete=$(sort /tmp/fileslist | uniq -u)
	if [[ -n $to_delete ]]; then
		echo -e "\033[36mRemove temporary files\033[0m"
		rm $to_delete
	fi
fi

echo -e "\033[36mUpdate .SRCINFO file\033[0m"
mksrcinfo
