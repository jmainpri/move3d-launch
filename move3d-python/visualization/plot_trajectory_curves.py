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

import numpy as np
import matplotlib.pyplot as plt


# plots a page with each dof in the dofs variable
def plot_page(t, dofs, curves):
    for i in range(len(dofs)):
        splot = plt.subplot(len(dofs), 1, 1 + i)
        splot.plot(t, curves[dofs[i], 1:])
    plt.show

if __name__ == "__main__":

    # Loads the matix from file
    curves = np.loadtxt('../../launch_files/stomp_best_traj.txt', delimiter=',')
    print curves.shape
    print curves

    # Discard the first collumn which corresponds
    # to the time index
    t = range(curves.shape[1]-1)

    # The number of rows are the number of dofs
    # of the trajectory
    dofs = range(curves.shape[0])

    # Display by pages of 10 Dofs at a time
    group_size = 10

    # Plot each page, close the window to see the next one
    for dof_group in [dofs[i:i+group_size]
                      for i in xrange(0, len(dofs), group_size)]:
        print dof_group
        plot_page(t, dof_group, curves)
