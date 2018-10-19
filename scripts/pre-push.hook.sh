#!/bin/bash

for path in $(git show --name-only); do
    if [[ "${path}" =~ .*/PKGBUILD$ ]]; then
        echo -e "\e[01;32m *** Pushing ${path%/PKGBUILD} to AUR ***\e[00m"
        aurpublish ${path%PKGBUILD}
    fi
done
