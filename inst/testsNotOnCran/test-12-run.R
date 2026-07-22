
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xega))

### Does not work! 
Config<-readRDS(file="TSPlin105HomConfig.rds") 

demeResult<-xegaReRun(Config, 
                      popsize=1000,
                      generations=100,
                      verbose=2,
                      pid=pid,
                      npid=npid,
                      nrecv=1,
                      torusX=5,
                      torusY=5,
                      CommunicationTopology="torus2D",
                      migrateEvery=1,
                      maxDelay=60,
                      Send="rds",
                      Receive="rdsb",
                      collectResult="rds", 
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test12") 

