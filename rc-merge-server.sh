#!/usr/bin/env bash

set -ex

git checkout gh-server
git merge --no-edit gh-all

git push gh

git checkout gl-all
git merge --no-edit gh-all

git checkout gl-server
git merge --no-edit gl-all

git push gl

git checkout gh-all
