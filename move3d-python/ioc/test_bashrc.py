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
# Jim Mainprice on Sunday May 17 2015

import os
from os import path
from move3d_basic import *
from ioc_leave_one_out_trajectories import *
import shlex
import time

solution_without_shell = False

print "Start process"

if solution_without_shell:

    command = shlex.split(
        "echo \"HOME: ${HOME}\"")
    p = subprocess.Popen(command, stdin=sys.stdin,
                         stdout=sys.stdout,
                         shell=False)
else:

    time.sleep(20)

    command = "echo \"MOVE3D_TEST_ENVIRONMENT: ${MOVE3D_TEST_ENVIRONMENT}\""
    p = subprocess.Popen(command, stdin=sys.stdin,
                         stdout=sys.stdout,
                         shell=True)
p.wait()

print "End process"
