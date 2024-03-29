#!/bin/bash

GMX_VERSION=2024.1
INSTALL_DIR=/apps/gromacs-${GMX_VERSION}

module load mpi/openmpi
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
sudo apt-get -y install g++
sudo apt-get -y install build-essential
wget https://ftp.gromacs.org/gromacs/gromacs-${GMX_VERSION}.tar.gz
tar xvf gromacs-${GMX_VERSION}.tar.gz
cd gromacs-${GMX_VERSION} || exit
mkdir build
cd build || exit
cmake .. \
  -DBUILD_SHARED_LIBS=off \
  -DBUILD_TESTING=off \
  -DREGRESSIONTEST_DOWNLOAD=OFF \
  -DCMAKE_C_COMPILER="$(which mpicc)" \
  -DCMAKE_CXX_COMPILER="$(which mpicxx)" \
  -DGMX_BUILD_OWN_FFTW=on \
  -DGMX_DOUBLE=off \
  -DGMX_EXTERNAL_BLAS=off \
  -DGMX_EXTERNAL_LAPACK=off \
  -DGMX_FFT_LIBRARY=fftw3 \
  -DGMX_GPU=off \
  -DGMX_MPI=on \
  -DGMX_OPENMP=on \
  -DGMX_X11=off \
  -DCMAKE_EXE_LINKER_FLAGS="-zmuldefs " \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"

make -j 16
sudo make install
command="source ${INSTALL_DIR}/bin/GMXRC"
echo "$command"
eval "$command"
which gmx_mpi
