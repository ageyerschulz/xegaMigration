
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: The migration algorithm.
#          Package: xegaMigration
#

#' Generate a local function list to test migration.
#'
#' @description 
#' To allow local testing of functions of \code{xegaMigration}, 
#' the function factory \code{NewLFxegaMigrate} returns a local function list 
#' with some of the local functions used in configuring \code{xega::xegaRun()}.
#'
#' @return An object of class list of length 51. All list elements are local functions
#'         or lists of local functions
#'         for configuring \code{xega::xegaRun}.  
#'         \enumerate{ 
#'         \item For some elements of the local function list for configuring migration:
#'       \enumerate{
#'         \item \code{$path()}. Returns path of directories for results and rds-file communication.                
#'         \item \code{$pid()}. Returns process id (pid) of island.
#'         \item \code{$npid()}. Returns number of islands.                  
#'         \item \code{$Nmigrants()}. Returns number of emigrants.    
#'         \item \code{$nrecv()}. Number of receiving island processes. For random communication topology.
#'         \item \code{$GPn()}. Number of island process in inner and outer rings of
#'                              a communication topology in the form of a generalized 
#'                              Peterson graph.
#'         \item \code{$GPk()}  Spoke shift between inner and outer ring nodes in a generalized   
#'                              Peterson graph.
#'         \item \code{$torusX()} Number of processes on X-coordinate of a 2-D or 3-D torus of processes.
#'         \item \code{$torusY()} Number of processes on Y-coordinate of a 2-D or 3-D torus of processes.
#'         \item \code{$torusZ()} Number of processes on Z-coordinate of a 3-D torus of processes.
#'         \item \code{$TopK()}. Returns number of genes.   
#'         \item \code{$SelMigrant()}. Returns selection method for emigrants.    
#'         \item \code{$SelReplace()}. Returns Replacement method for genes by immigrants.       
#'         \item \code{$CommunicationTopology()}. Returns function for 
#'                                 computing all neigboring pids as defined by communication graph. 
#'         \item \code{$Send()}. Returns send method.  
#'         \item \code{$Receive()}. Returns receive method.
#'         \item \code{$ProbeTerm()}. Returns probing function for termination message.    
#'         \item \code{$BroadcastTerm()}. Returns broadcast function for sending termination message 
#'                                to all island processes.      
#'         \item \code{$LTP()}. Local Termination Predicate.                 
#'         \item \code{$avgTime()}. Average execution time of island. 
#'         \item \code{$slowestTime()}. Slowest execution time known at island.  
#'         \item \code{$slowestPid()}.  pid of slowest process in ensemble of island processes.        
#'         \item \code{$migrationStrategy()}. Returns a boolean function which triggers termination protocol.     
#'         } 
#'         \item For the elements of the local function list of \code{xega::xegaRun()},
#'         \itemize{ 
#'         \item \code{$penv()},
#'          \code{$replay()},             
#'          \code{$verbose()},
#'          \code{$CutoffFit()},   
#'          \code{$CBestFitness()},        
#'          \code{$CWorstFitness()},
#'          \code{$MutationRate1()},        
#'          \code{$MutationRate2()},        
#'          \code{$BitMutationRate1()},    
#'          \code{$BitMutationRate2()},    
#'          \code{$MutationRate()},     
#'          \code{$MutateGene()},        
#'          \code{$CrossRate()},  
#'          \code{$UCrossSwap()},           
#'          \code{$CrossGene()},        
#'          \code{$Max()},
#'          \code{$Offset()},  
#'          \code{$Eps()},                  
#'          \code{$Elitist()}, 
#'          \code{$TournamentSize()},        
#'          \code{$GeneMap()},
#'          \code{$SelectGene()},  
#'          \code{$SelectMate()},    
#'          \code{$Accept()},               
#'          \code{$ReportEvalErrors()},      
#'          \code{$Pipeline()},      
#'          \code{$InitGene()},             
#'          \code{$DecodeGene()}, 
#'          \code{$EvalGene()},  
#'          \code{$SelectionContinuation()},
#'          \code{$Verbose()}, and     
#'          \code{$lapply()}. 
#'         }
#'         }
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
  lF$nrecv<-xegaSelectGene::parm(1)
  lF$pid<-xegaSelectGene::parm(5)
  lF$npid<-xegaSelectGene::parm(10)
  lF$TopK<-xegaSelectGene::parm(1) # for selection method "TopK"
  lF$SelMigrant<-xegaSelectGene::SelectGeneFactory(method="TopK")
  lF$SelReplace<-xegaSelectGene::SelectGeneFactory(method="TopK")
  lF$CommunicationTopology<-xegaCommunicationTopologyFactory(method="ring")
  lF$GPn<-xegaSelectGene::parm(5)
  lF$GPk<-xegaSelectGene::parm(2)
  lF$torusX<-xegaSelectGene::parm(3)
  lF$torusY<-xegaSelectGene::parm(3)
  lF$torusZ<-xegaSelectGene::parm(3)
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
  lF$migrationStrategy<-xegaSelectGene::parm(TRUE)
  return(lF) }

