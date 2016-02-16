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
#                                    Jim Mainprice on Wednesday January 03 2016

import os
from os import path
from move3d_basic import *
from ioc_leave_one_out_trajectories import *


class Move3DIOCHumanRobot:
    def __init__(self):
        self.run_block_ids = []
        self.run_robot_trajs_dic = {}

    def list_all_runs(self):
        self.run_block_ids = []
        self.run_robot_trajs_dic = {}

        save_dir = '/usr/local/jim_local/Dropbox/move3d/catkin_ws_move3d/src/'
        save_dir += 'hrics-or-rafi/python_module/'
        save_dir += 'bioik/user_human_robot_experiment/tro_experiment'

        blocks = [x for x in os.listdir(save_dir)
                  if not path.isfile(save_dir + os.sep + x)]

        for b in blocks:

            block_dir = save_dir + os.sep + b
            run_ids = sorted([x for x in os.listdir(block_dir)
                              if not path.isfile(block_dir + os.sep + x)])
            for run in run_ids:

                id_dir = block_dir + os.sep + run

                human_run_dir = id_dir + os.sep + "human"
                robot_run_dir = id_dir + os.sep + "robot"

                if (os.path.exists(human_run_dir) and
                        os.path.exists(robot_run_dir)):

                    human_trajs = [x for x in os.listdir(human_run_dir)
                                   if (human_run_dir +
                                       os.sep + x).endswith('.traj')]

                    robot_trajs = [x for x in os.listdir(robot_run_dir)
                                   if (robot_run_dir +
                                       os.sep + x).endswith('.traj')]

                    if len(human_trajs) != len(robot_trajs):
                        print "not the same number of trajs!!!"
                        print(' ** block : {b}'.format(**locals()))
                        print(' ** run : {run}'.format(**locals()))
                        print(' ** human_trajs nb : {}'.format(
                            len(human_trajs)))
                        print(' ** robot_trajs nb : {}'.format(
                            len(robot_trajs)))
                    else:
                        if len(robot_trajs) > 1:
                            # print('blocks : {b}, run id: {id}'.format(
                            # **locals()))
                            run_block_id = b + os.sep + run
                            self.run_robot_trajs_dic[run_block_id] = (
                                robot_trajs)
                            self.run_block_ids.append(run_block_id)

    def run_stomp(self, run):

        move3d_test = Move3DIOCHumanTrajectories("human_robot_experiment")
        move3d_test.human_robot_run = run  # of the form block0/0
        move3d_test.loo_splits = []
        for s in self.run_robot_trajs_dic[run]:
            move3d_test.loo_splits.append(s[0:11])

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

        for proc in jobs:
            proc.join()

        print "return values :"
        print return_dict.values()


# run the server
if __name__ == "__main__":

    ioc = Move3DIOCHumanRobot()
    ioc.list_all_runs()

    # ioc.run_stomp("block3/7")

    # run_block_ids= []
    # run_block_ids.append("block4/10")
    # run_block_ids.append("block11/5")
    # run_block_ids.append("block0/4")
    # run_block_ids.append("block8/6")
    # run_block_ids.append("block8/12")

    # for run_id in run_block_ids:
    #    ioc.run_stomp(run_id)

    for run_id in ioc.run_block_ids:
        ioc.run_stomp(run_id)