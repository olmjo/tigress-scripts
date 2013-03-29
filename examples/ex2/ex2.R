## Example R code taken from the 'pscl' package documentation for ideal()
## directly.

library(pscl)

data(s109)

n <- dim(s109$legis.data)[1]
x0 <- rep(0,n)
x0[s109$legis.data$party=="D"] <- -1
x0[s109$legis.data$party=="R"] <- 1

id1 <- ideal(s109,
             d=1,
             startvals=list(x=x0),
             normalize=TRUE,
             store.item=TRUE,
             maxiter=1000,
             burnin=0,
             thin=10,
             verbose=FALSE
             )

summary(id1)
