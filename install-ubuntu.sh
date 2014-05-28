#!/bin/bash
# Jim Mainprice ( mainprice@gmail.com ) 

# Set if you want to download as ssh or http
USE_SSH=false

# Use tar
USE_TARBALLS=false

# Move3D install folder
MOVE3D_INSTALL_FOLDER=$('pwd')/../install
MOVE3D_DOWNLOAD_FOLDER=$('pwd')/..

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
	make install
	cd ../..
    done
}

MakeAndInstallRepos()
{
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${autotouls_repo_names[@]}"
    do :
	cd $r
	mkdir build
	cd build
	autoreconf -i ..
	../configure
	if [ $r != gbM ]
	then
	    ../configure --prefix=$MOVE3D_DOWNLOAD_FOLDER
	else
	    ../configure --prefix=$MOVE3D_DOWNLOAD_FOLDER --disable-gbtcl
	fi
	make install
	cd ../..
    done

    for r in "${cmake_repo_names[@]}"
    do :
	cd $r
	mkdir build
	cd build
	if [ $r != move3d-studio ]
	then
	    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=$MOVE3D_DOWNLOAD_FOLDER
	else
	    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=$MOVE3D_DOWNLOAD_FOLDER -DMOVE3D_QT=ON -DUSE_QWT=OFF
	fi
	make install
	cd ../..
    done
}

InstallSysDep()
{
    # Install system dependencies
    sudo apt-get update
    sudo apt-get install cmake cmake-curses-gui
    sudo apt-get install autoconf libtool
    sudo apt-get install build-essential
    sudo apt-get install libxml2-dev
    sudo apt-get install doxygen
    sudo apt-get install qt4-dev-tools
    sudo apt-get install libxmp-dev
    sudo apt-get install libgbm1 libgbm-dev libgsl0-dev glpk
    sudo apt-get install libboost-dev
    sudo apt-get install libgts-dev
    sudo apt-get install freeglut3 freeglut-dev
    sudo apt-get install libeigen3-dev
    sudo apt-get install libboost-thread-dev
}

Install()
{
    echo '' >> ~/.bashrc

    # Check for environment settings
    if [ -z "$MOVE3D_INSTALL_DIR" ];
    then
        echo 'export MOVE3D_INSTALL_DIR='$MOVE3D_DOWNLOAD_FOLDER/install >> ~/.bashrc
        # . ~/.bashrc
    elif
	MOVE3D_INSTALL_FOLDER=$MOVE3D_INSTALL_DIR
    fi    

    # Set environment
    echo 'export HOME_MOVE3D='$MOVE3D_DOWNLOAD_FOLDER/libmove3d >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH='$MOVE3D_INSTALL_FOLDER/lib:'$LD_LIBRARY_PATH' >> ~/.bashrc
    echo 'export PKG_CONFIG_PATH='${MOVE3D_INSTALL_FOLDER}/lib/pkgconfig:'$PKG_CONFIG_PATH' >> ~/.bashrc
    echo 'export PATH='${MOVE3D_INSTALL_FOLDER}/bin:'$PATH' >> ~/.bashrc

    source ~/.bashrc

    # Remove all installed software
    RemoveAllRepos

    # Install all system dependencies
    InstallSysDep

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
}

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

