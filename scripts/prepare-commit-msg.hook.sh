#!/bin/bash

old_commit_msg="$(cat ${1})"
echo -n "" > "${1}"

# Check for new PKGBUILDs
for path in $(git diff --name-only --cached --diff-filter=A); do
    if [[ "${path}" =~ .*/PKGBUILD$ ]]; then
        (
            source "${path}"
            : ${pkgbase:=${pkgname}}
            echo -en "${pkgbase}: " >> "${1}"
        )
    fi
done

# Check for updated PKGBUILDs
for path in $(git diff --name-only --cached --diff-filter=M); do
    if [[ "${path}" =~ .*/PKGBUILD$ ]]; then
        (
            source "${path}"
            : ${pkgbase:=${pkgname}}
            echo -en "${pkgbase}: " >> "${1}"
        )
    fi
done

# Check for deleted PKGBUILDs
for path in $(git diff --name-only --cached --diff-filter=D); do
    if [[ "${path}" =~ .*/PKGBUILD$ ]]; then
        echo -en "${path%/PKGBUILD}: " >> "${1}"
    fi
done

echo "${old_commit_msg}" >> "${1}"
