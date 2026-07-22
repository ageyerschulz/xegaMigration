
args = commandArgs(trailingOnly=TRUE)

pid=as.integer(args[1])
npid=as.integer(args[2])

suppressPackageStartupMessages(library(xega))

#paths<-list("./test7A", "./test7B", "./test7C")
#configs<-list("TSPlin105orderAConfig.rds",
#              "TSPlin105orderBConfig.rds",
#              "TSPlin105orderCConfig.rds")

### Does not work! 
cat("Time order tests:", "TSPlin105orderAConfig.rds", "\n")

Config<-readRDS(file="TSPlin105orderAConfig.rds") 

demeResult<-xegaReRun(Config[[1+pid]], 
                      verbose=0,
                      CommunicationTopology="ring2",
                      pid=pid,
                      npid=npid,
                      migrateEvery=1,
                      maxDelay=60,
                      Send="rds",
                      Receive="rds",
                      collectResult="rds", 
                      collect=TRUE,
                      Configuration=FALSE,
                      path="./test7A") 

"TSPlin105orderCConfig.rds"
