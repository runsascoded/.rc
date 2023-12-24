#!/usr/bin/env bash

set -ex

git checkout gh-server
git merge --no-edit gh-all
git push gh
git push gl
git checkout gh-all
