move3d-launch
=============

Launch files for move3d-studio

### Install

The install-ubuntu.sh script sequences apt-get commands, git clone commands, and make commands to install the move3d suite to an arbitray folder. Before launching the install procedure, the default usage is to clone move3d-launch in a folder suited for holding the source code and 3d models of move3d. Then launch the install script and wait, the proceedure can be quite long. The install script may prompt when installing dependencies.

    ./install-ubuntu.sh
    
The script will append to ~/.bashrc, when the software is compiled, make sure the environment variables have been set:

    echo "HOME_MOVE3D= "$HOME_MOVE3D
    echo "LD_LIBRARY_PATH= " $LD_LIBRARY_PATH
    echo "PKG_CONFIG_PATH= " $PKG_CONFIG_PATH
    echo "PATH= "$PATH
    
The variables should contain the paths of the newly installed software. 
You can install the assets alongside move3d-launch.

    git clone https://github.com/jmainpri/move3d-assets.git
    
Note: the script may work on other unix distributions.

    
### Run


You should now be able to launch the examples, for instance try:

    cd launch_files
    ./launch_justin_kitchen.sh
    
The launch scripts supose that:

* PATH contains the move3d-studio executable
* HOME_MOVE3D points to move3d-launch or a floder along side it
* move3d-assets is installed along side move3d-launch
