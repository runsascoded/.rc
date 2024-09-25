#!/usr/bin/env bash
# Merge and push the {github,gitlab} x {all,server} branches.
#
# New commits are expected to be created on local branch `gh-all` (which tracks `gh/all`, the
# Github `all` branch). Then this script:
#
# 1. Pushes `gh-all` (to `gh/all`)
# 2. Checks out `gh-server`, cherry-picks `gh-all`, pushes (to `gh/server`)
# 3. Checks out `gl-all`, cherry-picks `gh-all`, pushes (to `gl/all`)
# 4. Checks out `gl-server`, cherry-picks `gl-all`, pushes (to `gl/server`)
#
# The cherry-picks in steps 2. and 4. generate conflicts when changes are made to submodules in
# $all ∖setminus server$. Such conflicts are trivially resolved by re-`rm`ing the submodules
# from the `*-server` branches, so this script does that as well.

set -ex

cur="$(git current-branch)"
if [ "$cur" != "gh-all" ]; then
    echo "Expected to be on gh-all branch" >&2
    exit 1
fi
base="$(git log -1 --format=%h gh/all)"
head="$(git log -1 --format=%h gh-all)"
refs="$base..$head"

checkout_and_cherrypick() {
    git checkout "$1"
    if ! git cherry-pick --no-edit "$refs"; then
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

git push "$@" gh

checkout_and_cherrypick gh-server
git push "$@" gh

git checkout gl-all
git cherry-pick --no-edit "$refs"
git push "$@" gl

checkout_and_cherrypick gl-server
git push "$@" gl

git checkout gh-all
