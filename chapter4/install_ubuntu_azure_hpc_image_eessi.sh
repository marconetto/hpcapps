#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
#module load mpi/openmpi-4.1.5

# instructions from: https://www.eessi.io/docs/getting_access/native_installation
sudo apt-get install lsb-release
wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
rm -f cvmfs-release-latest_all.deb
sudo apt-get update
sudo apt-get install -y cvmfs

wget https://github.com/EESSI/filesystem-layer/releases/download/latest/cvmfs-config-eessi_latest_all.deb
sudo dpkg -i cvmfs-config-eessi_latest_all.deb

sudo bash -c "echo 'CVMFS_CLIENT_PROFILE="single"' > /etc/cvmfs/default.local"
sudo bash -c "echo 'CVMFS_QUOTA_LIMIT=10000' >> /etc/cvmfs/default.local"

sudo cvmfs_config setup
#source /cvmfs/pilot.eessi-hpc.org/latest/init/bash
source /cvmfs/software.eessi.io/versions/2023.06/init/bash
ml load OpenFOAM/11-foss-2023a
source "$FOAM_BASH"
