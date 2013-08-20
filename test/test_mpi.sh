## Prepare Env
. /etc/profile.d/modules.sh
module load openmpi/gcc/1.4.5/64

## Compile Test Binary
mpic++ hello.c -o tester

## Run Test Binary
mpirun -np 3 ./tester

## Remove Test Binary
rm -f ./tester
