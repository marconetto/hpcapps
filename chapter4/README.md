## Open Field Operation and Manipulation (OpenFOAM)


### Overview

OpenFOAM (Open Field Operation and Manipulation) is a free, open-source
computational fluid dynamics (CFD) software package developed by the OpenFOAM
Foundation. OpenFOAM has an extensive range of features to solve anything from
complex fluid flows involving chemical reactions, turbulence and heat transfer,
to acoustics, solid mechanics and electromagnetics. OpenFOAM uses the finite
volume method to discretize and solve the governing equations of fluid flow and
other related physical phenomena. OpenFOAM is used in several industries
including automotive, aerospace, energy, environmental engineering, chemical
processing, and academic research. OpenFOAM is professionally released every six
months to include customer sponsored developments and contributions from the
community. It is written in C++ is modular, which allows customizations.




### Download

The application can be downloaded from here:

binary: <https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled>

source: <https://develop.openfoam.com/Development/openfoam/-/blob/master/doc/Build.md>

requirements:
<https://develop.openfoam.com/Development/openfoam/blob/develop/doc/Requirements.md>

### Installation


#### From binary (option 1)

- Script (ubuntu): [install_ubuntu_binary.sh](install_ubuntu_binary.sh)

#### From source (option 2)

- Script (ubuntu) to compile: [install_ubuntu_azure_hpc_image.sh](./install_ubuntu_azure_hpc_image.sh)

##### From spack (option 2)

It is also possible to install the application from spack tool. Here is the script to do so:

- Installation script via spack:
[install_ubuntu_azure_hpc_image_spack.sh](install_ubuntu_azure_hpc_image_spack.sh)


##### From EESSI (option 3)


EESSI, can also be used to make the applicaton available in your system. Here is the
script:
- Installation script via EESSI: [install_ubuntu_azure_hpc_image_eessi.sh](install_ubuntu_azure_hpc_image_eessi.sh)


### Execution


##### Using single node (OpenFOAM default number of domain/processes)

The default number of domains is 6. So the example below runs the application
with 6 processes.

If installed via `apt-get`, run this sequence of steps:

```
openfoam2312
cp $FOAM_TUTORIALS/incompressible/simpleFoam/motorBike . -a
cd motorBike
# see domains
cat system/decomposeParDict.6
# run simulation
./Allrun
```


If installed via source code:
```
source "$INSTALL_DIR/OpenFOAM-v2312/etc/bashrc"
cp -r "$FOAM_TUTORIALS/incompressible/simpleFoam/motorBike"
cd motorBike
./Allrun
```

If installed via EESSII:

```
sudo mount -t cvmfs software.eessi.io /cvmfs/software.eessi.io
source /cvmfs/software.eessi.io/versions/2023.06/init/bash
ml load OpenFOAM
source $FOAM_BASH
sudo cp -r $FOAM_TUTORIALS/incompressibleFluid/motorBike/motorBike .
sudo chown -R `id -u`:`id -g` motorBike
sudo chmod -R 777 motorBike
cd motorBike
./Allrun
```


##### Using single node (custom number of domains)

To run on more cores, the domains need to be updated including the hierarchy:

Inside the `Allrun` script, there is this line:


```
decompDict="-decomposeParDict system/decomposeParDict.6"
```

You can therefore, either use the current `decompParDict` file, or create a new
one. Let's assume you want to update the existing file, from 6 to 16 domains.
Watchout for the numbers and amount of spaces, which may vary from application
version.

```
sed -i 's/numberOfSubdomains 6;/numberOfSubdomains 16;/' system/decomposeParDict.6
sed -i 's/n           (3 2 1);/n           (4 4 1);/' system/decomposeParDict.6
```

Alternatively, a more interesting way to update the file, via `foamDictionary`:

```
foamDictionary -entry numberOfSubdomains -set "16" system/decomposeParDict.6
foamDictionary -entry "coeffs/n" -set "( 4 4 1 )" system/decomposeParDict.6
```

If you decided to create a new `decomposeParDict` file, you need to replace it
in `Allrun`. For instance:

```
sed -i "s#system/decomposeParDict.6#system/decomposeParDict.my16#" "Allrun"
```

##### Using multiple nodes (using eessi+slurm)


```
#!/bin/bash
#SBATCH --nodes=4
#SBATCH --tasks-per-node=2

source /cvmfs/software.eessi.io/versions/2023.06/init/bash
module load OpenFOAM

source $FOAM_BASH
#module load OpenMPI

which simpleFoam
sudo cp -r $FOAM_TUTORIALS/incompressibleFluid/motorBike/motorBike .

sudo chown -R `id -u`:`id -g` motorBike
sudo chmod -R 777 motorBike

scontrol show hostname "$SLURM_JOB_NODELIST" | sort -u > "$HOME/nodefile-$SLURM_JOB_ID"

mpiopts="$mpiopts -np $SLURM_NTASKS --hostfile $HOME/nodefile-$SLURM_JOB_ID"

cd motorBike
time ./Allrun
```

##### Using multiple nodes (using compiled+slurm)

script: [./slurm_job_eessi.sh](slurm_job_eessi.sh)



##### Check successful execution


```
LOGFILE="log.simpleFoam"
#LOGFILE="log.foamRun"
if [[ -f $LOGFILE && $(tail -n 1 $LOGFILE) == 'Finalising parallel run' ]]; then
  echo "Test passed"
else
  echo "Test failed"
fi
```


### Notes:

`WM_PROJECT_DIR`: an environment variable for the root directory of the OpenFOAM
installation. It is used by various scripts and utilities within OpenFOAM to
locate necessary files, libraries, and executables.


### References
- OpenFOAM Website: <https://www.openfoam.com/>
- OpenFOAM Download (precompiled):
  <https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled>
- OpenFOAM Download (source):
  <https://develop.openfoam.com/Development/openfoam/-/blob/master/doc/Build.md>
- OpenFOAM requirements:
<https://develop.openfoam.com/Development/openfoam/blob/develop/doc/Requirements.md>
- Spack getting started: <https://spack.readthedocs.io/en/latest/getting_started.html>
- EESSI: <https://www.eessi.io/docs/getting_access/native_installation/>
- OpenFOAM in Azure CycleCloud (blog):
<https://techcommunity.microsoft.com/t5/azure-high-performance-computing/accelerating-openfoam-integration-with-azure-cyclecloud/ba-p/4055616>
- Azure Benchmark code for OpenFOAM experiment:
<https://github.com/arstgr/woc-benchmarking/tree/main/apps/hpc/openfoam>
- Azure HPC repo (OpenFOAM folder):
<https://github.com/Azure/azurehpc/tree/69423ce2b9efc6027fa56ff71ad097b30a16a5e4/apps/openfoam_org>
- OpenFOAM motorBike info:
<https://develop.openfoam.com/committees/hpc/-/wikis/home>
---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


