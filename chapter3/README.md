## GROningen MAchine for Chemical Simulations (GROMACS)


### Overview

The GROMACS (GROningen MAchine for Chemical Simulations) project originally
began in 1991 at Department of Biophysical Chemistry, University of Groningen,
Netherlands. GROMACS is widely used in computational chemistry, biochemistry,
and related fields for simulating the behavior of molecules at the atomic level.



### Download

The application can be downloaded from here:

<https://manual.gromacs.org/documentation/current/download.html>

### Compilation


#### From source code (option 1)

The link below contains the full instructions on how to compile GROMACS:

<https://manual.gromacs.org/documentation/current/install-guide/index.html>

If you want the automation of these steps you can download the following script:

- Script (GNU compiler) NO CLUSTER: [install_ubuntu_azure_hpc_image_simple.sh](install_ubuntu_azure_hpc_image_simple.sh)

- Script (GNU compiler) WITH CLUSTER: [install_ubuntu_azure_hpc_image_cluster.sh](install_ubuntu_azure_hpc_image_cluster.sh)




https://github.com/Azure/azurehpc/blob/master/apps/gromacs/install_gromacs.sh
https://castle.com.bd/gromacs-installation-on-ubuntu-linux/


##### From spack (option 2)

##### From EESSI (option 3)


### Execution

Examples of execution commands, which run a molecular dynamics simulation using the parameters specified in the `ion_channel.tpr` input file


```
export OMP_NUM_THREADS=2
wget https://repository.prace-ri.eu/ueabs/GROMACS/2.2/GROMACS_TestCaseA.tar.xz
tar -xf GROMACS_TestCaseA.tar.xz
cd GROMACS_TestCase || exit
mkdir outputs
```

Without MPI:

```
time gmx mdrun -s ion_channel.tpr \
               -deffnm outputs/md.TESTCASE \
               -cpt 1000 \
               -maxh 1.0 \
               -nsteps 500000 \
               -ntomp "$OMP_NUM_THREADS"
```


Without MPI:

```
time gmx mdrun -s ion_channel.tpr \
               -maxh 0.50 \
               -resethway \
               -noconfout \
               -nsteps 1000 \
               -g logfile
```

With MPI:

```
mpirun -np 8 gmx_mpi mdrun \
    -s ion_channel.tpr \
    -deffnm outputs/md.TESTCASE \
    -cpt 1000 \
    -maxh 1.0 \
    -nsteps 500000 \
    -ntomp $OMP_NUM_THREADS
```

Flags:


`gmx mdrun:` This is the command for running molecular dynamics simulations in GROMACS.

`-s ion_channel.tpr:` This flag specifies the input file containing the molecular dynamics parameters. In this case, it's ion_channel.tpr.

`-deffnm outputs/md.TESTCASE:` This flag specifies the base name for the output files. GROMACS will generate several output files with this base name followed by different extensions indicating the type of output.

`-cpt 1000:` This flag specifies the frequency (in steps) at which GROMACS writes checkpoints. In this case, it writes a checkpoint file every 1000 steps.

`-maxh 1.0:` This flag sets the maximum wall-clock time for the simulation to 1 hour (1.0 hour). If the simulation exceeds this time, it will terminate.

`-nsteps 500000:` This flag specifies the total number of steps for the simulation. In this case, it's set to 500,000 steps.

`-ntomp "$OMP_NUM_THREADS":` This flag specifies the number of OpenMP threads to be used for parallelization. The number of threads seems to be determined by the environment variable $OMP_NUM_THREADS, which typically specifies the number of threads available for OpenMP parallelization.

`-resethway:` This option instructs GROMACS to reset the Hamiltonian replica exchange weights.


`-noconfout:` This option specifies that no configuration (.gro/.pdb) files should be written during the simulation. Configuration files typically contain the atomic coordinates of the system at each step.


`-g logfile:` Specifies the name of the log file where GROMACS will write simulation information, such as energy terms, temperature, and pressure. In this case, it's named logfile.




### References
- GROMACS Website: <https://www.gromacs.org/>
- GROMACS Download:
  <https://manual.gromacs.org/documentation/current/download.html>
- Spack getting started: <https://spack.readthedocs.io/en/latest/getting_started.html>
- EESSI: <https://www.eessi.io/docs/getting_access/native_installation/>

---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


