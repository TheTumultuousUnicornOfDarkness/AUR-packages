#!/usr/bin/bash

############################################################################
#			update_hook
#
#	A Git hook to help to update a package.
############################################################################

[[ $# != 0 ]] && cd $(find . -name $1)

ls -1 > /tmp/fileslist
[[ $SUM != 0 ]] && echo -e "\033[36mUpdate sums\033[0m" && updpkgsums
ls -1 >> /tmp/fileslist

echo -e "\033[36mRemove temporary files\033[0m"
sort /tmp/fileslist | uniq -u | xargs rm

echo -e "\033[36mUpdate .SRCINFO file\033[0m"
mksrcinfo
