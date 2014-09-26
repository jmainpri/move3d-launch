#!/bin/sh

for arg in "$@"
do
    case $arg in
        "--debug" )
           debug="gdb -ex run --args";;
        "--other" )
           END_DATE=$arg;;
   esac
done

$debug  move3d-qt-studio -setgui -c pqp -f ../../assets/Collaboration/TwoHumansTableMocap.p3d  -params ../move3d-launch/parameters/params_collaboration_planning_mocap -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_mocap.sce 
# -nogui -launch RunIOC  

