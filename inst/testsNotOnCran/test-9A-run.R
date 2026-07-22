
source("rmpiProfile.R")

suppressPackageStartupMessages(library(xegaMigration))
suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105HomConfig.rds") 

Rmpi::mpi.barrier()

demeResult<-xegaReRun(Config, 
                      generations=10,
                      verbose=0,
                      RmpiFNS=RmpiFNS,
                      pid=mpi.comm.rank(),
                      npid=mpi.comm.size(),
                      executionModel="Sequential",
                      CommunicationTopology="gPetersen",
                      GPn=4,
                      GPk=2,
                      mutrate= 0.0,
                      crossrate=0.0,
                      migrateEvery=1,
                      maxDelay=60,
                      Send="mpi",
                      Receive="mpi",
                      collectResult="mpi", 
                      collect=TRUE,
                      Configuration=FALSE,
                      migrationDebug=TRUE,
                      path="./test9A") 

