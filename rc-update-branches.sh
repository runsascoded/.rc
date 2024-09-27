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

no_push=
if [ "$1" == -n ]; then
  no_push=1
elif [ $# -gt 0 ]; then
  echo "Usage: $0 [-n]" >&2
  exit 1
fi

push() {
  if [ -z "$no_push" ]; then
    git push "$@"
  else
    echo "Would push: git push $*" >&2
  fi
}

cherry_pick() {
  if [ "$base" == "$head" ]; then
    echo "No new commits to cherry-pick" >&2
    return 0
  fi
  git cherry-pick --no-edit "$refs"
}

checkout_and_cherrypick() {
    git checkout "$1"
    if ! cherry_pick; then
        IFS=$'\n' read -r -d '' -a du < <(git diff --name-only --diff-filter=DU)
        if [ ${#du[@]} -gt 0 ]; then
            cmd=(git rm -r --cached "${du[@]}")
            echo "Deleting modified non-server modules: ${cmd[*]}" >&2
            "${cmd[@]}"
        fi
        IFS=$'\n' read -r -d '' -a uu < <(git diff --name-only --diff-filter=UU)
        if [ ${#uu[@]} -gt 0 ]; then
            echo "Found conflicting files:" >&2
            echo "${uu[@]}" >&2
            exit 1
        fi
        git commit --no-edit
    fi
}

push "$@" gh

checkout_and_cherrypick gh-server
push "$@" gh

git checkout gl-all
cherry_pick
push "$@" gl

checkout_and_cherrypick gl-server
push "$@" gl

git checkout gh-all
