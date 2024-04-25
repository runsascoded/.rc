#!/usr/bin/env bash
# Merge and push the {github,gitlab} x {all,server} branches.
#
# New commits are expected to be created on local branch `gh-all` (which tracks `gh/all`, the
# Github `all` branch). Then this script:
#
# 1. Pushes `gh-all` (to `gh/all`)
# 2. Checks out `gh-server`, merges `gh-all`, pushes (to `gh/server`)
# 3. Checks out `gl-all`, merges `gh-all`, pushes (to `gl/all`)
# 4. Checks out `gl-server`, merges `gl-all`, pushes (to `gl/server`)
#
# The merges in steps 2. and 4. generate conflicts when changes are made to submodules in
# $all ∖setminus server$. Such conflicts are trivially resolved by re-`rm`ing the submodules
# from the `*-server` branches, so this script does that as well.

set -ex

checkout_and_merge() {
    git checkout "$1"
    if ! git merge --no-edit "$2"; then
        du=`git diff --name-only --diff-filter=DU`
        if [ -n "$du" ]; then
            cmd=(git rm -r --cached $du)
            echo "Deleting modified non-server modules: ${cmd[*]}" >&2
            "${cmd[@]}"
        fi
        uu=`git diff --name-only --diff-filter=UU`
        if [ -n "$uu" ]; then
            echo "Found conflicting files: $uu" >&2
            exit 1
        fi
        git commit --no-edit
    fi
}

cur="$(git current-branch)"
if [ "$cur" != "gh-all" ]; then
    echo "Expected to be on gh-all branch" >&2
    exit 1
fi
git push "$@" gh

checkout_and_merge gh-server gh-all
git push "$@" gh

git checkout gl-all
git merge --no-edit gh-all
git push "$@" gl

checkout_and_merge gl-server gl-all
git push "$@" gl

git checkout gh-all
