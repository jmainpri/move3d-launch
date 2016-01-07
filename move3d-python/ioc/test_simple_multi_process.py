#!/usr/bin/env python

from multiprocessing import Process
import os

def info(title):
    print(title)
    print('module name:', __name__)
    if hasattr(os, 'getppid'):  # only available on Unix
        print('parent process:', os.getppid())
    print('process id:', os.getpid())

def f(name):
    info('function f')
    print('hello', name)

if __name__ == '__main__':
    info('main line')
    p = Process(target=f, args=('bob',))
    p.start()
    p.join()

# from multiprocessing import Pool
# from time import sleep
#
# def f(x):
#     return x*x
#
# if __name__ == '__main__':
#
#     # start 4 worker processes
#     with Pool(processes=4) as pool:
#
#         # print "[0, 1, 4,..., 81]"
#         print(pool.map(f, range(10)))
#
#         # print same numbers in arbitrary order
#         for i in pool.imap_unordered(f, range(10)):
#             print(i)
#
#         # evaluate "f(10)" asynchronously
#         res = pool.apply_async(f, [10])
#         print(res.get(timeout=1))             # prints "100"
#
#         # make worker sleep for 10 secs
#         res = pool.apply_async(sleep, [10])
#         print(res.get(timeout=1))             # raises multiprocessing.TimeoutError
#
#     # exiting the 'with'-block has stopped the pool