
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: The migration algorithm.
#          Package: xega
#

#' Generate a local function list to test migration.
#'
#' @family Migration
#' 
#' @importFrom xegaSelectGene parm
#' @importFrom xegaSelectGene SelectGeneFactory 
#' @importFrom xegaPopulation lFxegaGaGene 
#' @importFrom xegaPopulation ApplyFactory 
#'
#' @export
NewLFxegaMigrate<-function()
{ lF<-xegaPopulation::lFxegaGaGene
  lF$Pipeline<-xegaSelectGene::parm("NoPipe")
  lF$lapply<-xegaPopulation::ApplyFactory(method="Sequential")
  lF$path<-xegaSelectGene::parm(tempdir())
######
  lF$Nmigrants<-xegaSelectGene::parm(1)
  lF$pid<-xegaSelectGene::parm(5)
  lF$npid<-xegaSelectGene::parm(10)
  lF$TopK<-xegaSelectGene::parm(1) # for selection method "TopK"
  lF$SelMigrant<-xegaSelectGene::SelectGeneFactory(method="TopK")
  lF$SelReplace<-xegaSelectGene::SelectGeneFactory(method="TopK")
  lF$CommunicationTopology<-xegaCommunicationTopologyFactory(method="ring")
  lF$Send<-xegaSendFactory(method="rds")
  lF$Receive<-xegaReceiveFactory(method="rds")
  lF$ProbeTerm<-xegaProbeTermFactory(method="rds")
  lF$BroadcastTerm<-xegaBroadcastTermFactory(method="rds")
######
  lF$LTP<-xegaSelectGene::parm(FALSE)
  lF$avgTime<-xegaSelectGene::parm(1.01)
  lF$slowestTime<-xegaSelectGene::parm(0.01)
  lF$slowestPid<-xegaSelectGene::parm(0)
  lF$Generations<-xegaSelectGene::parm(10)
  return(lF) }

