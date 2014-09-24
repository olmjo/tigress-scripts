#!/usr/bin/env bash

#PBS -l nodes=1:ppn=5
#PBS -l walltime=00:05:00
#PBS -N MatlabEx
#PBS -j oe
#PBS -o log.${PBS_JOBID}

echo '-------------------------------'
cd $PBS_O_WORKDIR
echo $PBS_O_WORKDIR
echo Running on host $(hostname)
echo Time is $(date)
echo PBS_NODEFILE is $(cat $PBS_NODEFILE)
echo '-------------------------------'
echo -e '\n\n'

EXEC=/usr/licensed/bin/matlab
OPTS=' -singleCompThread -nodisplay -nosplash'

export PROCS=`cat $PBS_NODEFILE|wc -l`

${EXEC}${OPTS} < ex5.m