#!/usr/bin/env bash

set -e
# sudo apt-get update
# sudo apt install gcc
# sudo apt install gfortran
# sudo apt-get install build-essential
# sudo apt install csh
# sudo apt install m4

sudo apt-get install csh

WRFDIR=$WRFLIBSDIR

function install_zlib() {
  wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.11.tar.gz
  tar -xzvf zlib-1.2.11.tar.gz
  cd zlib-1.2.11 || exit
  ./configure --prefix="$WRFDIR"/grib2
  make -j 4
  make install
  cd .. || exit
  rm -rf zlib*
}

function install_hdf5() {
  wget https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/hdf5-1.10.5.tar.bz2
  tar -xf hdf5-1.10.5.tar.bz2
  cd hdf5-1.10.5 || exit
  ./configure --prefix="$WRFDIR" --with-zlib="$WRFDIR"/grib2 --enable-fortran --enable-shared
  make -j 4
  make install
  cd .. || exit
  rm -rf hdf5*
}

function install_netcdf() {

  wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-c-4.7.2.tar.gz
  tar -xzvf netcdf-c-4.7.2.tar.gz
  cd netcdf-c-4.7.2 || exit
  ./configure --enable-shared --enable-netcdf4 --disable-filter-testing --disable-dap --prefix="$WRFDIR"/netcdf
  make -j 4
  make install
  cd ..
  rm -rf netcdf-c*
}

function install_netcdf_fortran() {

  export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz"
  wget https://github.com/Unidata/netcdf-fortran/archive/v4.5.2.tar.gz
  tar -xf v4.5.2.tar.gz
  cd netcdf-fortran-4.5.2 || exit
  ./configure --enable-shared --prefix="$WRFDIR"/netcdf
  make -j 4
  make install
  cd ..
  rm -rf netcdf-fortran* v4.5.2.tar.gz
}

function install_mpich() {

  wget https://www.mpich.org/static/downloads/4.1.2/mpich-4.1.2.tar.gz
  tar zxvf mpich-4.1.2.tar.gz
  cd mpich-4.1.2 || exit
  ./configure --prefix="$WRFDIR"/mpich
  make
  make install

}

function install_libpng() {

  wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
  tar -xzvf libpng-1.2.50.tar.gz
  cd libpng-1.2.50 || exit
  ./configure --prefix="$WRFDIR"/grib2
  make -j 4
  make install
  cd ..
  rm -rf libpng*
}

function install_jasper() {

  wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
  tar -xzvf jasper-1.900.1.tar.gz
  cd jasper-1.900.1 || exit
  ./configure --prefix="$WRFDIR"/grib2
  make -j 4
  make install
  cd ..
  rm -rf jasper*
}

function install_wrf() {
  # current is libs, need to go one up
  cd ..
  # git clone https://github.com/wrf-model/WPS
  git clone --recurse-submodules https://github.com/wrf-model/WRF

  CONFIG_VALUE=34
  cd WRF || exit
  ./configure <<EOF
$CONFIG_VALUE

EOF
  ./compile -j 4 em_real 2>&1 | tee compile_wrf.out

}

function main() {

  mkdir -p "$WRFDIR"
  cd "$WRFDIR" || exit
  install_zlib
  install_hdf5
  install_netcdf
  install_netcdf_fortran
  # install_mpich
  install_libpng
  install_jasper

  install_wrf
}

main
