## OSU Micro-Benchmarks


### Overview

The OSU Micro-Benchmarks (OMB) are a suite of benchmarks developed by the Ohio
State University (OSU) to evaluate the performance of message passing and shared
memory communication in HPC environments. It can be used to measure
point-to-point, collective, and one-sided MPI communication, evaluate MPI
latency, bandwidth, and message rate, measure remote memory access (RMA)
performance, among others.


Note: here we assume you have a cluster in azure, which you can build using for
instance [CycleCloud SLURM workspace](https://learn.microsoft.com/en-us/azure/cyclecloud/qs-deploy-ccws?view=cyclecloud-8)

### Installation from Azure HPC Image

OSU is available with Azure HPC images.

For instance, if you use the image `almalinux:almalinux-hpc:8-hpc-gen2:latest` and you load hpcx:

```
module load mpi/hpcx
```

You will find OSU here (or similar path):
```
/opt/hpcx-v2.18-gcc-mlnx_ofed-redhat8-cuda12-x86_64/ompi/tests/osu-micro-benchmarks
```


### Installation from source

https://sc20.hpcworkshops.com/08-efa/04-complie-run-osu.html

### Run simple latency (shared memory) on a single node:

```
mpirun -np 2 ./osu_latency
# OSU MPI Latency Test v7.3
# Size          Latency (us)
# Datatype: MPI_CHAR.
1                       0.12
2                       0.12
4                       0.12
8                       0.12
16                      0.11
32                      0.13
...
```

### Run latency test with 2 nodes (slurm)

Here we have two examples, one using IB via [HBv3](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/high-performance-compute/hbv3-series?tabs=sizebasic) machine, and another using Ethernet.


Create a script called `osu.sh`
```
#!/bin/bash
#SBATCH -N 2
#SBATCH --ntasks-per-node 1

#module load mpi
module load mpi/hpcx
which mpirun

APP=/opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/hpcx-rebuild/tests/osu-micro-benchmarks/osu_latency

mpirun -np ${SLURM_NTASKS} $APP
```

Run:

```
sbatch osu.sh
```

Output:
```
Loading mpi/hpcx
  Loading requirement:
    /opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/modulefiles/hpcx
/opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/ompi/bin/mpirun
# OSU MPI Latency Test v7.3
# Size          Latency (us)
# Datatype: MPI_CHAR.
1                       1.71
2                       1.71
4                       1.71
8                       1.71
16                      1.72
32                      1.89
64                      1.94
128                     1.95
256                     2.48
512                     2.55
1024                    2.70
2048                    2.89
4096                    3.63
8192                    4.18
16384                   5.25
32768                   6.86
65536                   9.19
131072                 13.85
262144                 17.64
524288                 28.44
1048576                50.07
2097152                92.75
4194304               177.71
```

Create a script called `osu_ethernet.sh`:

```
#!/bin/bash
#SBATCH -N 2
#SBATCH --ntasks-per-node 1

#module load mpi
module load mpi/hpcx
which mpirun

APP=/opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/hpcx-rebuild/tests/osu-micro-benchmarks/osu_latency

export UCX_NET_DEVICES=eth0
export UCX_TLS=tcp,self,sm

mpirun --mca pml ucx --mca btl ^openib -np ${SLURM_NTASKS} $APP
```

Run:

```
sbatch osu_ethernet.sh
```

```
Loading mpi/hpcx
  Loading requirement:
    /opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/modulefiles/hpcx
/opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/ompi/bin/mpirun
# OSU MPI Latency Test v7.3
# Size          Latency (us)
# Datatype: MPI_CHAR.
1                      28.90
2                      28.95
4                      28.88
8                      29.36
16                     29.35
32                     29.32
64                     29.34
128                    29.58
256                    29.71
512                    30.18
1024                   31.14
2048                   48.60
4096                   48.89
8192                   49.84
16384                  69.42
32768                  73.34
65536                 148.47
131072                159.46
262144                332.43
524288                458.98
1048576               757.19
2097152              1244.72
4194304              2304.61
```

You can also explore bandwidth and other OSU tests from the same folder where
`osu_latency` is located.


```
ls /opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/ompi/tests/osu-micro-benchmarks

osu_acc_latency      osu_cas_latency      osu_ialltoallw            osu_iscatter             osu_oshm_atomics      osu_oshm_reduce
osu_allgather        osu_fop_latency      osu_ibarrier              osu_iscatterv            osu_oshm_barrier      osu_put_bibw
osu_allgatherv       osu_gather           osu_ibcast                osu_latency              osu_oshm_broadcast    osu_put_bw
osu_allreduce        osu_gatherv          osu_igather               osu_latency_mp           osu_oshm_collect      osu_put_latency
osu_alltoall         osu_get_acc_latency  osu_igatherv              osu_latency_mt           osu_oshm_fcollect     osu_reduce
osu_alltoallv        osu_get_bw           osu_ineighbor_allgather   osu_latency_persistent   osu_oshm_get          osu_reduce_scatter
osu_alltoallw        osu_get_latency      osu_ineighbor_allgatherv  osu_mbw_mr               osu_oshm_get_mr_nb    osu_scatter
osu_barrier          osu_hello            osu_ineighbor_alltoall    osu_multi_lat            osu_oshm_get_nb       osu_scatterv
osu_bcast            osu_iallgather       osu_ineighbor_alltoallv   osu_neighbor_allgather   osu_oshm_put
osu_bibw             osu_iallgatherv      osu_ineighbor_alltoallw   osu_neighbor_allgatherv  osu_oshm_put_mr
osu_bibw_persistent  osu_iallreduce       osu_init                  osu_neighbor_alltoall    osu_oshm_put_mr_nb
osu_bw               osu_ialltoall        osu_ireduce               osu_neighbor_alltoallv   osu_oshm_put_nb
osu_bw_persistent    osu_ialltoallv       osu_ireduce_scatter       osu_neighbor_alltoallw   osu_oshm_put_overlap
```

Example of output `osu_bw`:

```
Loading mpi/hpcx
  Loading requirement:
    /opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/modulefiles/hpcx
/opt/hpcx-v2.18-gcc-mlnx_ofed-ubuntu22.04-cuda12-x86_64/ompi/bin/mpirun
# OSU MPI Bandwidth Test v7.3
# Size      Bandwidth (MB/s)
# Datatype: MPI_CHAR.
1                       3.95
2                       7.94
4                      16.04
8                      31.32
16                     64.13
32                    124.65
64                    241.89
128                   480.56
256                   930.61
512                  1724.03
1024                 3386.45
2048                 5974.79
4096                 9055.79
8192                13566.28
16384               18882.20
32768               21729.77
65536               23157.28
131072              23832.57
262144              24218.88
524288              24353.04
1048576             24449.68
2097152             24551.96
4194304             24537.62
```

### References
- OSU Micro-Benchmarks Website:
<https://ulhpc-tutorials.readthedocs.io/en/latest/parallel/mpi/OSU_MicroBenchmarks/>

---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


