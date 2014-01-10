### ##################################################################
### (Naive) Non-Parametric Bootstrap of the Sampling Distribution of a
### Correlation Coefficient for a Sample of Size 10
### ##################################################################

## Data: law82 dataset from
##       <http://cran.r-project.org/web/packages/bootstrap/index.html>

## Goal: Characterize the sampling distribution of the correlation coefficent on
##       samples of size 25 between average LSAT score and average UG GPA for
##       students at the 82 different law schools (universe).

## Parallelization: Single-node parallelization and a foreach() loop




## #################
## Read Env Variable
## #################
nCores <- Sys.getenv("TOTALPROCS")
                                        #
                                        # Auto detects resources granted from
                                        # the job manager

## ############
## Dependencies
## ############
library(foreach)
library(doMC)
library(doRNG)
                                        #
                                        # Packges needed for the parallelization

library(bootstrap)
                                        #
                                        # Packages need for the "substantive"
                                        # example

## ################
## Init MPI Backend
## ################
registerDoMC(nCores)

                                        #
                                        #

## ##############################
## Naive Non-Parametric Bootstrap
## ##############################
nBS <- 10000
sizeBS <- 25
                                        #
                                        # Number of BS iterations and BS sample
                                        # size

data(law82)
registerDoRNG(1)
                                        #
                                        # Reproducible Parallel RNG
output <- foreach(i = (1:nBS),
                  .combine = rbind,
                  .export = c("law82", "sizeBS")
                  ) %dopar% {
                      ##
                      indsBS <- sample(x = 1:nrow(law82),
                                       size = sizeBS,
                                       replace = FALSE
                                       )
                      subBS <- law82[indsBS, ]
                      corBS <- cor(subBS$LSAT, subBS$GPA)
                      ##
                      return(corBS)
                  }
                                        #
                                        #

quantile(output, probs = seq(0, 1, .1))
