#!/usr/bin/env bash

if [ $# -eq 1 ]; then
	args="$(splt , $1)"
else
	args="$@"
fi

args="$(prepend '$' $args | joyn ,)"
awk '{print '"$args"'}'
