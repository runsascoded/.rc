#!/usr/bin/env bash

set -e

err() {
  echo "$*" >&2
}

cur="$(git current-branch)"
if [ "$cur" != "gh-all" ]; then
    err "Expected to be on gh-all branch"
    exit 1
fi

git submodule-auto-commit -a
for b in gh-server gl-all gl-server; do
  git checkout $b
  git submodule-auto-commit -a
done
git checkout gh-all

rc-update-branches.sh -p
