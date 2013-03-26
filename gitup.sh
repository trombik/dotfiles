#!/bin/sh
git init
git remote add origin git@github.com:trombik/dotfiles.git
git pull origin master
git pull
git branch -u origin/master
git reset HEAD .
