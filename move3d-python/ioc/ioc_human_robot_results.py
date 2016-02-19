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
# Jim Mainprice on Wednesday January 03 2016

# from __future__ import print_function  # needs to be first statement in file
import numpy as np
from os import path
from ioc_leave_one_out_trajectories import *
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
import math


def plot_joint_center_and_task_space_boxes(
        scores_run_joint_0,
        scores_run_task_0,
        nb_runs_to_consider,
        scores_run_joint_1,
        scores_run_task_1,
        scores_cut_off_run_joint_ioc,
        scores_cut_off_run_task_ioc):
    # Generate some data from five different probability distributions,
    # each with different characteristics. We want to play with how an IID
    # bootstrap resample of the data preserves the distributional
    # properties of the original sample, and a boxplot is one visual tool
    # to make this assessment


    # randomDists = ['Normal(1,1)', ' Lognormal(1,1)', 'Exp(1)', 'Gumbel(6,4)',
    #                'Triangular(2,9,11)']

    N = 500

    data = []
    for a, b, c in zip(
            scores_run_task_1,
            scores_run_task_0,
            scores_cut_off_run_task_ioc):
        data.append(a)
        data.append(b)
        data.append(c)

    numDists = len(data)

    fig, ax1 = plt.subplots(figsize=(10, 6))
    fig.canvas.set_window_title('A Boxplot Example')
    plt.subplots_adjust(left=0.075, right=0.95, top=0.9, bottom=0.25)

    bp = plt.boxplot(data, notch=0, sym='+', vert=1, whis=1.5)
    plt.setp(bp['boxes'], color='black')
    plt.setp(bp['whiskers'], color='black')
    plt.setp(bp['fliers'], color='red', marker='+')

    # Add a horizontal grid to the plot, but make it very light in color
    # so we can use it for reading data values but not be distracting
    ax1.yaxis.grid(True, linestyle='-', which='major', color='lightgrey',
                   alpha=0.5)

    # Now fill the boxes with desired colors
    # YELLOW, BLUE, GREEN
    boxColors = ['#DCF057', '#5770F0', '#6CD85B']
    numBoxes = numDists
    medians = list(range(numBoxes))
    for i in range(numBoxes):
        box = bp['boxes'][i]
        boxX = []
        boxY = []
        for j in range(5):
            boxX.append(box.get_xdata()[j])
            boxY.append(box.get_ydata()[j])
        boxCoords = list(zip(boxX, boxY))
        # Alternate between Dark Khaki and Royal Blue
        k = i % len(boxColors)
        boxPolygon = Polygon(boxCoords, facecolor=boxColors[k])
        ax1.add_patch(boxPolygon)
        # Now draw the median lines back over what we just filled in
        med = bp['medians'][i]
        medianX = []
        medianY = []
        for j in range(2):
            medianX.append(med.get_xdata()[j])
            medianY.append(med.get_ydata()[j])
            plt.plot(medianX, medianY, 'k')
            medians[i] = medianY[0]
        # Finally, overplot the sample averages, with horizontal alignment
        # in the center of each box
        plt.plot([np.average(med.get_xdata())], [np.average(data[i])],
                 color='w', marker='*', markeredgecolor='k')

    # Hide these grid behind plot objects
    ax1.set_axisbelow(True)
    ax1.set_title(
        'Task space evolution')
    ax1.set_xlabel('Distribution')
    ax1.set_ylabel('DTW score')

    # Set the axes ranges and axes labels
    ax1.set_xlim(0.5, numDists + 0.5)
    top = 80
    bottom = -5
    ax1.set_ylim(bottom, top)

    names = ['Baseline 1', ' Baseline 0', 'IOC']
    all_ticks = []
    for i in range(len(data)):
        print i % 3
        all_ticks.append(
            names[i % len(names)] + " (run " + str(i / len(names)+1) + ")")

    xtickNames = plt.setp(ax1, xticklabels=all_ticks)
    plt.setp(xtickNames, rotation=45, fontsize=8)

    # Finally, add a basic legend
    # plt.figtext(0.80, 0.08, str(N) + ' Random Numbers',
    #             backgroundcolor=boxColors[0], color='black', weight='roman',
    #             size='x-small')
    # plt.figtext(0.80, 0.045, 'IID Bootstrap Resample',
    #             backgroundcolor=boxColors[1],
    #             color='white', weight='roman', size='x-small')
    # plt.figtext(0.80, 0.015, '*', color='white', backgroundcolor='silver',
    #             weight='roman', size='medium')
    # plt.figtext(0.815, 0.013, ' Average Value', color='black', weight='roman',
    #             size='x-small')

    plt.show()


