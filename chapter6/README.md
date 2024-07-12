## Large-scale Atomic/Molecular Massively Parallel Simulator (LAMMPS)


### Overview

Large-scale Atomic/Molecular Massively Parallel Simulator (LAMMPS) is
a molecular dynamics simulator designed to model particles in a variety of
scientific and engineering applications. Developed by Sandia National
Laboratories, it is highly scalable, so one can run it on single processors or
in parallel using message-passing techniques. LAMMPS uses spatial-decomposition
techniques to partition the simulation domain into small 3D sub-domains, one of
which is assigned to each processor.


### Download

The application can be downloaded from here:

binary: <https://docs.lammps.org/Install_linux.html>

source: <https://docs.lammps.org/Install_git.html>


### Installation


#### From binary (option 1)

Ubuntu:
```
sudo apt-get install lammps
```

AlmaLinux:

```
sudo yum install -y lammps
```

##### From EESSI (option 2)


EESSI, can also be used to make the applicaton available in your system. Here is the
script:
- Installation script via EESSI: [install_ubuntu_azure_hpc_image_eessi.sh](install_ubuntu_azure_hpc_image_eessi.sh)


### Execution


Benchmarks for LAMMPS:
<https://www.lammps.org/bench.html>

Download a benchmark, for instance Lennard-Jones liquid:
```
wget https://www.lammps.org/inputs/in.lj.txt

```

##### Using single node (installed from ubuntu binary)

Make sure lmp is installed and libraries to run lmp are ok

```
which lmp
ldd $(which lmp)
```


Ru the benchmark:

```
time lmp -in in.lj.txt
```

This example runs fast, you may want to modify the input (example add more
timesteps, or increase box dimensions).

You can add this line in the input to see more info about the simulation
(including number of atoms):

```
thermo_style    custom step atoms temp epair etotal
```


##### Using multiple nodes (slurm)


```
#!/bin/bash
#SBATCH -N 2

#module load mpi
module load mpi/hpcx
which mpirun

time mpirun -np $NP lmp -i in.lj.txt
```


### References
- LAMMPS Website: <https://www.lammps.org/>
- LAMMPS Download (source):
  <https://www.lammps.org/download.html>
- Spack getting started: <https://spack.readthedocs.io/en/latest/getting_started.html>
- EESSI: <https://www.eessi.io/docs/getting_access/native_installation/>
- Azure Benchmark code for LAMMPS experiment:
<https://github.com/Azure/woc-benchmarking/tree/main/apps/hpc/lammps>
- Azure HPC repo (LAMMPS folder):
<https://github.com/Azure/azurehpc/tree/master/apps/lammps>
---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


