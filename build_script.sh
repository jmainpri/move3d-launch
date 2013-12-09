#!/bin/bash

move3d_root=$HOME/workspace/move3d

move3drecompile() 
{
    cd $move3d_root/libmove3d/build
    make install -j4
    cd $move3d_root/libmove3d-hri/build
    make install -j4
    cd $move3d_root/libmove3d-planners/build
    make install -j4
    cd $move3d_root/move3d-studio/build_move3d-qt
    make install -j4
    cd $move3d_root
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
    cd $move3d_root
}
