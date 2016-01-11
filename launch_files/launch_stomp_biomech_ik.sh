#!/bin/bash
move3d-qt-studio -setgui -c pqp \
-f ../../assets/Achile/HumanTestBioWithObstacle.p3d \
-params ../move3d-launch/parameters/params_human_stomp_ik \
-sc ../../assets/Achile/SCENARII/HeraklesBioStompIK.sce
# -sc ../../assets/Collaboration/SCENARIOS/collaboration_test_reach.sce
# -launch HumanPlanning 
# -launch runStomp
# -s 1452275371 (weird issue with IK)
