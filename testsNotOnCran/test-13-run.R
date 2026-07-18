
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105HomConfig.rds") 

demeResult<-xegaReRun(Config, 
                      popsize=1000,
                      generations=100,
                      crossrate=0.25,
                      mutrate=0.6,
                      max2opt=100,
                      verbose=2,
                      migrate="OnImprovement",
                      pid=pid,
                      npid=npid,
                      nrecv=1,
                      torusX=4,
                      torusY=4,
                      torusZ=4,
                      CommunicationTopology="torus3D",
                      migrateEvery=1,
                      maxDelay=60,
                      Send="rds",
                      Receive="rdsb",
                      collectResult="rds", 
                      collect=TRUE,
                      migrationDebug=TRUE,
                      Configuration=FALSE,
                      path="./test13") 

