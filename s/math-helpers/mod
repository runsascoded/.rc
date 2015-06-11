#!/usr/bin/env bash

if [ $# -eq 2 ]; then
  js "$1 % $2"
else
  while read -r line; do
    js "$line % $1"
  done
fi
