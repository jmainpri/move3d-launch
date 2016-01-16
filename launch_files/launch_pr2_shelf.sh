#!/bin/bash

for arg in "$@"
do
    case $arg in
        "--debug" )
           debug="gdb -ex run --args";;
        "--other" )
           END_DATE=$arg;;
   esac
done

$debug move3d-qt-studio -launch runStomp  \
-setgui -params ../move3d-launch/parameters/params_pr2_shelf \
-c pqp -f ../../assets/CostHriFunction/PR2/Pr2_Shelf.p3d \
-sc ../../assets/CostHriFunction/PR2/SCENARIOS/Pr2ShelfIK.sce
