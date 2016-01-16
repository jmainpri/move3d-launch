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


$debug move3d-qt-studio -setgui $background $seed -setgui -c pqp \
-launch runStomp \
-f ../../assets/Achile/HumanTestBioWithObstacle.p3d \
-params ../move3d-launch/parameters/params_human_stomp_ik \
-sc ../../assets/Achile/SCENARII/HeraklesBioStompIK.sce
# -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_reach.sce
# -launch HumanPlanning 
# -launch runStomp
# -s 1452275371 (weird issue with IK)
