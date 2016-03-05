#!/usr/bin/bash

############################################################################
#			post_clone
#
#	Apply hooks to current Git repository.
############################################################################

GIT_ROOT="$(git rev-parse --show-toplevel)"

cd "$GIT_ROOT/.git/hooks"
echo -e "\033[36mSetting Git hooks...\033[0m"
ln -vs "../../scripts/pre_commit.hook.sh"  "pre-commit"
ln -vs "../../scripts/post_commit.hook.sh" "post-commit"
ln -vs "../../scripts/pre_push.hook.sh" "pre-push"
