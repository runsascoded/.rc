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
args=()
base=
skip_push=
push_only=
while [ $# -gt 0 ]; do
  case "$1" in
    -b) shift; base="$1" ;;
    -n) skip_push=1 ;;
    -p) push_only=1 ;;
    *) args+=("$1") ;;
  esac
  shift
done
set -- "${args[@]}"
if [ $# -eq 0 ]; then
  set gh-server gl-all gl-server
fi
if [ -z "$base" ]; then
  base="$(git log -1 --format=%h gh/all)"
else
  # Dereference refs (e.g. HEAD~2)
  base="$(git log -1 --format=%h "$base")"
fi
head="$(git log -1 --format=%h gh-all)"
refs="$base..$head"
echo "\$refs: $refs" >&2

push() {
  if [ -n "$skip_push" ]; then
    echo "$(git symbolic-ref -q --short HEAD): skipping push" >&2
  else
    git push
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
    git fetch
    git rebase
    if ! cherry_pick; then
      while [ -f .git/CHERRY_PICK_HEAD ]; do
        du=()
        while IFS= read -r line; do
            du+=("$line")
        done < <(git status -s | grep '^DU' | cut -c4-)
        if [ ${#du[@]} -gt 0 ]; then
          cmd=(git rm -r --cached "${du[@]}")
          echo "Deleting modified non-server modules: ${cmd[*]}" >&2
          "${cmd[@]}"
        fi
        uu=()
        while IFS= read -r line; do
            uu+=("$line")
        done < <(git status -s | grep '^UU' | cut -c4-)
        if [ ${#uu[@]} -gt 0 ]; then
          echo "Found conflicting files:" >&2
          echo "${uu[@]}" >&2
          exit 1
        fi
        if ! git commit --no-edit; then
          git cherry-pick --skip
        else
          git cherry-pick --continue || true
        fi
      done
    fi
}

push

for arg in "$@"; do
  if [ -z "$push_only" ]; then
    checkout_and_cherrypick "$arg"
  else
    git checkout "$arg"
  fi
  push
done

git checkout gh-all