#' Migrate genes.
#'
#' @description The migration algorithm performs the following steps:
#'    \enumerate{
#'    \item Select emigrants.
#'    \item Send emigrants to recipients defined by the communication topology.
#'    \item Receive immigrants.
#'    \item Replace some genes by immigrants.
#'    } 
#'     
#' @details The classic non-blocking migration strategy is:
#'    \enumerate{
#'    \item Select the best gene.          
#'    \item Send it to the neigbor (in a ring topology).
#'    \item Receive immigrants from the neighbor (in a ring topology).
#'    \item If there are immigrants, replace the worst genes by the immigrants.  
#'    }
#'  
#' @param population   A population. 
#' @param fit          A fitness vector.
#' @param lF           Local function configuration.
#'
#' @return m           A named list
#'         \enumerate{
#'         \item $pop       A population.
#'         \item $rucksack  Control information (named list) 
#'         \enumerate{
#'            \item $DTP   Boolean. Distributed termination predicate. 
#'            \item $generationLimit  Integer. How many generations?
#'         }
#'         }
#'
#' @family Migration
#'
#' @examples 
#' lF<-NewLFxegaMigrate()
#' p<-xegaPopulation::xegaInitPopulation(10, lF)
#' p1<-xegaPopulation::xegaEvalPopulation(p, lF)
#' population<-p1$pop
#' fit<-p1$fit
#' p2<-xegaMigrate(population, fit, lF)
#' p2fit<-unlist(lapply(p2$pop, function(x) { x$fit }))
#' cat("Mean before:", mean(fit), "after migration:", mean(p2fit), "\n")
#' lF$pid<-xegaSelectGene::parm(6) 
#' p3<-xegaMigrate(population, fit, lF)
#' p3fit<-unlist(lapply(p3$pop, function(x) { x$fit }))
#' cat("Mean before:", mean(p2fit), "after migration:", mean(p3fit), "\n")
#' 
#' @importFrom xegaSelectGene parm
#'@export
xegaMigrate<-function(population, fit, lF)
{ 
# cat("[", lF$pid(),"] Distributed Termination. LTP(",lF$LTP(),")\n")
# cat(" Adaptive Termination Limit.\n") 
# cat("Generations(", lF$Generations(), ")\n")
# cat("average Time(", lF$avgTime(), ")\n")
# cat("slowest Time(", lF$slowestTime(), ")\n")
# cat("slowest Pid(", lF$slowestPid(), ")\n")
LTP<-lF$LTP()
DTP<-lF$ProbeTerm(lF)
if (DTP)  
{ # cat("xegaMigrate DTP(:",DTP,")\n") 
   return(list(pop=population, 
               rucksack=list(DTP=DTP, 
                             generationLimit=lF$Generations(),
                             slowestTime=lF$slowestTime(),
                             slowestPid=lF$slowestPid())))
}
if (LTP)  
{  # cat("xegaMigrate Broadcasting. LTP(",LTP,"\n") 
   lF$BroadcastTerm(lF)
   return(list(pop=population, 
               rucksack=list(DTP=DTP, 
                             generationLimit=lF$Generations(),
                             slowestTime=lF$slowestTime(),
                             slowestPid=lF$slowestPid())))
}
pop<-population
midx<-lF$SelMigrant(fit, lF, size=lF$Nmigrants())
emigrants<-population[midx]
slowestTime<-max(lF$avgTime(), lF$slowestTime())
if (lF$slowestTime()<lF$avgTime())
   {slowestPid<-lF$pid()} else
   {slowestPid<-lF$slowestPid()}
# cat("xegaMigration: send slowestTime(", slowestTime, ")\n")
# cat("xegaMigration: send slowestPid(", slowestPid, ")\n")
msgSent<-list(list(genes=emigrants, 
                   slowestTime=slowestTime, 
                   slowestPid=slowestPid))
rc<-lF$Send(msgSent, lF)
msgReceived<-lF$Receive(lF)
# cat("xegaMigration: msgReceived\n")
# print(msgReceived)
if (length(msgReceived)>0)
    { #  cat("xegaMigration: Message Received\n")
      immigrants<-list()
      slowestTime<-vector()
      slowestPid<-vector()
      for (i in (1:length(msgReceived)))
      { immigrants<-c(immigrants, msgReceived[[i]]$genes)
        slowestTime<-c(slowestTime, msgReceived[[i]]$slowestTime)
        slowestPid<-c(slowestPid, msgReceived[[i]]$slowestPid)
        }
   if (length(slowestTime)>1) 
          {a<-slowestTime
           slowestTime<-max(a)
           slowestPid<-slowestPid[a %in% max(a)][1]
      #      cat("xegaMigration: received slowestTime:", slowestTime, "\n")
      #      cat("xegaMigration: received slowestPid:", slowestPid, "\n")
          }
   lF$slowestTime<-xegaSelectGene::parm(slowestTime)
   lF$slowestPid<-xegaSelectGene::parm(slowestPid)
   lF$TopK<-xegaSelectGene::parm(length(immigrants))
   ridx<-lF$SelReplace(((-1)*fit), lF, size=length(immigrants))
   pop[ridx]<-immigrants
   # cat("xegaMigration: new Population\n")
   # cat("    length(pop)", length(pop), "\n")
   #    fit<-lapply(pop, function(x) {x$fit} )
   # cat("    length(fit)", length(fit), "\n")
   # cat("xegaMigrate: Emigrants(", length(emigrants), 
   #                 ") Immigrants(", length(immigrants), ")\n")
   }
   if (lF$pid()==lF$slowestPid()) 
      {newGenerationLimit<-lF$Generations()}
      else 
      {newGenerationLimit<-lF$adaptGenerationLimit(lF)}
   slowestTime<-lF$slowestTime()
   # cat("xegaMigration: newGenerationLimit:", newGenerationLimit, "\n")
   return(list(pop=pop, 
               rucksack=list(DTP=DTP, 
               generationLimit=newGenerationLimit,
               slowestTime=slowestTime, 
               slowestPid=slowestPid)))
}

