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

set -e

err() {
  echo "$*" >&2
}

cur="$(git current-branch)"
if [ "$cur" != "gh-all" ]; then
    err "Expected to be on gh-all branch"
    exit 1
fi

usage() {
  err "Usage: $0 [-b <base>] [-f] [-n] [-p] [<repos...>]"
  err
  err "  -b <base>  Use <base> as the base commit (default: gh/all)"
  err "  -f         Force push"
  err "  -n         Skip push"
  err "  -p         Push only"
  exit 1
}

base=
push_args=()
push_dry_run=
push_only=
while getopts "b:fnp" opt; do
  case "$opt" in
    b) base="$OPTARG" ;;
    f) push_args+=(-f) ;;
    n) push_dry_run=1 ; push_args+=(-n) ;;
    p) push_only=1 ;;
    \?) usage ;;
  esac
done
shift $((OPTIND-1))

set -x

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
err "\$refs: $refs"

push() {
  if [ -n "$push_dry_run" ]; then
    err "$(git symbolic-ref -q --short HEAD): dry-run push"
  fi
  git push "${push_args[@]}"
}

cherry_pick() {
  if [ "$base" == "$head" ]; then
    err "No new commits to cherry-pick"
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
        err "Deleting modified non-server modules: ${cmd[*]}"
        "${cmd[@]}"
      fi
      uu=()
      while IFS= read -r line; do
          uu+=("$line")
      done < <(git status -s | grep '^UU' | cut -c4-)
      if [ ${#uu[@]} -gt 0 ]; then
        err "Found conflicting files:"
        err "${uu[@]}"
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
