
#' The migration support for island models for the \code{xega}
#' package.
#'
#' @section An Adaptive Completely Decentral Migration Strategy:
#'
#' The goal of the migration strategy of \code{xega} is to exploit 
#' the computing power of a set of loosely coupled processors as 
#' well as possible: 
#' \itemize{
#' \item The number of messages exchanged between 
#'       islands should be small (and configurable).  
#' \item The communication topology should be configurable.
#' \item All processes should terminate almost at the same time,
#'       so that no processor is idle for an extended period of time.
#' \item The algorithm should terminate, when either
#'       \itemize{
#'       \item one process fulfills a local termination predicate
#'             (reaches the optimal solution),
#'       \item the slowest processor reaches its generation limit.
#'             It is not known which of the processes is the slowest.
#'       }
#' }
#'       
#' @section The Migration Algorithm: 
#'
#' \enumerate{
#' \item Probe (non-blocking) for a distributed termination predicate DTP.
#'       from other islands (asynchronous termination protocol).
#'       If a distributed termination predicate is set, return DTP to main.
#' \item If local termination predicate LTP, broadcast termination signal
#'       to other islands. (asynchronous termination protocol).
#' \item Select emigrants from population and send emigrants 
#'       to other islands (asynchronous message exchange protocol).
#' \item Receive immigrants and replace genes in population 
#'       by immigrants (asynchronous message exchange protocol or
#'       barrier synchronization followed by asynchronous message exchange
#'       protocol).
#' \item Update generation limit and identify slowest pid.
#' }
#'
#' @section The Asynchronous Message Exchange Protocol:
#' 
#' Each island process performs the essentially the following 
#' two communication steps:
#' \enumerate{
#'   \item It \strong{sends} a list with genes, the slowest time, and the 
#'         pid of the slowest process to a list of receiving processes.
#'   \item It \strong{receives} none, one, or several list(s) 
#'         with genes, the slowest time, and 
#'         the pid of the slowest process.      
#'         }
#'
#'  \tabular{ccc}{
#'         \tab \strong{Send} \tab \strong{Receive}   \cr
#'  rds    \tab rdsSend()     \tab rdsReceiveGenes() \cr 
#'  mpi    \tab mpiSend() \tab mpiReceiveGenes() \cr 
#'  }
#'
#' @section Synchronization of Island Processes:
#'
#' Synchronization of island processes is achieved by implementing 
#' a blocking message receive function which invokes a barrier function 
#' which blocks until all island processes reach the barrier
#' before the asynchronous message receive function is called.
#'
#'  \tabular{ccc}{
#'      \tab \strong{Receive}          \tab \strong{Barrier Used} \cr
#'  rds \tab rdsReceiveGenesBlocking() \tab rdsBarrier()          \cr 
#'  mpi \tab mpiReceiveGenesBlocking() \tab Rmpi::mpiBarrier()    \cr 
#'  }
#'
#' @section The (Asynchronous) Termination Protocol:
#'
#' The \strong{terminator} 
#' (an island process who detects a local termination condition
#' either by reaching an optimization goal or by resource exhaustion)
#' broadcasts a termination message to the \strong{terminated} processes  
#' (all other island processes 
#' in the process ensemble) and terminates. All other island 
#' processes receive the termination message and terminate.
#'
#' \itemize{ 
#' \item \code{rds} communication. All island processes have access to 
#'       a shared file system. The \strong{terminator} writes a termination 
#'       file with the file name TermFrom<spid>ToAllRND<pad>.rds and 
#'       terminates. 
#'       Each \strong{terminated} process tests for the existence of this 
#'       file and if the file exists, it terminates.   
#'       The termination file remains in the shared directory and is 
#'       not deleted.
#' \item \code{mpi} communication.
#'       All island processes are members of the mpi communication area 1 and
#'       share a mpi message bus. The \strong{terminator} sends a 
#'       termination message with tag 7 to the \strong{terminated} 
#'       processes. 
#'       Each \strong{terminated} process tests for the existence of 
#'       a termination message with tag 7, and if such messages exist,
#'       it consumes them and terminates.
#'       The termination message which the \strong{terminator} has sent 
#'       to itself is not consumed and remains on the mpi message bus.
#' }
#'
#'  \tabular{ccc}{
#'         \tab \strong{Terminator} \tab \strong{terminated} \cr
#'  rds    \tab rdsBroadcastTerm()  \tab rdsProbeTerm()     \cr 
#'  mpi    \tab mpiBroadcastTerm()  \tab mpiProbeTerm()     \cr 
#'  }
#' 
#' @section Collection of Results:
#'
#' By convention, the process with pid \code{0} is considered as master process
#' which receives the results.
#' All other processes send their processes to pid \code{0}. 
#' 
#'  \tabular{ccc}{ 
#'         \tab \strong{Function} \tab \strong{uses:}   \cr
#'  rds    \tab rdsCollect()  \tab  readRDS() with error handling     \cr 
#'  mpi    \tab mpiCollect()   \tab If \code{pid==0}: mpiReceiveResult() \cr
#'         \tab                \tab If \code{not(pid==0)}: mpiSendResult() \cr 
#'  }
#'
#'
#' @section mpi and rds Communication Primitives:
#'
#' mpi and rds use communication primitives with the same semantics.
#' However, at the moment all collective mpi primitives (except 
#' \code{Rmpi::mpi.barrier()}) are avoided.
#' \tabular{ccc}{
#' send gene(s) from x to y (gene) \tab mpiSendGenes()  \tab rdsSendGenes() \cr
#'           uses          \tab Rmpi::mpi.send.Robj() \tab          \cr
#' receive gene(s) from any pid \tab mpiReceiveGenes \tab rdsReceiveGenes() \cr
#'           uses        \tab Rmpi::mpi.iprobe()  \tab      \cr
#'                       \tab Rmpi::mpi.any.source() \tab   \cr
#'                       \tab Rmpi::mpi.recv.Robj() \tab   \cr 
#' Loose synchronization \tab Rmpi::mpi.barrier() \tab rdsBarrier()   \cr 
#' }
#'
#' @section rds Communication Primitives:
#'
#' ddd
#'
"_PACKAGE"

