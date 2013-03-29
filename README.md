# Example Tigress Scripts

Jonathan Olmsted (jpolmsted@gmail.com)

## Disclaimer

These scripts are intended as an example of how to use the
[TIGRESS](http://www.princeton.edu/researchcomputing/) HPC resources at
Princeton University. The various examples comprise different use cases and can
be customized to anyone's liking. Nothing is a substitute for reading the man
page: just run `man qsub` for a starting point.

## Access and Use

Anyone is free to use these scripts as they choose. You can not only view them
through gh, but you can download a copy locally and run them (Note: they don't
have many dependencies, but I can only guarantee them to work on TIGRESS
systems.)

The easiest way to get a copy is:
```
git clone https://github.com/olmjo/tigress-scripts.git
```

Then, you can
```
cd ./tigress-scripts/examples/ex0/
qsub ex0.pbs
```
to submit your first job.


## Contents

There are a total of five sets of scripts in this project. Each set can be used
to submit a perfectly legal job on Della (and elsewhere, usually). They are
located in `./examples/`. The shell scripts with a `.pbs` suffix are PBS scripts
for the resource manager to submit. The scripts with a `.R` suffix are R scripts
that represent our computational jobs. The concepts covered here
should cover most usage.

### ex0 -- bare bones

This is a bare bones example. It requests 1 node with 1 processor on the
node. It allows the scheduler to kill the job after 10 minutes. The script
simply generates 1,000 random numbers using the `Rscript` interface to `R`.

See `./examples/ex0/`.

### ex1 -- a reasonable default

This PBS script represents a reasonable starting point for simple jobs. It is
more explicit about how the job should be managed than Example 0. It still
requests 1 node with 1 processor. It requests only 10 minutes of time. It uses a
custom name in the queue and has both the error log and the output log merged
into one file which begins with `log.*` and has a suffix determined by the job
ID. It requests emails when it begins, ends, and aborts (the email address can
be specified manually, but works by default on TIGRESS systems).

Every line beginning with `#` is just a PBS directive. The remainder comprises
an actual shell script. The script is verbose about where it is, when it starts,
and what resources were given to it by the scheduler.

The script ultimately generates 1,000 random numbers using the `Rscript`
interface to `R`.

See `./examples/ex1/`.

### ex2 -- ex 1 + an R script

This PBS script includes all the reasonable defaults from Example 1. The only
change is that it uses `Rscript` to run an external R script, which is how the
job would usually be programmed.

The computational task in R is a copy of the example usage of `ideal()` from the
R package `pscl`.

See `./examples/ex2/`.

### ex3 -- ex 2 + parallel execution + passing arguments to R

This PBS script uses the sample reasonable defaults from above, but it requests
two processors on the node. We define the environmental variable `TOTALPROCS`
and make sure it is available to processes started in this script (via
`export`). Now `Rscript` has to be invoked from within the `mpiexec`
command. The master MPI process knows what resources were allocated from
`-hostfile $PBS_NODEFILE`. Lastly, our R script is taking a final unnamed
argument of `8`.

In the R script, the first set of commands parse the command line argument
passed to R (i.e. `8`). The next set of commands are reading the environmental
variable `TOTALPROCS`. We then set up the MPI backend and as each of our MPI
workers to tell us where they are running.

See `./examples/ex3/`.

### ex4 -- ex 2 + multiple simultaneous submissions + passing arguments to R

This PBS script now requests an array of jobs based on the template. For jobs in
this array (indexed from 1 to 3), the shell script will run given the requested
resources. Because the log file depends on the job ID, each of the three jobs
will generated different `log.*` output. Because we R can read the environmental
variable `PBS_ARRAYID`, we are able to use the index on an object of interest to
us in R (e.g., a vector of names of files in a directory to be processed).

With this setup, each sub-job is requesting the same resources.

See `./examples/ex4/`.
