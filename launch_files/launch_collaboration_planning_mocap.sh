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
	         seed="-s 1391184849";;
      "--other" )
           END_DATE=$arg;;
   esac
done

$debug move3d-qt-studio -setgui $background $seed -c pqp -f ../../assets/Collaboration/TwoHumansTableMocap.p3d  -params ../move3d-launch/parameters/params_collaboration_planning_mocap -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_mocap_resized.sce
# -launch RunIOC -nogui

