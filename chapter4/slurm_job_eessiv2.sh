#!/bin/bash
#SBATCH --nodes=4
#SBATCH --tasks-per-node=120

source /cvmfs/software.eessi.io/versions/2023.06/init/bash
module load OpenFOAM

source "$FOAM_BASH"
#module load OpenMPI

which simpleFoam
rundir=$HOME/motorbike.$SLURM_JOB_ID

NODES=$SLURM_JOB_NUM_NODES
PPN=$SLURM_NTASKS_PER_NODE
NP=$(($NODES * $PPN))

echo "NODES=$NODES, PPN=$PPN, NP=$NP"

sudo cp -r "$FOAM_TUTORIALS"/incompressibleFluid/motorBike/motorBike "$ru"
ndir

sudo chown -R $(id -u):$(id -g) "$rundir"
sudo chmod -R 777 "$rundir"
cd "$rundir" || exit

machinefile="$rundir/nodefile-$SLURM_JOB_ID"
scontrol show hostname "$SLURM_JOB_NODELIST" | sort -u > "$machinefile"

export UCX_NET_DEVICES=mlx5_ib0:1
export OMPI_MCA_pml=ucx

# allow flags to be added to the mpirun command through FOAM_MPIRUN_FL
AGS environment variable
sed -i '/RunFunctions/a source <(declare -f runParallel | sed "s/mpiru
n/mpirun \\\$FOAM_MPIRUN_FLAGS/g")' Allrun
sed -i 's#/bin/sh#/bin/bash#g' Allrun

export FOAM_MPIRUN_FLAGS="--hostfile $machinefile $(env | grep 'WM_\|F
OAM_' | cut -d'=' -f1 | sed 's/^/-x /g' | tr '\n' ' ') -x PATH -x LD_L
IBRARY_PATH -x MPI_BUFFER_SIZE -x UCX_IB_MLX5_DEVX=n -x UCX_POSIX_USE_
PROC_LINK=n --report-bindings --verbose --map-by core --bind-to core "
echo "$FOAM_MPIRUN_FLAGS"



# Determine X,Y,Z based on total cores
if [ "$(($PPN % 4))" == "0" ]; then
  X=$(($NP / 4))
  Y=2
  Z=2
elif [ "$(($PPN % 6))" == "0" ]; then
  X=$(($NP / 6))
  Y=3
  Z=2
elif [ "$(($PPN % 9))" == "0" ]; then
  X=$(($NP / 9))
  Y=3
  Z=3
else
  echo "Incompataible value of PPN: $PPN. Try something that is divisa
ble by 4,6, or 9"
  exit 1
fi

echo "X: $X, Y: $Y, Z: $Z"

foamDictionary -entry numberOfSubdomains -set "$NP" system/decomposePa
rDict
foamDictionary -entry "hierarchicalCoeffs/n" -set "( $X $Y $Z )" syste
m/decomposeParDict
foamDictionary -entry blocks -set "( hex ( 0 1 2 3 4 5 6 7 ) ( $BLOCKM
ESH_DIMENSIONS ) simpleGrading ( 1 1 1 ) )" system/blockMeshDict


# foamDictionary \
#   -entry "castellatedMeshControls/maxGlobalCells" \
#   -set 30000000 \
#   system/snappyHexMeshDict
#
# foamDictionary \
#   -entry "castellatedMeshControls/maxLocalCells" \
#   -set 200000 \
#   system/snappyHexMeshDict

# foamDictionary -entry "castellatedMeshControls/refinementSurfaces/mo
torBike/level" -set "(5 7)" system/snappyHexMeshDict

time ./Allrun
