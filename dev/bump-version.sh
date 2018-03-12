#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

echo "Current in branch [$current_branch]"

git stash
git checkout development
git pull

##Android
echo "$(awk '{sub(/versionCode [[:digit:]]+$/,"versionCode "$2+1)}1' android/app/build.gradle)" > android/app/build.gradle

git add android/app/build.gradle

git commit -m "Version bump [skip ci]";

git push

git checkout ${current_branch}

git stash apply