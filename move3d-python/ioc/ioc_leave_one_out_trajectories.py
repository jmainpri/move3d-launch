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
from numpy.distutils.system_info import tmp

from move3d_basic import *
import multiprocessing
import subprocess
import os
import sys
import shlex


class Move3DIOCHumanTrajectories:
    def __init__(self, test):

        self.function = "SphereIOC"
        self.human_robot_run = ""

        # ----------------------------------------------

        p3d_dir = "../assets/Collaboration/"

        if test == "september":
            self.p3d_file = p3d_dir + "TwoHumansTableMocap.p3d"
            self.sce_file = p3d_dir + "SCENARIOS/collaboration_aterm.sce"
            self.id = 0
            self.loo_splits = [
                "[0446-0578]",
                "[0444-0585]",
                "[0489-0589]",
                "[0525-0657]",
                "[0780-0871]",
                "[1537-1608]",
                "[2711-2823]"]
            # self.loo_splits = ["[0444-0585]"]
            self.param_file = "params_collaboration_planning_aterm"

        elif test == "february":
            self.p3d_file = p3d_dir + "TwoHumansTableMocap.p3d"
            self.sce_file = (
                p3d_dir + "SCENARIOS/collaboration_test_mocap_resized.sce")
            self.id = 0
            self.loo_splits = [
                "[0649-0740]",
                "[1282-1370]",
                "[1593-1696]",
                "[1619-1702]",
                "[1696-1796]"]
            self.param_file = "params_collaboration_planning_mocap"

        elif test == "userstudy":
            self.p3d_file = p3d_dir + "TwoHumansUserExp.p3d"
            self.sce_file = (
                p3d_dir + "SCENARIOS/collaboration_test_user_experiment.sce")
            self.id = 0
            # splelf.loo_splits = ["[0904-1027]"]
            self.loo_splits = [
                "[0612-0703]",
                "[0904-1027]",
                "[0921-1010]",
                "[1018-1131]",
                "[1159-1255]",
                "[1197-1363]",
                "[1248-1428]",
                "[1496-1591]",
                "[1595-1694]",
                "[1639-1779]",
                "[1648-1802]",
                "[1809-1897]",
                "[1881-1970]",
                "[1896-2006]",
                "[2020-2116]",
                "[2142-2234]",
                "[2259-2349]",
                "[2483-2568]",
                "[2550-2642]",
                "[2556-2697]",
                "[3124-3230]"]

            # self.loo_splits = ["[1896-2006]"]
            # self.loo_splits = ["[3124-3230]"]
            # self.loo_splits = ["[0904-1027]"]
            # self.loo_splits = ["[1248-1428]"]
            # self.loo_splits = ["[2556-2697]"]
            # self.loo_splits = ["[0921-1010]"]
            # self.loo_splits = ["[1496-1591]"]
            # self.loo_splits = ["[0612-0703]"]
            # self.loo_splits = ["[2020-2116]"]
            # self.loo_splits = ["[1648-1802]"]
            # self.loo_splits = ["[1197-1363]"]

            self.param_file = "params_collaboration_planning_user_experiment"

        elif test == "human_robot_experiment":
            self.p3d_file = p3d_dir + "HumanAndRobotTableLogan.p3d"
            self.sce_file = (
                p3d_dir +
                "SCENARIOS/collaboration_human_robot_experiment_tro.sce")
            self.id = 0

            self.loo_splits = [
                "robot_000.t",
                "robot_001.t",
                "robot_002.t",
                "robot_003.t",
                "robot_004.t",
                "robot_005.t",
                "robot_006.t",
                "robot_007.t",
                "robot_008.t",
                "robot_009.t",
                "robot_010.t",
                "robot_011.t",
                "robot_012.t",
                "robot_013.t",
                "robot_014.t",
                "robot_015.t",
                "robot_016.t"
            ]
            self.param_file = "params_collaboration_planning_human_robot_experiment"

    def run_test(self, parameter_filename):

        # Get home move3d
        home_move3d = os.environ['HOME_MOVE3D']
        os.chdir(home_move3d)

        # Run replanning
        options = ""
        options += " -nogui "
        options += " -s 1437922374 "
        options += " -launch " + self.function
        options += " -setgui"
        options += " -params " + parameter_filename
        options += " -c pqp"
        options += " -f " + self.p3d_file
        options += " -sc " + self.sce_file

        debug = ""
        # debug = "gdb -ex run --args "
        # debug = "gdb -ex \"set disable-randomization off\" -ex run --args "
        debug = "gdb -ex run --args "
        command = shlex.split(debug + "move3d-qt-studio" + options)

        p = subprocess.Popen(command, stdin=sys.stdin, stdout=sys.stdout)
        p.wait()
        # p = subprocess.call(command)

    def stomp_noreplan(self, name, parameter_filename, args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'false')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def stomp_baseline_conservative_noreplan(self, name, parameter_filename,
                                             args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_conservative_baseline', 'true')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def stomp_baseline_agressive_noreplan(self, name, parameter_filename, args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_conservative_baseline', 'false')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def stomp_replan(self, name, parameter_filename, args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'false')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def stomp_baseline_conservative_replan(self, name, parameter_filename,
                                           args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_conservative_baseline', 'true')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def stomp_baseline_agressive_replan(self, name, parameter_filename, args):

        print "start : ", name
        print " -- args : ", args

        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_no_replanning', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_use_baseline', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_conservative_baseline', 'false')

        self.set_basic_parameters(parameter_filename, args)

        self.run_test(parameter_filename)

    def run_one_test(self, move3d, function, loo_split, return_dict):

        self.id += 1

        if self.human_robot_run == "":
            tmp_folder = move3d.folder_tmp_files + "/trajectories_process/"
            tmp_folder += function.__name__ + "/"
            tmp_folder += loo_split
        else:
            tmp_folder = move3d.folder_tmp_files + "/trajectories_process/"
            tmp_folder += self.human_robot_run + "/"
            tmp_folder += function.__name__ + "/"
            tmp_folder += loo_split

        print "make tmp folder : ", tmp_folder

        # Make trajectory temporary folder
        os.makedirs(tmp_folder)

        # Set move3d arguments
        args = [loo_split, tmp_folder]

        # Launch copies the parameter file and then spawns a process and calls
        # the function with the new tmp file as argument
        return move3d.launch(self.param_file, function, args, return_dict)

    def set_basic_parameters(self, parameter_filename, args):
        # Get the splits for Leave One Out
        loo_splits = args[0]
        traj_folder = args[1]

        move3d_set_variable(parameter_filename,
                            'stringParameter\ioc_tmp_traj_folder', traj_folder)
        move3d_set_variable(parameter_filename,
                            'stringParameter\ioc_traj_split_name', loo_splits)

        # WARNING set to one for normal sampling, 6 simulation
        move3d_set_variable(parameter_filename,
                            'intParameter\ioc_phase', '6')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_exit_after_run', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_split_motions', 'false')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_parallel_job', 'true')
        move3d_set_variable(parameter_filename,
                            'boolParameter\ioc_training_dataset', 'false')
        move3d_set_variable(parameter_filename,
                            'drawDisabled', 'true')

        if self.human_robot_run != "":
            move3d_set_variable(parameter_filename,
                                'stringParameter\ioc_human_robot_run',
                                self.human_robot_run)


