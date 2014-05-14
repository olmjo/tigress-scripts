[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/olmjo/tigress-scripts/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

# TIGRESS-scripts
Setup and Example scripts (mostly) for R-based HPC at Princeton University

Contact Jonathan Olmsted (jolmsted@princeton.edu) with questions or issues.

## What?

This project comprises a set of multiple example scripts and a setup script to
help prepare your HPC environment for R-based HPC. These scripts work *out of
the box* on both Tukey and Della. There are some additional examples of using
Python and Matlab, but these are not the focus.  More information on these
scripts is below.

## Where?

These scripts have been tested on:
- Tukey
- Della 3
- Della 4

If you are using one of these systems and something isn't working, please email
for support.

## How?

### Getting a Copy

You can create a full copy of this git repository by cloning it. To do this, run
the following at the shell prompt:

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

You will be prompted by several questions like

```
Do you need to DL Rmpi? [y/n]
Do you need to add openmpi libs to the linker path? [y/n]
Do you need to install Rmpi? [y/n]
Do you need to misc. HPC packages? [y/n]n
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

If you see information like the following mixed in, that's okay.

```
librdmacm: Fatal: no RDMA devices found
--------------------------------------------------------------------------
[[20318,1],0]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: tukey

Another transport will be used instead, although this may result in
lower performance.
--------------------------------------------------------------------------
librdmacm: Fatal: no RDMA devices found
librdmacm: Fatal: no RDMA devices found
```

#### Examples

There are a series of example scripts in this project. Each example can be used
to submit a perfectly valid job on the above listed systems. They are located in
the `./examples/` subdirectory. The shell scripts with a `.pbs` suffix are PBS
scripts for the TORQUE resource manager. The shell scripts with a `.slurm`
suffix are SLURM scripts.

In each example description, below, versions for PBS and SLURM are indicated.

Currently, only Della 4 uses SLURM. PBS scripts will work elsewhere.


##### Example 0: Bare Bones
*PBS*, *SLURM*

This is a bare bones example. It requests 1 node with 1 processor on the
node. It allows the scheduler to kill the job after 10 minutes. The script
simply generates 1,000 random numbers using the Rscript interface to R.

To run under PBS:
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

This PBS script represents a reasonable starting point for simple jobs. It is
more explicit about how the job should be managed than Example 0. It still
requests 1 node with 1 processor. It requests only 10 minutes of time. It uses a
custom name in the queue and has both the error log and the output log merged
into one file which begins with log.* and has a suffix determined by the job
ID. It requests emails when it begins, ends, and aborts (the email address can
be specified manually, but works by default on TIGRESS systems).

Every line beginning with # is just a PBS directive. The remainder comprises an
actual shell script. The script is verbose about where it is, when it starts,
and what resources were given to it by the scheduler.

The script ultimately generates 1,000 random numbers using the Rscript interface
to R.

To run under PBS:
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

This PBS script includes all the reasonable defaults from Example 1. The only
change is that it uses Rscript to run an external R script, which is how the job
would usually be programmed.

The computational task in R is a copy of the example usage of `ideal()` from the R
package **pscl**.

To run under PBS:
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
two nodes with 4 processors each. The R script uses an MPI backend to
parallelize an R foreach loop across multiple nodes. A total of 2 * 2 = 4
processors will be used for this job. When running the R script, we pass the
value "10" as an unnamed argument. The R script then uses this value to
determine how many iterations of the foreach loop to run.

Each iteration of the foreach loop simply pauses for 1 second and then returns
some contextual information in a dataframe. This information includes where that
MPI process is running and what it's "id" is.

To run under PBS:
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

To run under PBS:
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

This PBS script uses the default setup (see ex1), requests 5 processors on a
single node, and runs a Matlab script. The Matlab script executes a loop
sequentially and then in parallel where each of `MC` iterations takes `MC/DUR`
seconds by construction. The parallel loop (i.e., the one using the `parfor`
construct) should be about `PROCS` times faster. This approach does not
generalize to multiple nodes.

```
cd ./examples/ex5/
qsub ex5.pbs
```

##### Example 6: "Substantive" Example with Multiple Cores on Multiple Nodes
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

To run under PBS:
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
*PBS*

This example mirrors Example 6. However, it demonstrates use of multiple R
processes on a single node.

```
cd ./examples/ex7/
qsub ex7.pbs
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
*PBS*

##### Example 11: single-node Computational Thread illustration with Matlab
*PBS*


#### Index of Topics
- Common Torque directives: [1](https://github.com/olmjo/tigress-scripts/tree/master#example-1-a-reasonable-default)
- Batch execution of scripts via Torque
  - in R:
  [2](https://github.com/olmjo/tigress-scripts/tree/master#example-2-example-1--an-external-r-script)
  - in Matlab:
  [5](https://github.com/olmjo/tigress-scripts/tree/master#example-5-single-node-matlab-parallel-execution)
  - in Python:
  [8](https://github.com/olmjo/tigress-scripts#example-8-single-node-python-parallel-execution)
- Misc. shell commands in PBS scripts:
[1](https://github.com/olmjo/tigress-scripts/tree/master#example-1-a-reasonable-default)
- Job arrays:
[4](https://github.com/olmjo/tigress-scripts/tree/master#example-4-example-2--job-arrays--passing-arguments-to-r)
- Passing command line arguments
  - in  R: 
  [4](https://github.com/olmjo/tigress-scripts/tree/master#example-4-example-2--job-arrays--passing-arguments-to-r)
- Reading shell environmental variables:
  - in R:
  [3](https://github.com/olmjo/tigress-scripts/tree/master#example-3-example-2--parallel-execution--passing-arguments-to-r),
  [6](https://github.com/olmjo/tigress-scripts/tree/master#example-6-substantive-example-with-multiple-cores-on-multiple-nodes), 
  [7](https://github.com/olmjo/tigress-scripts/tree/master#example-7-substantive-example-with-multiple-cores-on-a-single-node)
  - in Matlab:
  [5](https://github.com/olmjo/tigress-scripts/tree/master#example-5-single-node-matlab-parallel-execution)
  - in Python:
  [8](https://github.com/olmjo/tigress-scripts#example-8-single-node-python-parallel-execution)
- Dynamic parallelization:
  [3](https://github.com/olmjo/tigress-scripts/tree/master#example-3-example-2--parallel-execution--passing-arguments-to-r), 
  [5](https://github.com/olmjo/tigress-scripts/tree/master#example-5-single-node-matlab-parallel-execution), 
  [6](https://github.com/olmjo/tigress-scripts/tree/master#example-6-substantive-example-with-multiple-cores-on-a-single-node),
  [8](https://github.com/olmjo/tigress-scripts#example-8-single-node-python-parallel-execution)
- Single-node, multiple-core parallelization
  - in R: 
  [7](https://github.com/olmjo/tigress-scripts/tree/master#example-7-substantive-example-with-multiple-cores-on-a-single-node)
  - in Matlab:
  [5](https://github.com/olmjo/tigress-scripts/tree/master#example-5-single-node-matlab-parallel-execution)
  - in Python:
  [8](https://github.com/olmjo/tigress-scripts#example-8-single-node-python-parallel-execution)
- Multiple-node parallelization
  - in R
    - with openmpi:
    [3](https://github.com/olmjo/tigress-scripts/tree/master#example-3-example-2--parallel-execution--passing-arguments-to-r), 
    [6](https://github.com/olmjo/tigress-scripts/tree/master#example-6-substantive-example-with-multiple-cores-on-a-single-node)
    - with job arrays:
    [4](https://github.com/olmjo/tigress-scripts/tree/master#example-4-example-2--job-arrays--passing-arguments-to-r)
  
