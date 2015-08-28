#!/usr/bin/bash

############################################################################
#			post-clone
#
#	Apply hooks to submodule and branch HEAD to master.
############################################################################

rep="$(git rev-parse --show-toplevel)"

echo -e "\033[36mAdd hooks for submodules...\033[0m"
for file in $(git submodule | awk '{ print $2 }'); do
	ln -vs "$rep/scripts/commit_hook.sh" "$rep/.git/modules/$file/hooks/post-commit"
	ln -vs "$rep/scripts/update_hook.sh" "$rep/.git/modules/$file/hooks/pre-commit"
done

echo -e "\033[36mCheckout master for submodules...\033[0m"
git submodule foreach git checkout master
