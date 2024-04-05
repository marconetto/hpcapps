#!/bin/bash
#SBATCH --nodes=4
#SBATCH --tasks-per-node=40
#

#BLOCKMESH_DIMENSIONS="20 8 8" # 0.35M cells
BLOCKMESH_DIMENSIONS="40 16 16" # 1.89M cells
#BLOCKMESH_DIMENSIONS="80 32 32" # 11.23M cells
#BLOCKMESH_DIMENSIONS="100 40 40" # 22 million case
#BLOCKMESH_DIMENSIONS="130 52 52"   # 42 million case

source /cvmfs/software.eessi.io/versions/2023.06/init/bash
module load OpenFOAM

source "$FOAM_BASH"
#module load OpenMPI

EXECDIR=motorBike.$$
cp -r "$FOAM_TUTORIALS"/incompressibleFluid/motorBike/motorBike $EXECDIR

chmod -R u+w $EXECDIR
cd $EXECDIR || exit

scontrol show hostname "$SLURM_JOB_NODELIST" | sort -u >"$HOME/$EXECDIR/nodefile-$SLURM_JOB_ID"

mpiopts="$mpiopts -np $SLURM_NTASKS --hostfile $HOME/$EXECDIR/nodefile-$SLURM_JOB_ID"

echo "SLURM TASKS=$SLURM_NTASKS"
#cp "system/decomposeParDict" "system/decomposeParDict.$NPROCS"
NODES=$SLURM_JOB_NUM_NODES
TASKS_PER_NODE=$SLURM_NTASKS_PER_NODE
NTASKS=$SLURM_NTASKS

X=$(($NTASKS / 4))
Y=2
Z=2

foamDictionary -entry numberOfSubdomains -set "$NTASKS" system/decomposeParDict

foamDictionary -entry "hierarchicalCoeffs/n" -set "( $X $Y $Z )" system/decomposeParDict

foamDictionary -entry blocks -set "( hex ( 0 1 2 3 4 5 6 7 ) ( $BLOCKMESH_DIMENSIONS ) simpleGrading ( 1 1 1 ) )" system/blockMeshDict

time ./Allrun

#LOGFILE="log.simpleFoam"
LOGFILE="log.foamRun"
if [[ -f $LOGFILE && $(tail -n 1 $LOGFILE) == 'Finalising parallel run' ]]; then
  echo "Simulation completed"
else
  echo "Simulation failed"
fi
