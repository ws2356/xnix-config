#! /bin/bash

for bb in wsl vm ; do
  git branch -D $bb
  git checkout $bb
  git merge master
done
git checkout master
