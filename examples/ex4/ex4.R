### #################
### Read Env Variable
### #################
jid <- paste(Sys.getenv("PBS_JOBID"),
             Sys.getenv("SLURM_JOB_ID"),
             sep = ""
             )

aid <- paste(Sys.getenv("PBS_ARRAYID"),
             Sys.getenv("SLURM_ARRAY_TASK_ID"),
             sep = ""
             )
                                        #
                                        #

### ##################
### SLURM Env Variable
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






