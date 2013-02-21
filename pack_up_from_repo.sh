#!/bin/bash
#
# pack_up_from_repo - don't bother. Outdated. (tc_pkg-deb)
#

# Minimum # of parameters
ARGS=2

# Error codes
E_BADARGS=65
E_NOFILE=66
E_WRONG_DIRECTORY=83

# Packaging Home (no trailing '/')
PKGN_HOME="$HOME/packages"

# Locating Packaging Directory
if [ -d $PKGN_HOME ] ; then
    echo "Using packacing location: $PKGN_HOME"
else
    echo "Attempting to create directory: $PKGN_HOME"
    mkdir -p $PKGN_HOME && echo "Using packaging base location: $PKGN_HOME"
fi

# Locating Source Directory
if [ $# -lt $ARGS ] ; then
    echo "Usage: `basename $0`  directory  ext1  ..extN"
    echo ""
    echo "Eg: `basename $0` ~/mypackage docs dev-0.1"
    echo "    => mypackage-docs mypackage-dev-0.1"
    exit $E_BADARGS
fi

if [ -d $1 ] ; then
    SRC_DIR=$1
else
    echo "$1 is not a directory"
    exit $E_WRONG_DIRECTORY
fi

cd $SRC_DIR
echo "Changed into: $PWD"
B_NAME="`basename ${PWD}`"
echo "Using basename: $B_NAME"
cd $PWD/..

shift

# Packing
for i in $*
do
    PACK_NAME="$B_NAME-$i"
    PKGN_DIR="$PKGN_HOME/$B_NAME/$PACK_NAME"

    if [ -d $PKGN_DIR ] ; then
        echo "Using packaging directory: $PKGN_DIR" 
        cd $PKGN_DIR

        if [ -d ./$PACK_NAME/debian ] ; then
            echo "Backing up debian directory"
            mv ./$PACK_NAME/debian ../debian.$i
        else
            echo "No debian directory found"
        fi

        rm -rf ./*
        cd -
    else
        echo "Attempting to create directory: $PKGN_DIR"
        mkdir -p $PKGN_DIR && echo "Using packaging directory: $PKGN_DIR"
    fi

    ln -s ./$B_NAME ./$PACK_NAME

    tar czvhlf $PACK_NAME.tar.gz --exclude-vcs ./$PACK_NAME >> /dev/null && echo "Creating $PACK_NAME.tar.gz successful"

    mv -f $PACK_NAME.tar.gz $PKGN_DIR/ && echo "Packing $PACK_NAME successful"

    rm ./$PACK_NAME
done
