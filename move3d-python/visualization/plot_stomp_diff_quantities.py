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


if __name__ == "__main__":

    # type of plot (vel, acc, jerk)
    diff_quantity = 'acc'

    # Display by pages of 10 Dofs at a time
    group_size = 10

    # Plot each page, close the window to see the next one
    for i in range(group_size):

        # Set the number with 3 zeros formating
        number = '%03.0f' % (i)
        filename = 'stomp_' + diff_quantity + '_' + number + '.csv'

        # Loads the matrix from file
        x = np.loadtxt('../../launch_files/control_cost_profiles/' + filename, delimiter=',')
        #print x.shape
        #print x

        # Discard the first column which corresponds to the time index
        t = range(x.shape[0])

        splot = plt.subplot(group_size, 1, 1 + i)
        splot.plot(t, x)

plt.show()