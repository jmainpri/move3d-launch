#!/usr/bin/env python

import numpy as np
from mpl_toolkits.basemap import Basemap
import matplotlib.cm as cm
import matplotlib.pyplot as plt
import tf
import math
from scipy import stats


def cart2sph(x, y, z):
    dxy = np.sqrt(x ** 2 + y ** 2)
    r = np.sqrt(dxy ** 2 + z ** 2)
    theta = np.arctan2(y, x)
    phi = np.arctan2(z, dxy)
    theta, phi = np.rad2deg([theta, phi])
    return theta, phi, r


def euler_to_xyz(roll, pitch):
    z = np.sin(roll)
    rcosphi = np.cos(roll)
    x = rcosphi * np.cos(pitch)
    y = rcosphi * np.sin(pitch)
    return x, y, z


def convert_quaternion(q):
    quaternion = (
        q[1],  # x
        q[2],  # y
        q[3],  # z
        q[0])  # w
    euler = tf.transformations.euler_from_quaternion(quaternion, 'rxyz')
    roll = euler[0]
    pitch = euler[1]
    yaw = euler[2]
    return np.array([roll, pitch, yaw])


# random data
quaternions = np.loadtxt('quaternions_2.txt')

print quaternions.shape[0]

euler_angles = np.zeros((quaternions.shape[0], 3))
spherical_coordinates = np.zeros((quaternions.shape[0], 3))
for i, q in enumerate(quaternions):
    euler_angles[i] = convert_quaternion(q)
    x, y, z = euler_to_xyz(euler_angles[i][0], euler_angles[i][1])
    theta, phi, r = cart2sph(x, y, z)
    coordinates = np.array([theta, phi, r])
    spherical_coordinates[i] = coordinates
np.savetxt('euler_angles.txt', euler_angles)

nrows, ncols = (100, 100)
x_edges = np.linspace(-180, 180, ncols)
y_edges = np.linspace(-90, 90, nrows)
lon, lat = np.meshgrid(x_edges, y_edges)
# print x_edges
# print y_edges

X = spherical_coordinates[:, 0]
Y = spherical_coordinates[:, 1]
print " extends of spherical : "
print X.min()
print X.max()
print Y.min()
print Y.max()

A = 180. * euler_angles[:, 1] / math.pi
B = 180. * euler_angles[:, 0] / math.pi
print " extends of eulers : "
print A.min()
print A.max()
print B.min()
print B.max()
X = A
Y = B

positions = np.vstack([lon.ravel(), lat.ravel()])
values = np.vstack([X, Y])
kernel = stats.gaussian_kde(values)
# kernel.set_bandwidth(bw_method='silverman')
kernel.set_bandwidth(bw_method=kernel.factor * 3.2)
H = np.reshape(kernel(positions).T, lon.shape)

# x_edges_1 = np.linspace(0, 360, ncols + 1)
# y_edges_1 = np.linspace(-90, 90, nrows + 1)
# H, xedges, yedges = np.histogram2d(X, Y, bins=(x_edges_1, y_edges_1),
#                                    normed=True)
# print H.shape
# print xedges.shape
# print yedges.shape
# print H.max()
# print H.min()
# fmax, fmin = H.max(), H.min()
# H = (H - fmin) / (fmax - fmin)
# print H

# fig = plt.figure(figsize=(7, 3))
# ax = fig.add_subplot(211)

# set up map projection
map = Basemap(projection='ortho', lat_0=50, lon_0=10)
# draw lat/lon grid lines every 30 degrees.
map.drawmeridians(np.arange(0, 360, 30))
map.drawparallels(np.arange(-90, 90, 30))

# get data points
x1, y1 = map(X, Y)

# contour data over the map.
x2, y2 = map(lon, lat)
cs = map.contourf(x2, y2, H, cmap=cm.brg, alpha=0.7)
# plt.clim([1.e-5, 1.e-3])
#

print "H EXTENTS"
print H.max()
print H.min()
# compute native map projection coordinates of lat/lon grid.
# map.scatter(x1, y1, marker="o", color='k', cmap=cm.summer, alpha=0.7)

# draw arrow
max_nb_arrows = 50
x3 = np.zeros(max_nb_arrows)
y3 = np.zeros(max_nb_arrows)
u = np.zeros(max_nb_arrows)
v = np.zeros(max_nb_arrows)
scale = 1
start_at = 200
for i, yaw in enumerate(euler_angles[:, 2]):
    j = i + start_at
    u[i] = np.cos(yaw)
    v[i] = np.sin(yaw)
    x_u, y_u = map(X[j] + scale * u[i], Y[j] + scale * v[i])
    u[i], v[i] = x_u - x1[j], y_u - y1[j]
    x3[i], y3[i] = x1[j], y1[j]
    if i == (max_nb_arrows - 1):
        break

map.quiver(x3, y3, u, v, scale_units='xy', scale=0.25)

# ax = fig.add_subplot(212)
# ax.contourf(lon, lat, H, cmap=cm.brg, alpha=0.7)
# ax.scatter(X, Y, marker="o", color='k', alpha=0.7)
# ax.set_xlim(X.min(), X.max())
# ax.set_ylim(Y.min(), Y.max())
#
# # plt.title('Goal region')
plt.show()
