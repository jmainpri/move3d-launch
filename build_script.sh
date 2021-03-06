#!/bin/bash

move3d_root=`pwd`/..
nb_cores=30

move3drecompile() 
{
    echo "build release"
    cd $move3d_root/libmove3d/build_release
    make install -j$nb_cores
    cd $move3d_root/libmove3d-hri/build_release
    make install -j$nb_cores
    cd $move3d_root/libmove3d-planners/build_debug
    make install -j$nb_cores
    cd $move3d_root/move3d-studio/build_debug
    make install -j$nb_cores
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


case "$1" in

    'compile' )
        move3drecompile
    ;;

    'pull' )
        move3dpull
    ;;

    *)
        ShowUsage
        exit 1
    ;;
esac
