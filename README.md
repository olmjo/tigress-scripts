# TIGRESS-scripts
Setup and Example scripts (mostly) for R-based HPC at Princeton University

Contact Jonathan Olmsted (jolmsted@princeton.edu) with questions or issues.

## What?

This project comprises a set of multiple example scripts and a setup script to
help prepare your HPC environment for R-based HPC. These scripts work *out of
the box* on Tukey, Della, and Adroit. There are some additional examples of using
Python and Matlab, but these are not the focus.  More information on these
scripts is below.

## Where?

These scripts have been tested on:
- Tukey
- Della
- Adroit

If you are using one of these systems and something isn't working, please email
for support.

## How?

### Getting a Copy

You can create a full copy of this git repository by cloning it. To do this, run
the following at the shell prompt from one of these systems:

```
git clone https://github.com/olmjo/tigress-scripts
```

On the Princeton TIGRESS systems, `git` will be installed so this "just
works". The same `git` command will work on your local machine if you have `git`
installed.

### Using

Start by navigating into the repository directory:

```
cd tigress-scripts
```

#### Setup and Test Scripts
For all of the example scripts to work, the shell environment needs to be set up
correctly and particular R packages need to be installed. The helper setup
script is located in `./setup/setup.sh`. To set up your environment, simply run
the script:
```
cd setup
./setup.sh
```

**Warning:** If you have never used R on these machines before, you start first
  start R, install any package at all, and then quit R before
  proceeding. Without having installed any R package in this way, the subsequent
  setup scripts won't work.

You will be prompted by several questions like

```
@ Do you want to set up your account to use an updated compiler version?
    Note 1: may be necessary for some R packages
    Note 2: only needs to be done once per system
    Note 3: may have no effect on certain machines
[y/n]

@ Do you need to DL Rmpi?
[y/n]


@ Do you need to add OpenMPI support?
    Note: needs to only be added once
[y/n]


@ Do you need to install Rmpi?
[y/n]


@ Do you need to install misc. HPC R packages?
[y/n]

```

If you've never run this before, answer "y" to each question.

To test the openmpi setup run the following:
```
cd ../test/
./test_mpi.sh
```

You should see output like:
```
Process 1 on tukey out of 3
Process 2 on tukey out of 3
Process 0 on tukey out of 3
```

#### Examples

There are a series of example scripts in this project. Each example can be used
to submit a perfectly valid job on the above listed systems. They are located in
the `./examples/` subdirectory. The shell scripts with a `.pbs` suffix are PBS
scripts for the Torque resource manager. The shell scripts with a `.slurm`
suffix are SLURM scripts. PBS scripts are not actively maintained since the
systems listed above all run SLURM. And, there is no promise that the SLURM and
PBS versions will always be "in sync".

In each example description, below, versions for either PBS, SLURM, or both are
indicated.

##### Example 0: Bare Bones
*PBS*, *SLURM*

This is a bare bones example. It requests 1 task with 1 processor. It allows the
scheduler to kill the job after 10 minutes. The script simply generates 1,000
random numbers using the Rscript interface to R.

To run under Torque:
```
cd ./examples/ex0/
qsub ex0.pbs
```

To run under SLURM:
```
cd ./examples/ex0/
sbatch ex0.slurm
```

##### Example 1: A Reasonable Default
*PBS*, *SLURM*

This script represents a reasonable starting point for simple jobs. It is
more explicit about how the job should be managed than Example 0. It still
requests 1 task with 1 processor. It requests only 10 minutes of time. It uses a
custom name in the queue and has both the error log and the output log merged
into one file which begins with log.* and has a suffix determined by the job
ID. It requests emails when it begins, ends, and aborts (the email address can
be specified manually, but works by default on TIGRESS systems).

Every line beginning with # is just a scheduler directive. The remainder
comprises an actual shell script. The script is verbose about where it is, when
it starts, and what resources were given to it by the scheduler.

The script ultimately generates 1,000 random numbers using the Rscript interface
to R.

To run under Torque:
```
cd ./examples/ex1/
qsub ex1.pbs
```

To run under SLURM:
```
cd ./examples/ex1/
sbatch ex1.slurm
```

##### Example 2: Example 1 + an external R script
*PBS*, *SLURM*

This script includes all the reasonable defaults from Example 1. The only
change is that it uses Rscript to run an external R script, which is how the job
would usually be programmed.

The computational task in R is a copy of the example usage of `ideal()` from the R
package **pscl**.

To run under Torque:
```
cd ./examples/ex2/
qsub ex2.pbs
```

To run under SLURM:
```
cd ./examples/ex2/
sbatch ex2.slurm
```

##### Example 3: Example 2 + parallel execution + passing arguments to R
*PBS*, *SLURM*

This job script uses the sample reasonable defaults from above, but it requests
3 tasks with 1 processor each. These tasks may land on the same physical
node, or not.