def run_icra_feb_motions():
    # ----------------------------------------------
    # SELECT the data set here !!!!
    test = "september"

    move3d_test = Move3DIOCHumanTrajectories(test)
    move3d = Move3D()

    manager = multiprocessing.Manager()
    return_dict = manager.dict()

    jobs = []

    for split in move3d_test.loo_splits:
        print "Launch split : " + split

        jobs.append(
            move3d_test.run_one_test(
                move3d, move3d_test.stomp_noreplan,
                split, return_dict))
        jobs.append(
            move3d_test.run_one_test(
                move3d,
                move3d_test.stomp_baseline_agressive_noreplan,
                split, return_dict))
        jobs.append(move3d_test.run_one_test(
            move3d,
            move3d_test.stomp_baseline_conservative_noreplan,
            split, return_dict))
        jobs.append(move3d_test.run_one_test(
            move3d, move3d_test.stomp_replan,
            split, return_dict))
        jobs.append(move3d_test.run_one_test(
            move3d,
            move3d_test.stomp_baseline_agressive_replan,
            split, return_dict))
        jobs.append(move3d_test.run_one_test(
            move3d,
            move3d_test.stomp_baseline_conservative_replan,
            split, return_dict))

    for proc in jobs:
        proc.join()

    print "return values :"
    print return_dict.values()


# run test
if __name__ == "__main__":
    run_icra_feb_motions()
