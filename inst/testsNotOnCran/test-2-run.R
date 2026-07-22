
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
                      Send="rds",
                      Receive="rds",
                      Configuration=FALSE,
                      path="./test2") 