#' Migrate genes.
#'
#' @description The migration algorithm performs the following steps
#'              (neglecting termination):
#'    \enumerate{
#'    \item Select emigrants.
#'    \item Send emigrants to recipients defined by the communication topology.
#'    \item Receive immigrants.
#'    \item Replace some genes in the population by immigrants.
#'    } 
#'     
#' @details The classic non-blocking migration strategy with termination is
#'          (simplified) 
#'    \enumerate{
#'    \item Probe for termination signals of other islands. 
#'          If such a termination signal exists, return a termination signal.
#'    \item If a local termination signal exists, broadcast termination 
#'          to other islands and return a termination signal.
#'    \item Select the best gene.          
#'    \item Send it to the neigbor (in a ring topology).
#'    \item Receive immigrants from the neighbor (in a ring topology).
#'    \item If there are immigrants, replace the worst genes by the immigrants. 
#'    \item Update generation limit and slowest pid.
#'    \item Return population (with immigrants), generation limit, 
#'          slowest time, and slowest pid.
#'    }
#'  
#' @param population   A population. 
#' @param fit          A fitness vector.
#' @param lF           Local function configuration.
#'
#' @return A named list with the following elements:
#'         \enumerate{
#'         \item $pop       A population.
#'         \item $rucksack  Control information (named list) 
#'         \enumerate{
#'            \item $DTP   Boolean. Distributed termination predicate. 
#'            \item $generationLimit  Integer. How many generations?
#'            \item $slowestTime      Integer. The execution time of the 
#'                                    slowest process.
#'            \item $slowestpid       Integer. The pid of the slowest process.
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
#
# 1. Probe for termination signals of other islands 
#    and return signal termination.
if (lF$migrationStrategy()) 
   {DTP<-lF$ProbeTerm(lF)} else {DTP<-lF$DTP()}
                         
if (DTP)  
{ # cat("xegaMigrate DTP(:",DTP,")\n") 
   return(list(pop=population, 
               rucksack=list(DTP=DTP, 
                             generationLimit=lF$Generations(),
                             slowestTime=lF$slowestTime(),
                             slowestPid=lF$slowestPid())))
}
# 2. Signal termination to other islands.
LTP<-lF$LTP()
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
# 3. Select emigrants and send them to other islands.
msgSent<-list()
slowestPid<-lF$slowestPid()
if (lF$improved())
{
midx<-lF$SelMigrant(fit, lF, size=lF$Nmigrants())
emigrants<-population[midx]
### Problem here for forecast!
### slowestTime must also reduce on the slowest processor!
if (lF$pid()==lF$slowestPid())
   {slowestTime<-min(lF$avgTime(), lF$slowestTime())}   
else
   {slowestTime<-max(lF$avgTime(), lF$slowestTime())}
if (lF$slowestTime()<lF$avgTime())
   {slowestPid<-lF$pid()} else
   {slowestPid<-lF$slowestPid()}
# cat("xegaMigration: send slowestTime(", slowestTime, ")\n")
# cat("xegaMigration: send slowestPid(", slowestPid, ")\n")
msgSent<-list(list(genes=emigrants, 
                   fromPid=lF$pid(),
                   timems=as.numeric(Sys.time()),
                   slowestTime=slowestTime, 
                   slowestPid=slowestPid))
rc<-lF$Send(msgSent, lF)
}
# 4. Receive immigrants from other islands and replace genes.
msgReceived<-list()
msgReceived$data<-lF$Receive(lF)
# msgReceived$timems<-as.numeric(Sys.time())
# cat("xegaMigration: msgReceived\n")
# print(msgReceived)
if (length(msgReceived$data)>0)
    { #  cat("xegaMigration: Message Received\n")
      immigrants<-list()
      fromPid<-list()
      slowestTime<-vector()
      slowestPid<-vector()
      for (i in (1:length(msgReceived$data)))
      { immigrants<-c(immigrants, msgReceived$data[[i]]$genes)
        fromPid<-c(fromPid, msgReceived$data[[i]]$fromPid)
        slowestTime<-c(slowestTime, msgReceived$data[[i]]$slowestTime)
        slowestPid<-c(slowestPid, msgReceived$data[[i]]$slowestPid)
        }
     # cat("xegaMigrate: received from pid: \n")
     # print(fromPid)
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
# 5. Update generation limit and slowest pid.
   if (lF$pid()==lF$slowestPid()) 
      {newGenerationLimit<-lF$Generations()}
      else 
      {newGenerationLimit<-lF$adaptGenerationLimit(lF)}
   slowestTime<-lF$slowestTime()
# cat("xegaMigration: newGenerationLimit:", newGenerationLimit, "\n")
# 6. Report/Debug
if (lF$migrationDebug()==TRUE)
   { xegaShowMigrationReport(xegaMigrationReport(msgSent, msgReceived, lF))}
# 7. Return.
   return(list(pop=pop, 
               rucksack=list(DTP=DTP, 
               generationLimit=newGenerationLimit,
               slowestTime=slowestTime, 
               slowestPid=slowestPid)))
}
