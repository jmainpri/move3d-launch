move3d-launch
=============

Launch files for move3d-studio

### Install

The install-ubuntu.sh script sequences apt-get commands, git clone commands, and make commands to install the move3d suite to an arbitray folder. Before launching the install procedure, the default usage is to clone move3d-launch in a folder suited for holding the source code and 3d models of move3d. Then launch the install script and wait, the proceedure can be quite long. The install script may prompt when installing dependencies.

    ./install-ubuntu.sh
    
The script writes to the ~/.bashrc file, make sure the environment variables have been set:

    echo "HOME_MOVE3D= "$HOME_MOVE3D
    echo "LD_LIBRARY_PATH= " $LD_LIBRARY_PATH
    echo "PKG_CONFIG_PATH= " $PKG_CONFIG_PATH
    echo "PATH= "$PATH
    
The variable should containts the paths of the newly installed software.
Note: the script may work on other unix distributions.

### Run

Once the software is compiled, you can download the assets

    git clone https://github.com/jmainpri/move3d-assets.git
    
You should now be able to launch the examples, for instance try:

    cd launch_files
    ./launch_trrt_costmap.sh
