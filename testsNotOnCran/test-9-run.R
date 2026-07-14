
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xegaMigration))
suppressPackageStartupMessages(library(xega))

### Does not work! 
Config<-readRDS(file="TSPlin105HomConfig.rds") 

### rdsBarrier
barrierLF<-list()
barrierLF$pid<-function() {pid}
barrierLF$npid<-function() {npid}
barrierLF$path<-function() {"./test9"}

rdsBarrier(barrierLF)

demeResult<-xegaReRun(Config, 
                      generations=10,
                      verbose=0,
                      pid=pid,
                      npid=npid,
                      CommunicationTopology="gPetersen",
                      mutrate= 0.0,
                      crossrate=0.0,
                      migrateEvery=1,
                      maxDelay=60,
                      Send="rds",
                      Receive="rds",
                      collectResult="rds", 
                      collect=TRUE,
                      Configuration=FALSE,
                      migrationDebug=TRUE,
                      path="./test9") 

