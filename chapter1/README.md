## Matrix Multiplication - Hello World ;-)



#### Overview

Matrix multiplication is a common application to be written when you start
working with HPC. It is a kind of "hello world" application in HPC.

There are a few ways to implement the application. In general we have a manager
process that coordinates which lines and columns should be multiplied by each
worker process, so they can work in parallel to return the results to the
manager process.

The code below represents a matrix multiplier that considers squared matrices.
It allows parameters: (i) one is the size of the matrices (single dimension as
it they are squared matrices), and (ii) number of times the matrices are
multiplied. The second option is to have some flexibility to have long running
executions for testing purposes


#### Download

The application can be downloaded from here:

<https://github.com/marconetto/testbed/blob/main/mpi_matrix_mult.c>


#### Compilation

Assuming one has gcc and an mpi implementation, the following commands can be
used to compile the application---some variation may happen due to environment
setups:

```
source /etc/profile.d/modules.sh
module load gcc-9.2.0
module load mpi/hpcx
mpicc -o mpi_matrix_mult.c mpi_matrix_mult
```

#### Execution

Execution of the application requires two parameters to be set, e.g.:

```
APPMATRIXSIZE=6000
APPINTERACTIONS=10
```

This will multiply two matrices of integers containing 6000 elements, and such
multiplication will happen 10 times.



```
source /etc/profile.d/modules.sh

module load gcc-9.2.0
module load mpi/hpcx

mpirun -np 16 \
       --host host1:8,host2:8 \
       --map-by ppr:8:node \
       mpi_matrix_mult ${APPMATRIXSIZE} ${APPINTERACTIONS}
```


#### References

- Examples of HPC hello world apps: <https://hpc-tutorials.llnl.gov/mpi/>

---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


