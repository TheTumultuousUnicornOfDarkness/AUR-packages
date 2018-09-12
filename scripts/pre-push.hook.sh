#!/bin/bash

for path in $(git diff --name-only --cached --diff-filter=AM); do
    if [[ "${path}" =~ .*/PKGBUILD$ ]]; then
        aurpublish ${path%PKGBUILD}
    fi
done
