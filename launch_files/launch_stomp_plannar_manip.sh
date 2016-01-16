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


$debug move3d-qt-studio -launch runStomp  -setgui \
-params ../move3d-launch/parameters/params_stomp_plannar_manip \
-c pqp \
-f ../../assets/CostDistanceKCD/3dof/manipulator.p3d \
-sc ../../assets/CostDistanceKCD/3dof/SCENARIO/manip_stomp.sce
# manip_stomp.sce or manip.sce
