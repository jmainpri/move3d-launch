#!/usr/bin/env python

import matplotlib.pyplot as plt
from matplotlib import cm, colors
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from scipy.special import sph_harm
import tf
import math


def convert_quaternion(q):
    euler = tf.transformations.euler_from_quaternion((
        q[1],  # x
        q[2],  # y
        q[3],  # z
        q[0]), 'rzyx')  # w)
    yaw = euler[0]
    pitch = euler[1]
    roll = euler[2]
    return np.array([yaw, pitch, roll])


# random data
quaternions = np.loadtxt('quaternions_1.txt')

print quaternions.shape[0]

euler_angles = np.zeros((quaternions.shape[0], 3))
for i, q in enumerate(quaternions):
    euler_angles[i] = convert_quaternion(q)
np.savetxt('euler_angles.txt', euler_angles)

X = euler_angles[:, 2]
Y = euler_angles[:, 1]

ncols = 100
nrows = 100

x_edges_1 = np.linspace(0, np.pi, ncols + 1)
y_edges_1 = np.linspace(0, 2 * np.pi, nrows + 1)
H, xedges, yedges = np.histogram2d(X, Y, bins=(x_edges_1, y_edges_1),
                                   normed=True)
print H.shape
print xedges.shape
print yedges.shape

phi = np.linspace(0, np.pi, ncols)
theta = np.linspace(0, 2 * np.pi, nrows)
phi, theta = np.meshgrid(phi, theta)

# The Cartesian coordinates of the unit sphere
x = np.sin(phi) * np.cos(theta)
y = np.sin(phi) * np.sin(theta)
z = np.cos(phi)

m, l = 2, 3

# Calculate the spherical harmonic Y(l,m) and normalize to [0,1]
# fcolors = sph_harm(m, l, theta, phi).real
fcolors = H
fmax, fmin = fcolors.max(), fcolors.min()
print fcolors.max()
print fcolors.min()
fcolors = (fcolors - fmin) / (fmax - fmin)

# Set the aspect ratio to 1 so our sphere looks spherical
fig = plt.figure(figsize=plt.figaspect(1.))
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(x, y, z, rstride=1, cstride=1, facecolors=cm.jet(fcolors))
# Turn off the axis planes
ax.set_axis_off()
plt.show()
