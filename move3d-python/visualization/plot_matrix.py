#!/usr/bin/python

from numpy.linalg import inv
import numpy as np
import matplotlib.pyplot as plt

# load matrix from file
#x = np.loadtxt('../../launch_files/control_matrices/inv_control_costs_0.txt', delimiter=',')

# x = np.loadtxt('../../launch_files/control_matrices/inv_control_costs_goalset_0.txt', delimiter=',')
#x = np.loadtxt('../../control_matrices/launch_files/covariance_goalset_0.txt', delimiter=',')

# x = np.loadtxt('../../control_matrices/launch_files/ioc_control_cost.txt', delimiter=',')
# x = np.loadtxt('../../control_matrices/launch_files/ioc_covariance.txt', delimiter=',')
#print x
#
#x = np.transpose(x)


#x = np.loadtxt('../../launch_files/control_matrices/dtw_control_costs_000.csv', delimiter=',')
x = np.loadtxt('../../launch_files/control_matrices/cost_computation_control_inverse_0.csv', delimiter=',')

print x
print x.shape

# square = 10
# print x[0:square, 0:square]

T = range(x.shape[0])
for i in range(x.shape[1]):
    plt.plot(T, x[:, i])

plt.show()
