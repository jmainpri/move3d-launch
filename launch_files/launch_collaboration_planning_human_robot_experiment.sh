#!/bin/sh

for arg in "$@"
do
    case $arg in
    	"--bg" )
	   background="-launch RunIOC -nogui";;
        "--debug" )
           debug="gdb -ex run --args";;
        "--valgrind" )
           debug="valgrind";;
	"--seed" )
	   seed="-s 1437922374";;
        "--other" )
           END_DATE=$arg;;
   esac
done

$debug  move3d-qt-studio -setgui $background $seed -c pqp -f ../../assets/Collaboration/HumanAndRobotTableLogan.p3d  -params ../move3d-launch/parameters/params_collaboration_planning_human_robot_experiment -sc ../../assets/Collaboration/SCENARIOS/collaboration_human_robot_experiment.sce
# -launch RunIOC -nogui

