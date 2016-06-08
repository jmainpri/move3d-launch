#!/usr/bin/env python

# Copyright (c) 2015 Max Planck Institute
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without   fee is hereby granted, provided   that the above  copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS  SOFTWARE INCLUDING ALL  IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR  BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR  ANY DAMAGES WHATSOEVER RESULTING  FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION,   ARISING OUT OF OR IN    CONNECTION WITH THE USE   OR
# PERFORMANCE OF THIS SOFTWARE.
#
#                                           Jim Mainprice on Sunday May 17 2015

import multiprocessing
import subprocess
import os
import sys
import shlex
from move3d_basic import *


class Matlab:
    def __init__(self):
        self.id = 0

    def launch(self, regularizer):
        self.id += 1

        folder = "/usr/local/jim_local/Dropbox/move3d/move3d-launch/matlab/ioc/"
        command = str(
            "matlab -nojvm -r \"cd {}; ioc_user_experiment({});exit\" ").format(
            folder, regularizer)

        # Launch the program in a new process
        # it has to be called with a name as first argument
        p = multiprocessing.Process(target=self.run,
                                    args=("matlab_process", command))
        p.start()
        return p

    def run(self, name, command):
        print name + " running : " + command
        os.system(command)


def run_test(name, parameter_filename_tmp, args):
    print "ENTER RUN TEST" + name

    # Get home move3d
    home_move3d = os.environ['HOME_MOVE3D']
    os.chdir(home_move3d)

    p3d_file = "../assets/Collaboration/TwoHumansUserExp.p3d"
    sce_file = "../assets/Collaboration/SCENARIOS/collaboration_test_user_experiment.sce"

    # Run replanning
    options = ""
    options += " -nogui "
    options += " -s 1437922374 "
    options += " -launch SphereIOC "
    options += " -setgui"
    options += " -params " + parameter_filename_tmp
    options += " -c pqp"
    options += " -f " + p3d_file
    options += " -sc " + sce_file

    move3d_set_variable(parameter_filename_tmp, 'intParameter\ioc_phase', '1')
    move3d_set_variable(parameter_filename_tmp,
                        'intParameter\ioc_sample_iteration', '300')
    move3d_set_variable(parameter_filename_tmp,
                        'boolParameter\ioc_exit_after_run', 'true')
    move3d_set_variable(parameter_filename_tmp,
                        'boolParameter\ioc_split_motions', 'true')
    move3d_set_variable(parameter_filename_tmp,
                        'boolParameter\ioc_training_dataset', 'true')

    debug = ""
    # debug = "gdb -ex run --args "

    subprocess.call(shlex.split(debug + "move3d-qt-studio" + options))


def run_move3d(move3d, function, return_dict):
    # Set move3d arguments
    args = []

    parameter_filename = "params_collaboration_planning_user_experiment"

    # Launch copies the parameter file and then spawns a process and calls
    # the function with the new tmp file as argument
    return move3d.launch(parameter_filename, function, args, return_dict)


def run_user_study_train_motions():
    move3d = Move3D()

    manager = multiprocessing.Manager()
    return_dict = manager.dict()

    # Sampling
    jobs = []
    jobs.append(run_move3d(move3d, run_test, return_dict))

    for proc in jobs:
        proc.join()

    print "done!"

    jobs = []
    # regularizers = [0]
    regularizers = [0, 0.01, 0.05, 0.1, 0.5, 1, 5, 10, 50, 100]

    matlab_test = Matlab()
    for r in regularizers:
        jobs.append(matlab_test.launch(r))

    for proc in jobs:
        proc.join()

    print "All process have joined"


if __name__ == "__main__":
    run_user_study_train_motions()
