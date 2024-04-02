#!/usr/bin/env bash

set -ex

checkout_and_merge() {
    git checkout "$1"
    if ! git merge --no-edit "$2"; then
        du=`git diff --name-only --diff-filter=UU`
        git rm -r --cached $du
        uu=`git diff --name-only --diff-filter=UU`
        if [ -n "$uu" ]; then
            echo "Conflicting files: $uu" >&2
            exit 1
        fi
        git commit --no-edit
    fi
}

checkout_and_merge gh-server gh-all
git push gh

git checkout gl-all
git merge --no-edit gh-all
git push gl

checkout_and_merge gl-server gl-all
git push gl

git checkout gh-all