def plot_joint_center_and_task_space(
        nb_runs_to_consider,
        nb_blocks_per_runs,
        sum_all_scores,
        sum_all_scores_squared,
        color_jc,
        color2_ts,
        method):
    joint_centers = []
    joint_centers_stdev = []
    task_space = []
    task_space_stdev = []

    scaling = 3.4

    runs = range(nb_runs_to_consider)
    for i in runs:
        joint_centers.append((
                                 sum_all_scores[i][method, 8] /
                                 float(nb_blocks_per_runs[i])) / scaling)

        joint_centers_stdev.append(
            math.sqrt(
                sum_all_scores_squared[i][
                    method, 9] / float(
                    nb_blocks_per_runs[i]))
            / (scaling))

        # joint_centers_stdev.append( 1. *
        #     (sum_all_scores[i][method, 9] / float(
        #         nb_blocks_per_runs[i])) / scaling)

        task_space.append(
            sum_all_scores[i][method, 12] /
            float(nb_blocks_per_runs[i]))

        task_space_stdev.append(
            math.sqrt(
                sum_all_scores_squared[i][method, 13] /
                float(nb_blocks_per_runs[i])) / 1.)

        # task_space_stdev.append( 1. *
        #     (sum_all_scores[i][method, 13] /
        #      float(nb_blocks_per_runs[i])) / 1.)

    # plt.errorbar(runs, task_space, yerr=task_space_stdev, fmt='o')

    plt.plot(runs, task_space, color=color2_ts, lw=3, linestyle='dotted')

    if method == 2:
        # plt.fill_between(
        # runs,
        # np.array(task_space) - np.array(task_space_stdev),
        # np.array(task_space) + np.array(task_space_stdev),
        # color="#0F5B20")

        plt.errorbar(runs, task_space,
                     yerr=(np.array(task_space_stdev)),
                     fmt='o', color='#4AEE70')

        plt.errorbar(runs, task_space,
                     yerr=(0.5 * np.array(task_space_stdev)),
                     fmt='o', color='#C64D4D')

    combination = (np.array(task_space) + np.array(joint_centers)) / 2.

    # plt.plot(runs, combination, color=color_jc, lw=2)

    # Plot the means as a white line in between the error bars.
    # White stands out best against the dark blue.
    plt.plot(runs, joint_centers, color=color_jc, lw=3)

    if method == 2:
        # plt.fill_between(
        # runs,
        # np.array(joint_centers) - np.array(joint_centers_stdev),
        # np.array(joint_centers) + np.array(joint_centers_stdev),
        # color="#4AEE70")
        plt.errorbar(runs, joint_centers,
                     yerr=(np.array(joint_centers_stdev)),
                     fmt='o', color="#0F5B20")

        plt.errorbar(runs, joint_centers,
                     yerr=(0.5 * np.array(joint_centers_stdev)),
                     fmt='o', color="#C64D4D")

        # plt.fill_between(runs, task_space - task_space_stdev,
        # task_space + task_space_stdev, color="#3F5D7D")


