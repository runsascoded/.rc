#!/usr/bin/env bash

if [ $# -gt 0 ]; then
  for arg in "$@"; do
    node -p -e "$arg"
  done
else
  while read -r line; do
    node -p -e "$line"
  done
fi

