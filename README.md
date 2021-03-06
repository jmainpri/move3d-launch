move3d-launch
=============

This project contains install and launch scripts for move3d-studio

### Install

The install-ubuntu.sh script sequences apt-get commands for ubuntu 14.04, git clone commands, and make commands to install the move3d suite to an arbitray folder. The default folder will be ../install. But you can set it this way:

    export MOVE3D_INSTALL_DIR=$HOME/move3d_install

Where ~/move3d_install is the destination folder. Before launching the install script, the default usage is to clone move3d-launch in a folder suited for holding the source code and 3d models of move3d (you can name it move3d). You may need to edit the maximal number of jobs to reflect what your machine is capable of (maybe -j4):

https://github.com/jmainpri/move3d-launch/blob/master/install-ubuntu.sh#L21 

Then type:

    ./install-ubuntu.sh install-https

The proceedure can be quite long. The script may prompt for sudo privileges or whether to proceed when installing system dependencies. It will append to ~/.bashrc, so when the software is compiled, make sure the environment variables have been set correctly:

    source ~/.bashrc
    echo "HOME_MOVE3D= "$HOME_MOVE3D
    echo "LD_LIBRARY_PATH= " $LD_LIBRARY_PATH
    echo "PKG_CONFIG_PATH= " $PKG_CONFIG_PATH
    echo "PATH= "$PATH
    
The variables should contain the paths to the folders, executable and libraries.


You can now clone the assets next to move3d-launch:

    git clone https://github.com/jmainpri/move3d-assets.git assets
    
Note: the script might work on other unix distributions with small or no modifications.

    
### Run


You should now be able to launch the examples, for instance try:

    cd launch_files && ./launch_justin_kitchen.sh
    
The launch files supose that:

* PATH contains the move3d-studio executable
* HOME_MOVE3D points to move3d-launch or a floder along side it
* move3d-assets is installed next to move3d-launch