def plot_joint_center_and_task_space_scores(
        nb_runs_to_consider,
        scores_joint,
        scores_task,
        color_jc,
        color2_ts,
        method,
        ax1,
        ax2):
    joint_centers = []
    joint_centers_stdev = []
    task_space = []
    task_space_stdev = []

    scaling = 1.

    runs = range(nb_runs_to_consider)

    for i in runs:
        joint_centers.append(np.mean(scores_joint[i]) / scaling)
        joint_centers_stdev.append(np.std(scores_joint[i]) / scaling)
        task_space.append(np.mean(scores_task[i]))
        task_space_stdev.append(np.std(scores_task[i]))

    # plt.errorbar(runs, task_space, yerr=task_space_stdev, fmt='o')

    ax1.set_xlim(-0.5, nb_runs_to_consider - 0.5)

    ax1.plot(runs, task_space, color=color2_ts, lw=3, linestyle='dotted')

    if method == 2:
        ax1.errorbar(runs, task_space,
                     yerr=(np.array(task_space_stdev)),
                     fmt='o', color='#4AEE70')

        # ax1.errorbar(runs, task_space,
        #              yerr=(0.5 * np.array(task_space_stdev)),
        #              fmt='o', color='#C64D4D')

    # Plot the means as a white line in between the error bars. White stands out
    # best against the dark blue.
    ax2.plot(runs, joint_centers, color=color_jc, lw=3)

    if method == 2:
        ax2.errorbar(runs, joint_centers,
                     yerr=(np.array(joint_centers_stdev)),
                     fmt='o', color="#0F5B20")

        # ax2.errorbar(runs, joint_centers,
        #              yerr=(0.5 * np.array(joint_centers_stdev)),
        #              fmt='o', color="#C64D4D")


        # # fake up some more data
        # spread = np.random.rand(50) * 100
        # center = np.ones(25) * 40
        # flier_high = np.random.rand(10) * 100 + 100
        # flier_low = np.random.rand(10) * -100
        # d2 = np.concatenate((spread, center, flier_high, flier_low), 0)
        # data.shape = (-1, 1)
        # d2.shape = (-1, 1)
        # # data = concatenate( (data, d2), 1 )
        # # Making a 2-D array only works if all the columns are the
        # # same length.  If they are not, then use a list instead.
        # # This is actually more efficient because boxplot converts
        # # a 2-D array into a list of vectors internally anyway.
        # data = [data, d2, d2[::2, 0]]
        # # multiple box plots on one figure
        # plt.figure()
        # plt.boxplot(data)


def cutoff_array(vector, cutoff):
    return vector[np.where(vector < cutoff)].copy()


def without_tail(vector, alpha):
    v = np.sort(vector)
    cutoff = v[int(v.shape[0] * alpha) - 1]
    print "cutoff :" + str(cutoff)
    return cutoff_array(v, cutoff)


class RunStatistics:
    def __init__(self):
        self.files = [
            "stat_noreplan_baseline_agressive_joint_.csv",
            "stat_noreplan_baseline_agressive_joint_in_collision.csv",
            "stat_noreplan_baseline_agressive_task_.csv",
            "stat_noreplan_baseline_agressive_task_in_collision.csv",

            "stat_noreplan_baseline_conservative_joint_.csv",
            "stat_noreplan_baseline_conservative_joint_in_collision.csv",
            "stat_noreplan_baseline_conservative_task_.csv",
            "stat_noreplan_baseline_conservative_task_in_collision.csv",

            "stat_noreplan_recovered_joint_.csv",
            "stat_noreplan_recovered_joint_in_collision.csv",
            "stat_noreplan_recovered_task_.csv",
            "stat_noreplan_recovered_task_in_collision.csv",

            "dtw_results.csv"]

        return

    def load_statistics_from_file(self, directory):
        for f in self.files:
            name, extension = os.path.splitext(f)
            path = directory + os.sep + f
            value = np.loadtxt(open(path, "rb"), delimiter=",")
            setattr(self, name, value)


