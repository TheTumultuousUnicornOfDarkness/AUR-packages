#!/usr/bin/bash

############################################################################
#			update_hook
#
#	A Git hook to help to update a package.
############################################################################

[[ $# == 0 ]] && echo -e "Package name is missing.\n" && exit 1

cd $(find . -name $1)

ls -1 > /tmp/fileslist
[[ $SUM != 0 ]] && updpkgsums
ls -1 >> /tmp/fileslist
sort /tmp/fileslist | uniq -u | xargs rm

mksrcinfo
