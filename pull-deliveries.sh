#!/bin/bash

dirlist=$(find ./deliveries -mindepth 1 -maxdepth 1 -type d)

for dir in $dirlist
do
  (
  echo $dir
  cd $dir
  git pull
  )
done