class Move3DIOCHumanRobotResults:
    def __init__(self):
        self.save_dir = os.environ['HOME'] + "/move3d_tmp"
        # os.environ['MOVE3D_TMP_FILES']
        self.save_dir += '/trajectories_process'
        self.valid_runs = []
        self.valid_block_runs = []
        self.statistics = {}
        return

    def load_full_statistics(self):
        self.statistics = {}
        missing = []

        for r in self.valid_runs:

            run_dir = self.save_dir + os.sep + r + os.sep + "statistics"
            if os.path.exists(run_dir):
                run_stats = RunStatistics()
                run_stats.load_statistics_from_file(run_dir)
                self.statistics[r] = run_stats
            else:
                missing.append(r)

        print "Got {} statistics objects ".format(len(self.statistics))
        if not missing:
            print " - None are missing"
            return True
        else:
            for m in missing:
                print " - missing : {m}".format(**locals())
            return False

    def plot_mean_stddev(self):

        dtw_joint = np.array((1, 1))
        dtw_task = np.array((1, 1))

        nb_runs_to_consider = 8

        scores_run_joint_ioc = [dtw_joint] * nb_runs_to_consider
        scores_run_task_ioc = [dtw_task] * nb_runs_to_consider

        scores_run_joint_0 = [dtw_joint] * nb_runs_to_consider
        scores_run_task_0 = [dtw_task] * nb_runs_to_consider

        scores_run_joint_1 = [dtw_joint] * nb_runs_to_consider
        scores_run_task_1 = [dtw_task] * nb_runs_to_consider

        for b, runs in self.valid_block_runs:
            for i, r_id in enumerate(runs):
                if i >= nb_runs_to_consider:
                    continue
                r = b + os.sep + str(r_id[0])
                # print "compute run : " + r
                scores_run_joint_ioc[i] = np.append(
                    scores_run_joint_ioc[i],
                    self.statistics[r].stat_noreplan_recovered_joint_.flatten())
                scores_run_task_ioc[i] = np.append(
                    scores_run_task_ioc[i],
                    self.statistics[r].stat_noreplan_recovered_task_.flatten())

                scores_run_joint_0[i] = np.append(
                    scores_run_joint_0[i],
                    self.statistics[
                        r].stat_noreplan_baseline_agressive_joint_.flatten())
                scores_run_task_0[i] = np.append(
                    scores_run_task_0[i],
                    self.statistics[
                        r].stat_noreplan_baseline_agressive_task_.flatten())

                scores_run_joint_1[i] = np.append(
                    scores_run_joint_1[i],
                    self.statistics[
                        r].stat_noreplan_baseline_conservative_joint_.flatten())
                scores_run_task_1[i] = np.append(
                    scores_run_task_1[i],
                    self.statistics[
                        r].stat_noreplan_baseline_conservative_task_.flatten())

        scores_cut_off_run_joint_ioc = [dtw_joint] * nb_runs_to_consider
        scores_cut_off_run_task_ioc = [dtw_task] * nb_runs_to_consider

        nb_joint_over_cutoff = 0
        nb_task_over_cutoff = 0
        total_joint = 0
        total_task = 0

        alpha = 0.95

        for i in range(nb_runs_to_consider):
            scores_cut_off_run_joint_ioc[i] = without_tail(
                scores_run_joint_ioc[i], alpha)
            scores_cut_off_run_task_ioc[i] = without_tail(
                scores_run_task_ioc[i], alpha)

            # scores_run_joint_0[i] = without_tail(
            #     scores_run_joint_0[i], alpha)
            # scores_run_task_0[i] = without_tail(
            #     scores_run_task_0[i], alpha)
            #
            # scores_run_joint_1[i] = without_tail(
            #     scores_run_joint_1[i], alpha)
            # scores_run_task_1[i] = without_tail(
            #     scores_run_task_1[i], alpha)

            nb_joint_over_cutoff += (scores_run_joint_ioc[i].shape[0] -
                                     scores_cut_off_run_joint_ioc[i].shape[0])
            nb_task_over_cutoff += (scores_run_task_ioc[i].shape[0] -
                                    scores_cut_off_run_task_ioc[i].shape[0])

            total_joint += scores_run_joint_ioc[i].shape[0]
            total_task += scores_run_task_ioc[i].shape[0]

            print "joint standard dev (cutoff) : " + str(
                np.std(scores_cut_off_run_joint_ioc[i]))
            print "joint standard dev : " + str(
                np.std(scores_run_joint_ioc[i]))
            print ""

            print "task standard dev (cutoff) : " + str(
                np.std(scores_cut_off_run_task_ioc[i]))
            print "task standard dev : " + str(
                np.std(scores_run_task_ioc[i]))
            print ""

        print "joint over cutoff : " + str(
            float(nb_joint_over_cutoff) / float(total_joint))

        print "task over cutoff : " + str(
            float(nb_task_over_cutoff) / float(total_task))

        normal_plot = True
        if normal_plot:

            fig, ax1 = plt.subplots()
            ax2 = ax1.twinx()

            ax1.set_ylabel('DTW Task space', color='k')
            ax2.set_ylabel('DTW Joint center distancs', color='k')

            plot_joint_center_and_task_space_scores(
                nb_runs_to_consider,
                scores_run_joint_0,
                scores_run_task_0,
                "blue", "blue", method=0, ax1=ax1, ax2=ax2)

            plot_joint_center_and_task_space_scores(
                nb_runs_to_consider,
                scores_run_joint_1,
                scores_run_task_1,
                "yellow", "yellow", method=1, ax1=ax1, ax2=ax2)

            plot_joint_center_and_task_space_scores(
                nb_runs_to_consider,
                scores_cut_off_run_joint_ioc,
                scores_cut_off_run_task_ioc,
                "green", "green", method=2, ax1=ax1, ax2=ax2)
            ax1.set_xlabel('Run')
            plt.show()

        else:

            plot_joint_center_and_task_space_boxes(
                scores_run_joint_0,
                scores_run_task_0,
                nb_runs_to_consider,
                scores_run_joint_1,
                scores_run_task_1,
                scores_cut_off_run_joint_ioc,
                scores_cut_off_run_task_ioc)

    def plot_histograms(self):
        dtw_joint = np.array((1, 1))
        dtw_task = np.array((1, 1))

        for r in self.valid_runs:
            dtw_joint = np.append(
                dtw_joint,
                self.statistics[r].stat_noreplan_recovered_joint_.flatten())
            dtw_task = np.append(
                dtw_task,
                self.statistics[r].stat_noreplan_recovered_task_.flatten())

        joint_center_cutoff = 300.
        task_space_cutoff = 80.

        bins = np.linspace(0, joint_center_cutoff, num=100)
        splot = plt.subplot(2, 1, 1)
        #splot.set_title('Joint center distances')
        splot.hist(dtw_joint, bins=bins, color='#6CD85B')
        splot.set_xlabel('DTW score (joint center distance)')
        splot.set_ylabel('Frequency')

        bins = np.linspace(0, task_space_cutoff, num=100)
        splot = plt.subplot(2, 1, 2)
        #splot.set_title('Task space')
        splot.hist(dtw_task, bins=bins, color='#6CD85B')
        splot.set_xlabel('DTW score (joint task space)')
        splot.set_ylabel('Frequency')

        j_over_cutoff = cutoff_array(dtw_joint, joint_center_cutoff)
        t_over_cutoff = cutoff_array(dtw_task, task_space_cutoff)

        print str(j_over_cutoff.shape)
        print str(t_over_cutoff.shape)

        percentage_j_over_cutoff = 100. * float(j_over_cutoff.shape[0]) / float(
            dtw_joint.shape[0])
        percentage_t_over_cutoff = 100. * float(t_over_cutoff.shape[0]) / float(
            dtw_task.shape[0])

        print "joint over cutoff : " + str(percentage_j_over_cutoff)
        print "joint standard dev (cutoff) : " + str(np.std(j_over_cutoff))
        print "joint standard dev : " + str(np.std(dtw_joint))
        print ""
        print "task over cutoff : " + str(percentage_t_over_cutoff)
        print "task standard dev (cutoff) : " + str(np.std(t_over_cutoff))
        print "task standard dev : " + str(np.std(dtw_task))
        print ""

        plt.show()

    def print_run_and_append(self, b, valid_run_ids):
        # For each run
        print "{b:7} [ ".format(**locals()),
        for r in valid_run_ids:
            print "{:2}({:2}) ".format(r[0], r[1]),
            self.valid_runs.append(b + os.sep + str(r[0]))
        print("]")
        self.valid_block_runs.append([b, valid_run_ids])

    def list_all_results(self):
        self.valid_runs = []
        self.run_directories = []
        print(self.save_dir)

        nb_done = 0

        blocks = [x for x in os.listdir(self.save_dir)
                  if "block" in x and
                  not path.isfile(self.save_dir + os.sep + x)]

        for b in blocks:

            block_dir = self.save_dir + os.sep + b

            run_ids_sorted = sorted(
                map(int, [x for x in os.listdir(block_dir) if not path.isfile(
                    block_dir + os.sep + x)]))

            valid_run_ids = []

            for r in run_ids_sorted:

                id_dir = block_dir + os.sep + str(r)

                aggressive_dir = (  # Warning there is two Gs in english
                                    id_dir + os.sep +
                                    "stomp_baseline_agressive_noreplan")
                conservative_dir = (
                    id_dir + os.sep + "stomp_baseline_conservative_noreplan")

                ioc_dir = (id_dir + os.sep + "stomp_noreplan")

                if (os.path.exists(aggressive_dir) and
                        os.path.exists(conservative_dir) and
                        os.path.exists(ioc_dir)):

                    # Uncomment To test that all the trajectories
                    # have been generated

                    # aggressive_files = os.listdir(
                    # aggressive_dir + "/robot_000.t")
                    # conservative_files = os.listdir(
                    # conservative_dir + "/robot_000.t")
                    # ioc_files = os.listdir(ioc_dir + "/robot_000.t")

                    aggressive_files = os.listdir(aggressive_dir)
                    conservative_files = os.listdir(conservative_dir)
                    ioc_files = os.listdir(ioc_dir)

                    if (len(aggressive_files) > 5 and
                                len(aggressive_files) == len(
                                conservative_files) and
                                len(aggressive_files) == len(ioc_files)):
                        valid_run_ids.append([r, len(aggressive_files)])

            self.print_run_and_append(b, valid_run_ids)

        for i, r in enumerate(self.valid_runs):
            print "{i:3} : {r:10} ".format(**locals()),
            if i % 6 == 0:
                print("")
        print("")
        print("NB STOMP DONE : {}".format(len(self.run_directories)))

    # Computes the Dynamic time warping cost for each of the runs
    # by iterating through all the blocks
    #
    # 1) The mean is simply the average of the mean values
    #          \mu_i = \frac{1}{N} \Sum_{b \in B} \mu_{b_i}
    # 2) standard deviation is computed as :
    #       \sigma_i = \frac{1}{N} \sqrt{ \Sum_{b \in B} \sigma_{b_i}^2 }
    #
    def compute_dtw_results(self):
        dtw_file_name = "dtw_results.csv"
        dtw_files = []
        nb_runs_total = 0
        nb_runs_directories = 0

        for b, runs in self.valid_block_runs:
            block_dtw_files = []

            for r in runs:
                run_dir = self.save_dir + os.sep + b + os.sep + str(r[0])
                nb_runs_total += 1

                if os.path.exists(run_dir):
                    nb_runs_directories += 1
                    if dtw_file_name in os.listdir(run_dir):
                        block_dtw_files.append(run_dir + os.sep + dtw_file_name)
                    else:
                        print "missing : {b:8} {r[0]:3} ".format(**locals())
            dtw_files.append(block_dtw_files)

        print("NB DTW DONE : {} {} {}".format(
            len(dtw_files), nb_runs_total, nb_runs_directories))

        nb_runs_to_consider = 8
        sum_all_scores = []
        sum_all_scores_squared = []
        nb_blocks_per_runs = []

        for i in range(nb_runs_to_consider):

            scores_for_run = np.zeros((3, 16))
            scores_for_run_squared = np.zeros((3, 16))

            nb_blocks_per_runs.append(int(0))

            for dtw_block in dtw_files:
                # print "open : " + dtw_block[i]
                run_dtw = np.loadtxt(
                    open(dtw_block[i], "rb"), delimiter=",")

                scores_for_run += run_dtw
                scores_for_run_squared += np.square(run_dtw)
                nb_blocks_per_runs[i] += 1

            sum_all_scores.append(scores_for_run)
            sum_all_scores_squared.append(scores_for_run_squared)

        method = 2

        plot_joint_center_and_task_space(nb_runs_to_consider,
                                         nb_blocks_per_runs,
                                         sum_all_scores,
                                         sum_all_scores_squared,
                                         "green", "green", method)

        method = 0

        plot_joint_center_and_task_space(nb_runs_to_consider,
                                         nb_blocks_per_runs,
                                         sum_all_scores,
                                         sum_all_scores_squared,
                                         "blue", "blue", method)

        method = 1

        plot_joint_center_and_task_space(nb_runs_to_consider,
                                         nb_blocks_per_runs,
                                         sum_all_scores,
                                         sum_all_scores_squared,
                                         "yellow", "yellow", method)
        plt.show()

        return

    # run_id should be of the form block0/0
    # where the block is a folder that contains several runs
    # the runs are identified by number increasing with time
    def run_move3d_dtw(run_id):
        move3d_test = Move3DIOCHumanTrajectories("human_robot_experiment")
        move3d_test.human_robot_run = run_id
        move3d_test.set_phase("dtw")
        move3d_test.loo_splits = []

        move3d = Move3D()

        manager = multiprocessing.Manager()
        return_dict = manager.dict()

        jobs = [move3d_test.run_one_test(
            move3d, move3d_test.stomp_noreplan, "", return_dict)]

        for p in jobs:
            p.join()

        print "return values :"
        print return_dict.values()


# run the server
if __name__ == "__main__":

    ioc = Move3DIOCHumanRobotResults()
    ioc.list_all_results()

    for arg in sys.argv:
        if arg == "run_dtw":
            for run in ioc.valid_runs:
                run_move3d_dtw(run)
        elif arg == "run_dtw_single":
            print "run singe dtw"
            run_move3d_dtw("block0/10")
        elif arg == "show_dtw":
            ioc.compute_dtw_results()
        elif arg == "full_stats":
            if ioc.load_full_statistics():
                #ioc.plot_histograms()
                ioc.plot_mean_stddev()
