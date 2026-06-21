
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105HomConfig.rds" ) 

demeResult<-xegaReRun(Config, 
                      verbose=0,
                      pid=pid,
                      npid=npid,
                      migrateEvery=1,
                      maxDelay=60,
                      Send="rds",
                      Receive="rds",
                      collectResult="rds", 
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test5") 

