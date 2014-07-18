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

$debug  move3d-qt-studio -setgui -c pqp -f ../../assets/Collaboration/TwoHumansTableKinect.p3d  -params ../move3d-launch/parameters/params_collaboration_planning_bis -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_kinect.sce 
# -launch HumanPlanning 

