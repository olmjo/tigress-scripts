#!/bin/sh
#SBATCH -N 1
#SBATCH --ntasks-per-node=20
#SBATCH -t 10:00

Rscript -e 'a <- rnorm(1e3)'

