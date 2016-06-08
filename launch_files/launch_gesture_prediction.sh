#!/bin/bash  
move3d-qt-studio \
-launch ClassifyMotions -nogui -setgui \
-params ../move3d-launch/parameters/params_gesture_prediction -c pqp \
-f ../../assets/Gesture/HumanTestM.p3d \
-sc ../../assets/Gesture/SCENARIOS/Human.sce
