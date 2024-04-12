## Nanoscale Molecular Dynamics (NAMD)


### Overview

Nanoscale Molecular Dynamics (NAMD) is a parallel molecular dynamics code
designed for high-performance simulation of large biomolecular systems,
including proteins, nucleic acids, and membranes, at the atomic level over
time.It is particularly valuable for understanding processes such as protein
folding, biomolecular recognition, and drug binding, among others. NAMD is
developed and maintained by the Theoretical and Computational Biophysics Group
at the University of Illinois at Urbana-Champaign.



### Download

The application can be downloaded from here:

binary: <https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD>

source: <https://www.ks.uiuc.edu/Research/namd/development.html>


### Installation


#### From binary (option 1)

- Script (ubuntu): [install_ubuntu.sh](install_ubuntu.sh)


##### From spack (option 2)

It is also possible to install the application from spack tool. Here is the script to do so:

- Installation script via spack:
[install_ubuntu_azure_hpc_image_spack.sh](install_ubuntu_azure_hpc_image_spack.sh)


##### From EESSI (option 3)


EESSI, can also be used to make the applicaton available in your system. Here is the
script:
- Installation script via EESSI: [install_ubuntu_azure_hpc_image_eessi.sh](install_ubuntu_azure_hpc_image_eessi.sh)


### Execution


Input files for examples can be found here:
<https://www.ks.uiuc.edu/Research/namd/utilities/>

##### Using single node (installed from ubuntu binary tgz)

# make sure namd is in the path and libraries to run namd are ok


```
which namd3
ldd namd3
```

```
wget --no-check-certificate https://www.ks.uiuc.edu/Research/namd/utilities/apoa1.tar.gz
tar -xvzf apoa1.tar.gz
cd apoa1
namd3 apoa1.namd
```

```
wget --no-check-certificate  https://www.ks.uiuc.edu/Research/namd/utilities/stmv.tar.gz
tar -xvzf stmv.tar.gz
cd stmv
namd3 stmv.namd
```

These examples use 1 process. Replace to `namd3 +auto-provision` to use all
machine resources.


##### Using multiple nodes (slurm)


```
#!/bin/bash
#SBATCH -N 2

#module load mpi
module load mpi/hpcx
which mpirun

DIR=$HOME/NAMD_3.0b6_Linux-x86_64-verbs-smp
cd $DIR

# get number of cores/node
N=$(awk '/processor/{a=$3}END{print a}' /proc/cpuinfo)

# generate NAMD nodelist
for n in `echo $SLURM_NODELIST | scontrol show hostnames`; do
  echo "host $n ++cpus $N" >> nodelist.$SLURM_JOBID
done

PPN=$(($N - 1))
P=$(($PPN * $SLURM_NNODES))

time charmrun $DIR/namd3 ++p $P ++nodelist nodelist.$SLURM_JOBID +setcpuaffinity apoa1.namd
```






### References
- NAMD Website: <https://www.ks.uiuc.edu/Research/namd/>
- NAMD Download (precompiled):
  <https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD>
- NAMD Download (source):
  <https://www.ks.uiuc.edu/Research/namd/development.html>
- Spack getting started: <https://spack.readthedocs.io/en/latest/getting_started.html>
- EESSI: <https://www.eessi.io/docs/getting_access/native_installation/>
- Accelerating NAMD on Azure HB-series VMs (blog):
<https://techcommunity.microsoft.com/t5/azure-high-performance-computing/accelerating-namd-on-azure-hb-series-vms/ba-p/3775531>
- Azure Benchmark code for NAMD experiment:
<https://github.com/arstgr/woc-benchmarking/tree/main/apps/hpc/namd>
- Azure HPC repo (NAMD folder):
<https://github.com/Azure/azurehpc/tree/69423ce2b9efc6027fa56ff71ad097b30a16a5e4/apps/namd>
- NAMD compilation recipe on Azure HPC GitHub Repository
<https://github.com/Azure/azurehpc/tree/master/apps/namd>
- NAMD examples (e.g. ApoA1, STMV, ATPase,...)
<https://www.ks.uiuc.edu/Research/namd/utilities/>
---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


