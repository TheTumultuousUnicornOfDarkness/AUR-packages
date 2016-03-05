#!/bin/bash

############################################################################
#			newpackage
#
#	Add a new package on AUR.
############################################################################

[[ $# == 0 ]] && echo -e "Package name is missing.\n" && exit 1

cd $(find `git rev-parse --show-toplevel` -name $1)

if [[ ! -f .gitignore ]]; then
	echo -e '*\n!.gitignore\n!.SRCINFO' > .gitignore
	for file in $(ls --hide=*~); do
		echo "!$file" >> .gitignore
	done
fi

updpkgsums
mksrcinfo

if [[ ! -d .git ]]; then
	git init
	git remote add origin ssh+git://aur@aur.archlinux.org/$1.git/
	git add .gitignore
	git add --all
fi

git commit -am "Initial commit for $1"
git push -u origin master

cd ..
git submodule add ssh+git://aur@aur.archlinux.org/$1.git/
