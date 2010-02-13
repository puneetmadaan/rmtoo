#!/bin/bash

set -e

# The first and one and only argument must be the version number. 
if test $# -ne 1;
then
    echo "+++ Usage: build_tar.sh <version>"
    exit 1
fi

PACKAGE_NAME=rmtoo-$1

# Create requirments dependency graph and PDF.
make clean
make all
make latex

# Temporary store documents in an own directory: a make clean will
# remove them - but we need it.
rm -fr ttt
mkdir ttt
mv doc/latex/requirements.pdf ttt
mv reqtree.png ttt

# Clean up everything before copying into the tar ball directory.
make clean

mkdir -p package/${PACKAGE_NAME}
for d in bin COPYING doc gpl-3.0.txt rmtoo setenv.sh Readme.txt Makefile
do
    cp -r $d package/${PACKAGE_NAME}
done

mv ttt/* package/${PACKAGE_NAME}/doc

# Do not deliver emacs backup files
find package/${PACKAGE_NAME} -name "*~" | xargs rm
# Do not deliver compiled python files
find package/${PACKAGE_NAME} -name "*.pyc" | xargs rm

# Create tag ball
(cd package
tar -cf ${PACKAGE_NAME}.tar ${PACKAGE_NAME}
gzip -9 ${PACKAGE_NAME}.tar
)
mv package/${PACKAGE_NAME}.tar.gz .

# Clean up
rm -fr package ttt
