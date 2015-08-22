#!/usr/bin/bash

############################################################################
#			commit_hook
#
#	A Git hook to commit both parent and submodule.
############################################################################

msg="$(git log -1 --pretty=%B)"
rep="$(basename $PWD)"
unset GIT_INDEX_FILE
unset GIT_DIR
unset GIT_WORK_TREE
unset GIT_PREFIX

cd ..
git add "$rep"
git commit -m "$msg"
