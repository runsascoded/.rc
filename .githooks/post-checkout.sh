#!/usr/bin/env bash

set -e

# echo "post-checkout args: ($#): $*" >&2

if [ $# -ne 3 ]; then
  echo "Error: Invalid number of arguments passed to post-checkout hook ($#): $*" >&2
  exit 1
fi

# Extract parameters passed to post-checkout hook
# old_head="$1"
new_head="$2"
checkout_type="$3"

# Get the new branch name
new_branch="$(git branch --format '%(refname:short)' --points-at "$new_head" || true)"
if [ -z "$new_branch" ]; then
  exit 0
fi

submodules=("dvc" "parquet" "py")

# Function to handle submodule checkouts
submodules_checkout() {
  for submodule in "${submodules[@]}"; do
    if [ -d "$submodule" ]; then
      for target_branch in "$@"; do
        if git x "$submodule" show-ref --verify --quiet "refs/heads/$target_branch"; then
          echo "Checking out $submodule@$target_branch" >&2
          git x "$submodule" checkout "$target_branch"
          break
        fi
      done
    fi
  done
}

# Only proceed for branch checkouts (type 1)
if [ "$checkout_type" = "1" ]; then
  case "$new_branch" in
    gl-all | gl-server) submodules_checkout gl-main glm ;;
    gh-all | gh-server) submodules_checkout gh-main ghm ;;
    *) ;;
  esac
fi
