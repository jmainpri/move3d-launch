#!/bin/sh

for arg in "$@"
do
    case $arg in
    	"--bg" )
			background="-launch runStomp -nogui";;
        "--debug" )
           debug="gdb -ex run --args";;
        "--valgrind" )
           debug="valgrind --error-limit=no ";;
        "--other" )
           END_DATE=$arg;;
   esac
done

$debug move3d-qt-studio -setgui $background -params ../move3d-launch/parameters/params_pr2_shelf_ik -c pqp -f ../../assets/CostHriFunction/PR2/Pr2_Shelf_IK.p3d -sc ../../assets/CostHriFunction/PR2/SCENARIOS/Pr2ShelfIKKitchen.sce
