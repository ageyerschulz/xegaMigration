
source("rmpiProfile.R")

suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105HomConfig.rds" ) 

demeResult<-xegaReRun(Config, 
                      verbose=0,
                      maxDelay=0,
                      RmpiFNS=RmpiFNS,
                      pid=mpi.comm.rank(),
                      npid=mpi.comm.size(),
                      Send="mpi",
                      Receive="mpi",
                      collectResult="mpi",
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test4") 

