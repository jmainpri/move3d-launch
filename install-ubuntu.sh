
#!/bin/bash
# Jim Mainprice ( mainprice@gmail.com ) 

#------------------------------------

# Set if you want to download as ssh or http
USE_SSH=false

# Move3D install folder
MOVE3D_DOWNLOAD_FOLDER=$('pwd')/..
MOVE3D_INSTALL_FOLDER=${MOVE3D_DOWNLOAD_FOLDER}/install

# Machine type
OS="linux"

# install sysdep
SYS_DEP=true

# Set nb of jobs
JOBS="-j15"


#------------------------------------

SetReposNames()
{
    autotools_repo_names=(
    mkdep
    gbM
    )

    cmake_repo_names=( 
    softMotion-libs
    libmove3d
    libmove3d-hri
    libmove3d-planners
    move3d-studio
    )

    repo_names=( ${autotools_repo_names[@]} ${cmake_repo_names[@]} )
}

GetReposFromGithub()
{
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${repo_names[@]}"
    do :
        if $USE_SSH ; then
            git clone git@github.com:jmainpri/$r.git
        else
            git clone https://github.com/jmainpri/$r.git
        fi
    done
}

PullRepos()
{
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${repo_names[@]}"
    do :
        cd $r
        git pull
        cd ..
    done
}

RemoveAllRepos()
{  
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${repo_names[@]}"
    do :
        rm -rf $r
    done
}

CompileRepos()
{  
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${repo_names[@]}"
    do :
        cd $r/build
	make install $JOBS
	cd ../..
    done
}

MakeAndInstallRepos()
{
    cd $MOVE3D_DOWNLOAD_FOLDER

    echo "2"
    echo MOVE3D_INSTALL_DIR=$MOVE3D_INSTALL_DIR
    echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH

    for r in "${autotools_repo_names[@]}"
    do :
	cd $r
	mkdir build
	cd build
	autoreconf -i ..
	../configure
	if [ $r != gbM ]
	then
	    ../configure --prefix=$MOVE3D_INSTALL_FOLDER
	else
	    ../configure --prefix=$MOVE3D_INSTALL_FOLDER --disable-gbtcl
	fi
	make install $JOBS
	cd ../..
    done

    for r in "${cmake_repo_names[@]}"
    do :
	cd $r
	mkdir build
	cd build
	if [ $r != move3d-studio ]
	then
	    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=$MOVE3D_INSTALL_FOLDER -DCMAKE_BUILD_TYPE=Release
	else
	    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=$MOVE3D_INSTALL_FOLDER -DCMAKE_BUILD_TYPE=Release -DMOVE3D_QT=ON -DUSE_QWT=OFF 
            # Todo don't know why line is necessary
	    cmake ..
	fi
	make install $JOBS
	cd ../..
    done
}

InstallSysDep()
{

if [ "$OS" == "linux" ]; then
    # Install system dependencies

    sudo apt-get update
    # sudo apt-get install cmake cmake-curses-gui
    # sudo apt-get install autoconf libtool
    # sudo apt-get install build-essential
    # sudo apt-get install libxml2-dev
    # sudo apt-get install doxygen
    # sudo apt-get install qt4-dev-tools
    # sudo apt-get install libxpm-dev
    # sudo apt-get install libgbm1 libgbm-dev libgsl0-dev glpk
    # sudo apt-get install libboost-dev
    # sudo apt-get install libgts-dev
    # sudo apt-get install freeglut3 freeglut3-dev
    # sudo apt-get install libeigen3-dev
    # sudo apt-get install libboost-thread-dev

    echo "-----------------------------------------"
    echo " INSTALL DEPENDENCIES"
    echo "-----------------------------------------"

    sudo apt-get install cmake cmake-curses-gui autoconf libtool build-essential libxml2-dev doxygen qt4-dev-tools libxpm-dev libgbm1 libgbm-dev libgsl0-dev libglpk-dev libboost-dev libgts-dev freeglut3 freeglut3-dev libeigen3-dev libboost-thread-dev
fi

}

Install()
{
    # Check for environment settings
    if [ -z "$MOVE3D_INSTALL_DIR" ];
    then
	MOVE3D_INSTALL_DIR=$MOVE3D_DOWNLOAD_FOLDER/install
        # . ~/.bashrc
    else
	MOVE3D_INSTALL_FOLDER=$MOVE3D_INSTALL_DIR
    fi

    # For install set pkgconfig dir
    export PKG_CONFIG_PATH=${MOVE3D_INSTALL_FOLDER}/lib/pkgconfig:$PKG_CONFIG_PATH

    # Set environment
    echo '' >> ~/.bashrc
    echo '#------------- Move3D --------------' >> ~/.bashrc
    echo 'export MOVE3D_INSTALL_DIR='$MOVE3D_INSTALL_DIR >> ~/.bashrc
    echo 'export HOME_MOVE3D='$MOVE3D_DOWNLOAD_FOLDER/libmove3d >> ~/.bashrc
    echo 'export PKG_CONFIG_PATH='${MOVE3D_INSTALL_FOLDER}/lib/pkgconfig:'$PKG_CONFIG_PATH' >> ~/.bashrc
    echo 'export PATH='${MOVE3D_INSTALL_FOLDER}/bin:'$PATH' >> ~/.bashrc


    # Special case of DYLIB in MACOS
    if [ "$OS" == "Darwin" ]; then
        echo 'export DYLD_LIBRARY_PATH='$MOVE3D_INSTALL_FOLDER/lib:'$DYLD_LIBRARY_PATH' >> ~/.bashrc
    else
        echo 'export LD_LIBRARY_PATH='$MOVE3D_INSTALL_FOLDER/lib:'$LD_LIBRARY_PATH' >> ~/.bashrc
    fi

    # Remove all installed software
    RemoveAllRepos

    # Install all system dependencies
    if [ $SYS_DEP = true ]; then  
        InstallSysDep
    fi

    # Pull repositories from github
    GetReposFromGithub

    # Make and install repositories
    MakeAndInstallRepos
}

ShowUsage()
{
    echo '* 1st argument'
    echo '    install-https : Removes all software, downloads the stable versions via HTTPS and compile'
    echo '    install-ssh   : Removes all software, downloads the stable versions via SSH and compile'
    echo '    pull-recompile: Pulls and recompiles current software stack'
    echo '    recompile     : Recompiles current software stack'
    echo '* 2st argument'
    echo '    no_sysdep     : Will not download system dependencies'
}



# Set OS (i.e., operating system)
if [[ "$(uname)" == "Darwin" ]] ; then
    OS=Darwin
    echo "set OS to Darwin"
fi

echo "-----------------------------------------"
echo OS is set to $OS
echo "-----------------------------------------"


case "$2" in

# no sysdep
    'no_sysdep' )
        SYS_DEP=false
        echo "set no sysdep"
    ;;
esac



case "$1" in


# Removes everything and install
    'install-https' )
        USE_SSH=false
        SetReposNames
        Install
    ;;

# Removes everything and install
    'install-ssh' )
        USE_SSH=true
        SetReposNames
        Install
    ;;

# Pulls and recompiles
    'pull-recompile' )
        SetReposNames
        PullRepos
        MakeRepos
    ;;

# Recompiles
    'recompile' )
        SetReposNames
        MakeAndInstallRepos
        Makeepos
    ;;

    *)
        ShowUsage
        exit 1
    ;;
esac

exit 0

