
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xega))

Config<-readRDS(file="TSPlin105orderAConfig.rds" ) 

demeResult<-xegaReRun(Config[[1+pid]], 
                      verbose=0,
                      pid=pid,
                      npid=npid,
                      migrateEvery=1,
                      maxDelay=0,
                      Send="rds",
                      Receive="rds",
                      collectResult="rds", 
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test6") 

