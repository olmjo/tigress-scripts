## Prepare Env
module load openmpi

## Compile Test Binary
mpic++ hello.c -o tester

## Run Test Binary
mpirun -np 3 ./tester

## Remove Test Binary
rm -f ./tester
