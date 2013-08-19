local({r <- getOption("repos");
       r["CRAN"] <- "http://cran.r-project.org";
       options(repos=r)
   }
      )

install.packages(c("doMPI",
                   "foreach",
                   "snow",
                   "doSNOW",
                   "doRNG",
                   "doMC",
                   "Rcpp",
                   "RcppArmadillo"
                   )
                 )

