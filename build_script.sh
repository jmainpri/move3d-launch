#!/bin/bash

move3d_root=$HOME/Dropbox/move3d

move3drecompile() 
{
    echo "build release"
    cd $move3d_root/libmove3d/build_release
    make install -j4
#    cd $move3d_root/libmove3d-hri/build_release
#    make install -j4
    cd $move3d_root/libmove3d-planners/build_release
    make install -j4
    cd $move3d_root/move3d-studio/build_debug
    make install -j4
    cd $move3d_root
    echo "DONE!!!"
}

move3dpull() 
{
    cd $move3d_root/libmove3d
    git pull
    cd $move3d_root/libmove3d-hri
    git pull
    cd $move3d_root/libmove3d-planners
    git pull
    cd $move3d_root/move3d-studio
    git pull
    cd $move3d_root/move3d-launch
    git pull
    cd $move3d_root
}
