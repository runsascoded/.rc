#!/usr/bin/env bash

set -eo pipefail

for arg in "$@"; do
  mapfile -t remotes < <(gx "$arg" remote-list-fetch-urls)
  gh_https_url="https://github.com/ryan-williams/$arg-helpers"
  echo "$arg: ${#remotes[@]} remotes: ${remotes[*]}"
  if [ "${#remotes[@]}" -eq 1 ] && [ "${remotes[0]%.git}" == "$gh_https_url" ]; then
    echo "Updating $arg remotes:" >&2
    mapfile -t remote_names < <(gx "$arg" remote)
    remote="${remote_names[0]}"
    set -x
    gx "$arg" rr "$remote" gh
    gx "$arg" rat gh
    gx "$arg" ra gl git@gitlab.com:runsascoded/rc/$arg.git
    set +x
  fi
done
