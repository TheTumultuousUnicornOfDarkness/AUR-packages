#!/bin/bash

GIT_ROOT="$(git rev-parse --show-toplevel)"

cd "$GIT_ROOT/.git/hooks"
echo -e "\e[01;32m *** Setting Git hooks ***\e[00m" 
for hook in "$GIT_ROOT/scripts/"*.hook.sh; do
    basehook=$(basename $hook)
    ln -vsf "../../scripts/$basehook" "${basehook/.hook.sh}"
done
