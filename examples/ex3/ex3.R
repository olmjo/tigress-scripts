### #############
### Parse CL Args
### #############
args <- commandArgs(trailingOnly = TRUE)
nIters <- as.integer(args[1])
paste("nIters:", nIters)
                                        #
                                        #

### #################
### Read Env Variable
### #################
nMPISIZE <- Sys.getenv("TOTALPROCS")
paste("nMPISZE:", nMPISIZE)
                                        #
                                        #

### ############
### Dependencies
### ############
library(foreach)
library(doMPI)
                                        #
                                        #

### ################
### Init MPI Backend
### ################
cl <- startMPIcluster(nMPISIZE)
registerDoMPI(cl)
                                        #
                                        #

### ##############
### Master Process
### ##############
system("hostname")
Sys.getpid()
                                        #
                                        #

### ########################
### Main Loop over MPI Procs
### ########################
foreach(i = (1:nIters),
        .combine = rbind
        ) %dopar% {
          return(data.frame(
            host = mpi.get.processor.name(),
            pid = Sys.getpid(),
            size = mpi.comm.size(),
            rank = mpi.comm.rank()
            )
                 )
        }
                                        #
                                        #

closeCluster(cl)



mpi.quit()
