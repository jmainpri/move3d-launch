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
	         seed="-s 1453465123";;
       "--other" )
           END_DATE=$arg;;
       "--run" )
           seed="-s 1453465123"
           background="-launch RunIOC";;
   esac
done

$debug  move3d-qt-studio -setgui $background \
$seed -c pqp -f ../../assets/Collaboration/TwoHumansUserExp.p3d \
-params ../move3d-launch/parameters/params_biomech_test_sampling_trajs


# range[0] for dof Pelvis 0.03
# range[1] for dof Pelvis 0.03
# range[2] for dof Pelvis 0.04
# range[3] for dof Pelvis 0.02
# range[4] for dof Pelvis 0.02
# range[5] for dof Pelvis 0.12
# range[6] for dof TorsoX 0.16
# range[7] for dof TorsoZ 0.12
# range[8] for dof TorsoY 0.14
# range[9] for dof rShoulderTransX 0.02
# range[10] for dof rShoulderTransY 0.02
# range[11] for dof rShoulderTransZ 0.02
# range[12] for dof rShoulderY1 0.87
# range[13] for dof rShoulderX 0.32
# range[14] for dof rShoulderY2 0.87
# range[15] for dof rArmTrans 0.03
# range[16] for dof rElbowZ 0.32
# range[17] for dof rElbowX 0.17
# range[18] for dof rElbowY 1.05
# range[19] for dof rForeArmTrans 0.02
# range[20] for dof rWristZ 0.99
# range[21] for dof rWristX 0.53
# range[22] for dof rWristY 1.04
