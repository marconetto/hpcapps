export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install g++
sudo apt-get -y install build-essential
wget https://ftp.gromacs.org/gromacs/gromacs-2024.1.tar.gz
tar xvf gromacs-2024.1.tar.gz
cd gromacs-2024.1 || exit
mkdir build
cd build || exit
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON
make -j 8
sudo make install
source /usr/local/gromacs/bin/GMXRC
#make -j 8 check
