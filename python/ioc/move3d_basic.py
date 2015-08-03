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

import subprocess
import os
import sys
import re
import shutil
import time
import multiprocessing

def move3d_set_variable(filename, variable, new_value):

    str1 = variable + "=.*"
    str2 = variable + "=" + new_value

    new_params = []
    f = open(filename)
    for line in f:
        new_line = re.sub( str1.encode('string-escape'), str2.encode('string-escape'), line)
        new_params.append(new_line)

    f = open(filename, 'w')
    for line in new_params:
        f.write(line)
    f.close()

class Move3D:

    def __init__(self):

        self.id = 0
        self.folder_param_files = os.environ['MOVE3D_PARAM_FILES']
        # self.folder_tmp_param_files = os.path.dirname(os.path.realpath(__file__)) + "/tmp_params_files"
        self.folder_tmp_files = os.environ['MOVE3D_TMP_FILES']
        self.folder_tmp_param_files = self.folder_tmp_files + "/params_files"

    def launch(self, filename, program, args, return_dict):

        self.id += 1

        # Get fullpath of the parameter file
        param_filename = self.folder_param_files + "/" + filename

        # Copy the file to a temporary directory
        # to allow changes
        tmp_param_file  = self.folder_tmp_param_files + "/" + filename
        tmp_param_file += "%06d" % self.id

        print "copy " + param_filename + " to " + tmp_param_file
        shutil.copy2(param_filename, tmp_param_file)

        # Launch the program in a new process
        # with the copied parameter file as argument
        p = multiprocessing.Process(target=program, args=('move3d_process', tmp_param_file, args))
        p.start()
        return p

# run the server
if __name__ == "__main__":

    filename = 'params_spheres_ioc_compare'
    variable = 'boolParameter\ioc_draw_samples'
    new_value = 'false'

    folder = '/jim_local/Dropbox/move3d/move3d-launch/parameters/'

    t = time.time()
    move3d_set_variable(folder + filename, variable, new_value)
    print "time : " + str(time.time() - t)