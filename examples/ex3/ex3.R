### #############
### Parse CL Args
### #############

args <- commandArgs(trailingOnly = TRUE)
nIters <- as.integer(args[1])
paste("nIters:", nIters)
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
cl <- startMPIcluster()
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

system.time({
    out <- foreach(i = (1:nIters),
                   .combine = rbind
                   ) %dopar% {
                       Sys.sleep(1)
                       return(data.frame(
                           host = mpi.get.processor.name(),
                           pid = Sys.getpid(),
                           size = mpi.comm.size(0),
                           rank = mpi.comm.rank(0)
                           )
                              )
                   }
})


out

Sys.getpid()
mpi.comm.rank(0)
mpi.comm.size(0)
mpi.get.processor.name()

                                        #
                                        #


closeCluster(cl)
mpi.quit()
