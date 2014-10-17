#!/usr/bin/env bash

#SBATCH --ntasks=3
#SBATCH --cpus-per-task=1
#SBATCH -t 10:00
#SBATCH -J test
#SBATCH -o log.%j
#SBATCH --mail-type=begin
#SBATCH --mail-type=end

echo '-------------------------------'
cd ${SLURM_SUBMIT_DIR}
echo ${SLURM_SUBMIT_DIR}
echo Running on host $(hostname)
echo Time is $(date)
echo SLURM_NODES are $(echo ${SLURM_NODELIST})
echo '-------------------------------'
echo -e '\n\n'

## Prepare Env
. /etc/profile.d/modules.sh

source ~/.bashrc

ulimit

## Compile Test Binary
mpic++ hello.c -o tester

## Run Test Binary
mpirun -mca btl ^openib ./tester
srun ./tester

## Remove Test Binary
rm -f ./tester
