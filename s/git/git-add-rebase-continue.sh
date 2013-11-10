#!/bin/sh

git add $@ && git rebase --continue
