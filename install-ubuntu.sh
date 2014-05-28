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

RemoveRepos()
{  
    cd $MOVE3D_DOWNLOAD_FOLDER/src

    for r in "${repo_names[@]}"
    do :
        rm -rf $r
    done
}

MakeAndInstallRepos()
{
    cd $MOVE3D_DOWNLOAD_FOLDER

    for r in "${autotouls_repo_names[@]}"
    do :
	cd $r
	mkdir build
	autoreconf -i
	../configure
	make install
    done

    for r in "${cmake_repo_names[@]}"
    do :
	cd $r
	mkdir build
	cd build
	cmake ..
	make install
    done
}

InstallSysDep()
{
    # Install system dependencies
    sudo apt-get update
}

Install()
{
    # Check for environment settings
    if [ -z "$MOVE3D_INSTALL_DIR" ];
    then
        echo 'export MOVE3D_INSTALL_DIR='$MOVE3D_DOWNLOAD_FOLDER/install >> ~/.bashrc
        . ~/.bashrc
    elif
	MOVE3D_INSTALL_FOLDER=$MOVE3D_INSTALL_DIR
    fi    

    # Set environment
    echo 'export HOME_MOVE3D='$MOVE3D_DOWNLOAD_FOLDER/libmove3d >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH='$MOVE3D_INSTALL_FOLDER/lib:'$LD_LIBRARY_PATH' >> ~/.bashrc
    echo 'export PKG_CONFIG_PATH='${MOVE3D_INSTALL_FOLDER}/lib/pkgconfig:'$PKG_CONFIG_PATH' >> ~/.bashrc
    echo 'export PATH='${MOVE3D_INSTALL_FOLDER}/bin:'$PATH' >> ~/.bashrc

    # Remove all installed software
    RemoveAll

    # Install all system dependencies
    InstallSysDep

    # Pull repositories from github
    GetAchReposFromGithub

    # Make and install repositories
    MakeAndInstallRepos
}

ShowUsage()
{
    echo 'install-https : Removes all software, downloads the stable versions via HTTPS and compile'
    echo 'install-ssh   : Removes all software, downloads the stable versions via SSH and compile'
    echo 'pull-recompile: Pulls and recompiles current software stack'
    echo 'recompile     : Recompiles current software stack'
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