The R script uses an MPI backend to parallelize an R foreach loop across
multiple nodes. A total of 3 * 1 = 3 processors will be used for this job (but 1
task is kept for the "master" process). When running the R script, we pass the
value "10" as an unnamed argument. The R script then uses this value to
determine how many iterations of the foreach loop to run.

Each iteration of the foreach loop simply pauses for 1 second and then returns
some contextual information in a dataframe. This information includes where that
MPI process is running and what it's "id" is.

To run under Torque:
```
cd ./examples/ex3/
qsub ex3.pbs
```

To run under SLURM:
```
cd ./examples/ex3/
sbatch ex3.slurm
```

##### Example 4: Example 2 + job arrays + passing arguments to R
*PBS*, *SLURM*

This script now requests an array of jobs based on the template. For jobs in
this array (indexed from 1 to 3), the shell script will run given the requested
resources. Because the log file depends on the job ID, each of the three jobs
will generated different log.* output. Because R can read environmental
variables we are able to use the index on an object of interest to us in R
(e.g., a vector of names of files in a directory to be processed).

With this setup, each sub-job is requesting the same resources.

To run under Torque:
```
cd ./examples/ex4/
qsub ex4.pbs
```

To run under SLURM:
```
cd ./examples/ex4/
sbatch ex4.slurm
```

##### Example 5: single-node Matlab parallel execution
*PBS*

This script uses the default setup (see ex1), requests one task with 5
processors and runs a Matlab script. The Matlab script executes a loop
sequentially and then in parallel where each of `MC` iterations takes `MC/DUR`
seconds by construction. The parallel loop (i.e., the one using the `parfor`
construct) should be about `PROCS` times faster. This approach does not
generalize to parallel execution across nodes.

```
cd ./examples/ex5/
qsub ex5.pbs
```

##### Example 6: "Substantive" Example Supporting Cross-Node Execution
*PBS*, *SLURM*

This example is less a demonstration of features available (e.g., there is no
use of job arrays or command line arguments) and, instead, shows a computational
job that provides a good template for many other embarrassingly parallel
computational tasks. Here, the goal is use the non-parametric bootstrap to
approximate the sampling distribution of correlation coefficients based on
samples of size 25. The correlation of interest is between average undergraduate
GPA and average LSAT scores among students at 82 different law schools.

The output generated from the R script is just the deciles from this
distribution (without acceleration or bias-correction).

To run under Torque:
```
cd ./examples/ex6/
qsub ex6.pbs
```

To run under SLURM:
```
cd ./examples/ex6/
sbatch ex6.slurm
```

##### Example 7: "Substantive" Example with Multiple Cores on a Single Node
*PBS*, *SLURM*

This example mirrors Example 6. However, it demonstrates use of a single task,
where that task uses multiple processes.

To run under Torque:
```
cd ./examples/ex7/
qsub ex7.pbs
```

To run under SLURM:
```
cd ./examples/ex7/
sbatch ex7.slurm
```

##### Example 8: single-node Python parallel execution
*PBS*

This PBS script uses the default setup (see Example 1), requests 5 processors on
a single node, and runs a Python script. The Python script executes a loop
sequentially and then does the equivalent in parallel. Eeach of `MC` iterations
takes `MC/DUR` seconds by construction. The `map`-based parallel evaluation
should be about `PROCS` times faster. This approach does not generalize to
multiple nodes.

```
cd ./examples/ex8/
qsub ex8.pbs
```

##### Example 9: single-node Python parallel execution through arrays
*PBS*

This PBS script uses the default setup (see Example 1), requests 5 processors on
a single node, and runs a Python script. The Python script executes a loop
sequentially and then does the equivalent in parallel. Eeach of `MC` iterations
takes `MC/DUR` seconds by construction. The `map`-based parallel evaluation
should be about `PROCS` times faster. This approach does not generalize to
multiple nodes.

```
cd ./examples/ex8/
qsub ex8.pbs
```

##### Example 10: single-node non-parallel R job with Rcpp
*PBS*, *SLURM*

##### Example 11: single-node Computational Thread illustration with Matlab
*PBS*


#### Index of Topics
- common scheduler  directives: Example 1
- sequential execution of scripts
  - in R: Examples 2, 10
  - in Matlab: Example 5
  - in Python: Example 8
- misc. shell commands in job scripts: Example 1
- job arrays: Example 4
- passing command line arguments
  - in  R: Example 4
- reading shell environmental variables:
  - in R: Examples 3, 6, 7
  - in Matlab: Example 5
  - in Python: Example 8
- dynamic parallelization (i.e., not hard coding processors): Examples 3, 5, 6, 8
- single-node, multiple-core parallelization
  - in R: Example 7
  - in Matlab: Example 5
  - in Python: Example 8
- multiple-node parallelization
  - in R
    - with openmpi: Examples 3, 6
    - with job arrays: Example 4
