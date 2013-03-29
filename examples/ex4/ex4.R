### #################
### Read Env Variable
### #################
jid <- Sys.getenv("PBS_JOBID")
aid <- Sys.getenv("PBS_ARRAYID")
                                        #
                                        #

### ##################
### Print Env Variable
### ##################
cat(paste("This is job: ", jid, ".\n", sep = ""))
cat(paste("The sub-id is: ", aid, ".\n\n", sep = ""))
                                        #
                                        #

### #########
### Use Index
### #########
letters[as.integer(aid)]
                                        #
                                        #






