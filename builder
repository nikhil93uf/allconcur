#!/bin/bash

echo "# Installing MPI compiler"
sudo apt install -y libmpich-dev build-essential m4 wget libgmp-dev
BUILD_DIR=`pwd`

echo "# Cleaning up dependencies"
rm -rf $HOME/libev $HOME/mpfr $HOME/gmp

echo "# Building libev"
git clone https://github.com/enki/libev $HOME/libev
cd $HOME/libev
./configure LDFLAGS="-static"
make -j`nproc`
sudo make install

echo "# Building MPFR"
mkdir $HOME/mpfr
wget https://www.mpfr.org/mpfr-current/mpfr-4.0.2.tar.xz -P $HOME/mpfr
tar -xvf $HOME/mpfr/mpfr-4.0.2.tar.xz -C $HOME/mpfr/
cd $HOME/mpfr/mpfr-4.0.2
./configure LDFLAGS="-static"
make -j`nproc`
sudo make install

echo "# Building GMP"
mkdir $HOME/gmp
wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz -P $HOME/gmp
tar -xvf $HOME/gmp/gmp-6.1.2.tar.xz -C $HOME/gmp/
cd $HOME/gmp/gmp-6.1.2
./configure LDFLAGS="-static"
make -j`nproc`
sudo make install

echo "# Building AllConcur"
cd $BUILD_DIR
./configure --with-ev=$HOME/libev/.libs --with-mpfr=$HOME/mpfr/mpfr-4.0.2/src/.libs --with-gmp=$HOME/gmp/gmp-6.1.2/.libs
make benchmark -j`nproc`
