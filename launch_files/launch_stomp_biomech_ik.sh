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

seed="-s 1453983481"

$debug move3d-qt-studio $background $seed -setgui -c pqp \
-launch runStomp \
-f ../../assets/Achile/HumanTestBioWithObstacle.p3d \
-params ../move3d-launch/parameters/params_human_stomp_ik \
-sc ../../assets/Achile/SCENARII/HeraklesBioStompIK.sce
# -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_reach.sce
# -launch HumanPlanning 
# -launch runStomp


# CONVERGENCE:
# 144, time: 12.790037, cost: 18.095203

# COLLISION POINTS :
# all_points[0] : rShoulderY2
# all_points[1] : rShoulderY2
# all_points[2] : rShoulderY2
# all_points[3] : rShoulderY2
# all_points[4] : rShoulderY2
# all_points[5] : rShoulderY2
# all_points[6] : rElbowY
# all_points[7] : rElbowY
# all_points[8] : rElbowY
# all_points[9] : rElbowY
# all_points[10] : rElbowY
# all_points[11] : rElbowY
# all_points[12] : rElbowY
# all_points[13] : rWristY
# all_points[14] : rWristY
# all_points[15] : rWristY
# all_points[16] : rWristY