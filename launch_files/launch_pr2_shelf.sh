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

seed="-s 1453927008"

$debug move3d-qt-studio $seed -launch runStomp  \
-setgui -params ../move3d-launch/parameters/params_pr2_shelf \
-c pqp -f ../../assets/CostHriFunction/PR2/Pr2_Shelf.p3d \
-sc ../../assets/CostHriFunction/PR2/SCENARIOS/Pr2ShelfIK.sce

# 72, time: 5.449551, cost: 59.467811

# COLLISION POINTS :
# all_points[0] : right-Arm3
# all_points[1] : right-Arm3
# all_points[2] : right-Arm3
# all_points[3] : right-Arm3
# all_points[4] : right-Arm4
# all_points[5] : right-Arm4
# all_points[6] : right-Arm4
# all_points[7] : right-Arm4
# all_points[8] : right-Arm5
# all_points[9] : right-Arm5
# all_points[10] : right-Arm5
# all_points[11] : right-Arm5
# all_points[12] : right-Arm7
# all_points[13] : right-Arm7
# all_points[14] : right-Arm7
# all_points[15] : fingerJointGripper_0
# all_points[16] : fingerJointGripper_0
# all_points[17] : fingerJointGripper_0
# all_points[18] : fingerJointGripper_0
# all_points[19] : fingerJointGripper_0
# all_points[20] : right-grip2
# all_points[21] : right-grip2
# all_points[22] : right-grip2
# all_points[23] : right-grip2
# all_points[24] : right-grip2