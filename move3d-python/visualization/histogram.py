#!/usr/bin/env python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np, quaternion
import tf
import math
from scipy import stats


def convert_quaternion(q):
    euler = tf.transformations.euler_from_quaternion((
        q[1],  # x
        q[2],  # y
        q[3],  # z
        q[0]), 'rxyz')  # w)
    x = euler[0]
    y = euler[1]
    z = euler[2]
    return np.array([x, y, z])


def convert_quaternion_numpy(q):
    euler = tf.transformations.euler_from_quaternion((
        q[1],  # x
        q[2],  # y
        q[3],  # z
        q[0]), 'szyx')  # w)
    z = euler[0]
    y = euler[1]
    x = euler[2]
    return np.array([x, y, z])


# 2.71145 0.312039  2.81317
q = np.array([0.115301, -0.190482, 0.946691, -0.232805])
print convert_quaternion(q)
print convert_quaternion_numpy(q)

# random data
quaternions = np.loadtxt('quaternions_1.txt')

print quaternions.shape[0]

euler_angles_np = np.zeros((quaternions.shape[0], 3))
euler_angles = np.zeros((quaternions.shape[0], 3))
for i, q in enumerate(quaternions):
    euler_angles[i] = convert_quaternion(q)
    euler_angles_np[i] = convert_quaternion_numpy(q)
np.savetxt('euler_angles.txt', euler_angles)

x = euler_angles[:, 0]
y = euler_angles[:, 1]
z = euler_angles[:, 2]

print " extends of eulers : "
A = euler_angles[:, 0]
B = euler_angles[:, 1]
print (180. * A.min() / math.pi)
print (180. * A.max() / math.pi)
print (180. * B.min() / math.pi)
print (180. * B.max() / math.pi)

x_np = euler_angles_np[:, 0]
y_np = euler_angles_np[:, 1]
z_np = euler_angles_np[:, 2]

ncols = 100
nrows = 100

x_edges = np.linspace(0, 2 * np.pi, ncols + 1)
y_edges = np.linspace(0, 2 * np.pi, nrows + 1)

H, xedges, yedges = np.histogram2d(y, x, bins=(x_edges, y_edges))
print H.shape

fig = plt.figure(figsize=(7, 3))

ax = fig.add_subplot(241)
ax.set_title('imshow: equidistant')
im = plt.imshow(H, interpolation='nearest', origin='low',
                extent=[xedges[0], xedges[-1], yedges[0], yedges[-1]])

ax = fig.add_subplot(242)
ax.set_title('pcolormesh: exact bin edges')
X, Y = np.meshgrid(xedges, yedges)
ax.pcolormesh(X, Y, H)
ax.set_aspect('equal')

# NonUniformImage displays exact bin edges with interpolation:
ax = fig.add_subplot(243)
ax.set_title('NonUniformImage: interpolated')
im = mpl.image.NonUniformImage(ax, interpolation='bilinear')
xcenters = xedges[:-1] + 0.5 * (xedges[1:] - xedges[:-1])
ycenters = yedges[:-1] + 0.5 * (yedges[1:] - yedges[:-1])
im.set_data(xcenters, ycenters, H)
ax.images.append(im)
ax.set_xlim(xedges[0], xedges[-1])
ax.set_ylim(yedges[0], yedges[-1])
ax.set_aspect('equal')

ax = fig.add_subplot(244)
positions = np.vstack([X.ravel(), Y.ravel()])
values = np.vstack([x, y])
kernel = stats.gaussian_kde(values)
H = np.reshape(kernel(positions).T, X.shape)
ax.pcolormesh(X, Y, H)
ax.set_aspect('equal')

ax = fig.add_subplot(245)
ax.scatter(x, y, marker="o", color='k', alpha=0.7)
ax.set_xlim(x.min(), x.max())
ax.set_ylim(y.min(), y.max())

ax = fig.add_subplot(246)
ax.scatter(x, z, marker="o", color='k', alpha=0.7)
ax.set_xlim(x.min(), x.max())
ax.set_ylim(z.min(), z.max())

# ax = fig.add_subplot(247)
# ax.scatter(x_np, y_np, marker="o", color='k', alpha=0.7)
# ax.set_xlim(x_np.min(), x_np.max())
# ax.set_ylim(y_np.min(), y_np.max())
#
# ax = fig.add_subplot(248)
# ax.scatter(x_np, z_np, marker="o", color='k', alpha=0.7)
# ax.set_xlim(x_np.min(), x_np.max())
# ax.set_ylim(z_np.min(), z_np.max())


ax = fig.add_subplot(247)
ax.pcolormesh(X, Y, H)
ax.scatter(x, y, marker="o", color='k', alpha=0.7)
ax.set_xlim(x.min(), x.max())
ax.set_ylim(y.min(), y.max())

ax = fig.add_subplot(248)
ax.scatter(x_np, z_np, marker="o", color='k', alpha=0.7)
ax.set_xlim(x_np.min(), x_np.max())
ax.set_ylim(z_np.min(), z_np.max())

plt.show()
