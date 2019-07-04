#! /bin/bash

for bb in work wsl vm ; do
  git branch -D $bb
  git checkout $bb
  git merge master
done
git checkout master
