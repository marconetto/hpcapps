## Weather Research & Forecasting Model (WRF)


#### Overview

The Weather Research and Forecasting (WRF) Model is a well known system for
meteorologists and researchers to simulate and predict weather patterns at
various spatial and temporal scales. WRF can simulate atmospheric processes,
including dynamics, thermodynamics, and microphysical processes. The model can
be configured for different domains, resolutions, and parameterizations, and it
is widely used for benchmarking HPC systems.


#### Download

The application can be downloaded from here:

<https://www2.mmm.ucar.edu/wrf/users/download/get_source.html>

First time users should register themselves into this portal.

Once you register there, you will be pointed to the website below containing the
git link for download:
<https://www2.mmm.ucar.edu/wrf/users/download/get_sources_new.php>

Note: code prior to WRF v4.0 can be found here:
<https://www2.mmm.ucar.edu/wrf/users/download/get_sources.html>

Here is how you obtain the latest WRF:


```
git clone --recurse-submodules https://github.com/wrf-model/WRF
```

#### Compilation

The link below contains the full instructions on how to compile WRF and
WPS---some variation may happen due to environment setup:

<https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php>

**Note: this official doc does not cover hdf5 installation. It should be installed
before netcdf.**


If you want the automation of these steps you can download the following script:

- Script (GNU compiler): [install_ubuntu_azure_hpc_image.sh](install_ubuntu_azure_hpc_image.sh)


This script uses gcc and gfortran, and will NOT install openmpi. The process may
take several minutes. This script basically has parts of the official WRF
compilation guide and parts of another installation guide:
<https://forum.mmm.ucar.edu/threads/full-wrf-and-wps-installation-example-gnu.12385/>





#### Execution

To start execution, first we need to download a few input files.

The following URL contains the links to WRF benchmarking data:

<https://www2.mmm.ucar.edu/wrf/users/benchmark/benchmark.htm>

When selecting WRF 4.4 for instance, one will be moved to this page:

<https://www2.mmm.ucar.edu/wrf/users/benchmark/v44/benchdata_v44.html>

Which contains the CONUS 12-km and CONUS 2.5-km tar files:

- <https://www2.mmm.ucar.edu/wrf/users/benchmark/v44/v4.4_bench_conus2.5km.tar.gz>
- <https://www2.mmm.ucar.edu/wrf/users/benchmark/v44/v4.4_bench_conus12km.tar.gz>


Let's say we want to test conus 12km.


```
wget https://www2.mmm.ucar.edu/wrf/users/benchmark/v44/v4.4_bench_conus12km.tar.gz
tar zxvf v4.4_bench_conus12km.tar.gz
cd v4.4_bench_conus12km
export WRFDATAINPUTDIR=$(pwd)
```

CONUS 12-km is the input data that can be used by WRF model to simulate
atmospheric events that took place during the 2019 Pre-Thanksgiving Winter Storm
The model domain represents the Continental United States (CONUS), using 12-km
grid spacing (i.e each grid point is 12x12 km).

Assume `WRFDIR` is the directory created when WRF was downloaded with git. To
execute WRF, move to WRF run directory and make to data input:

```
cd "$WRFDIR"/run
ln -sf "$WRFDATAINPUTDIR"/* .
mpirun -np 4 wrf.exe
```

By opening another terminal, you can see the progress with the following command
(on the same run directory)

```
tail -f rsl.out.0000
```

which will generate something like:

```
...
...
Timing for main: time 2019-11-26_23:56:24 on domain   1:    1.66375 elapsed seconds
Timing for main: time 2019-11-26_23:57:36 on domain   1:    1.66340 elapsed seconds
Timing for main: time 2019-11-26_23:58:48 on domain   1:   15.93291 elapsed seconds
Timing for main: time 2019-11-27_00:00:00 on domain   1:    1.65817 elapsed seconds
Timing for Writing wrfout_d01_2019-11-27_00:00:00 for domain        1:   10.77992 elapsed seconds
d01 2019-11-27_00:00:00 wrf: SUCCESS COMPLETE WRF
```



#### References
- WRF Website: <https://www.mmm.ucar.edu/models/wrf>
- WRF–ARW Online Tutorial: <https://www2.mmm.ucar.edu/wrf/OnLineTutorial/index.php>
- WRF+SLURM: <https://portal.supercomputing.wales/wp-content/uploads/2018/06/Lab_Worksheet_WRF_SCW_SLURM-1.pdf>
- WRF benchmarking data: <https://ieeexplore.ieee.org/document/8121622>
- WRF official compilation guide (missing hdf5 installation):
  <https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php>
- WRF Azure deployment architecture:
  <https://learn.microsoft.com/en-us/azure/architecture/guide/hpc/weather-research-forecasting>
- WRF official benchmark data:
  <https://www2.mmm.ucar.edu/wrf/users/benchmark/benchmark.htm>
- WRF benchmark on NERSC systems: <https://docs.nersc.gov/applications/wrf/wrf_benchmark/>
- Full WRF and WPS Installation Example (GNU):
<https://forum.mmm.ucar.edu/threads/full-wrf-and-wps-installation-example-gnu.12385/>
- Full WRF and WPS Installation Example (Intel):
<https://forum.mmm.ucar.edu/threads/full-wrf-and-wps-installation-example-intel.15229/>

---
<br>

*DISCLAIMER: This document is work-in-progress and my personal experience
performing this task.*

---


