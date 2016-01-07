#!/usr/bin/env python

from move3d_basic import *
import subprocess
import os
import sys
import shlex

class Move3DTest():

    def __init__(self):

        self.function = "Diffusion"
        self.p3d_file = "../assets/CostEnv/Montains3/Montains3.p3d"

    def run_trrt(self, name, parameter_filename, args):

        print "start : ", name
        print "parameter file : ", parameter_filename
        print "args : ", args

        # Get home move3d
        home_move3d = os.environ['HOME_MOVE3D']
        os.chdir(home_move3d)

        options = ""
        # options += " -nogui "
        options += " -launch " + self.function
        options += " -setgui "
        options += "-params " + parameter_filename
        options += " -c pqp"
        options += " -f " + self.p3d_file

        subprocess.call(shlex.split("move3d-qt-studio" + options))

def run_multi_process():

    move3d = Move3D()
    move3d_test = Move3DTest()

    for i in range(2):
        # Launch copies the parameter file it then spawns a process and calls
        # the function with the new tmp file as argument
        move3d.launch('params_trrt_costmap', move3d_test.run_trrt)

    sys.stdin.readline()

# run test
if __name__ == "__main__":
    run_multi_process()