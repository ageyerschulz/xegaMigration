
source("rmpiProfile.R")

suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105orderBConfig.rds" ) 

pid<-mpi.comm.rank()

cat("pid:", pid,"Time order tests (mpi):", "TSPlin105orderBConfig.rds", "\n")

demeResult<-xegaReRun(Config[[1+pid]], 
                      verbose=0,
                      maxDelay=60,
                      RmpiFNS=RmpiFNS,
                      pid=pid,
                      npid=mpi.comm.size(),
                      Send="mpi",
                      Receive="mpi",
                      collectResult="mpi",
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test8B")
