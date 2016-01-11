#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt


# plots a page with each dof in the dofs variable
def plot_page(t, dofs):
    for i in range(len(dofs)):
        splot = plt.subplot(len(dofs), 1, 1 + i)
        splot.plot(t, x[dofs[i], 1:])
    plt.show()

if __name__ == "__main__":

    # Loads the matix from file
    x = np.loadtxt('../../launch_files/stomp_best_traj.txt', delimiter=',')
    print x.shape
    print x

    # Discard the first collumn which corresponds
    # to the time index
    t = range(x.shape[1]-1)

    # The number of rows are the number of dofs
    # of the trajectory
    dofs = range(x.shape[0])

    # Display by pages of 10 Dofs at a time
    group_size = 10

    # Plot each page, close the window to see the next one
    for dof_group in [dofs[i:i+group_size]
                      for i in xrange(0, len(dofs), group_size)]:
        print dof_group
        plot_page(t, dof_group)
