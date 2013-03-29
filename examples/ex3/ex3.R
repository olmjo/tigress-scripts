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
library(snow)
library(doSNOW)
                                        #
                                        #

### ################
### Init MPI Backend
### ################
cl <- makeCluster(nMPISIZE, "MPI")
registerDoSNOW(cl)
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

stopCluster(cl)
mpi.quit()
