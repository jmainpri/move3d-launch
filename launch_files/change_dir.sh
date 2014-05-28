#!/bin/bash

for file in $(grep -il "../move3d-launch" launch_*)
  do
   sed -e "s/..\/..\/move3d-launch/..\/move3d-launch/ig" $file > /tmp/tempfile.tmp
   # sed -e "s/..\/assets/..\/..\/assets/ig" $file > /tmp/tempfile.tmp
   mv /tmp/tempfile.tmp $file
done