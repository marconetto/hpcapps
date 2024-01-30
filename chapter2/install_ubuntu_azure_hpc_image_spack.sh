#!/usr/bin/env bash

sudo apt remove -y needrestart
sudo apt update -y
sudo apt install build-essential ca-certificates coreutils curl environment-modules gfortran git gpg lsb-release python3 python3-distutils python3-venv unzip zip -y
git clone -c feature.manyFiles=true https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh
spack compiler find

module load mpi/openmpi-4.1.5

cat <<EOF >"$HOME"/.spack/packages.yaml
packages:
  openmpi:
    externals:
    - spec: "openmpi@4.1.5%gcc@11.4.0 arch=x86_64"
      prefix: /opt/openmpi-4.1.5
EOF

time spack install --reuse wrf %gcc@11.4.0 ^openmpi@4.1.5
