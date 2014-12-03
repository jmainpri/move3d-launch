#!/bin/sh

for arg in "$@"
do
    case $arg in
    	"--bg" )
			background="-launch PlanSequence ";; # -nogui
        "--debug" )
           debug="gdb -ex run --args";;
        "--other" )
           END_DATE=$arg;;
   esac
done

$debug  move3d-qt-studio -setgui $background -c pqp -f ../../assets/Collaboration/HumanAndRobotTableMocap.p3d  -params ../move3d-launch/parameters/params_pr2_collaboration_aterm -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_pr2_aterm.sce
# -launch RunIOC -nogui

