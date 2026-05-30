

#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: Broadcasting termination messages (non-blocking) 
#          Package: xegaMigration
#

#' Broadcast termination message (rds).
#'
#' @description Uses saveRDS for writing termination message to file.
#' The file name is of the form TermFrom<spid>ToAllRND<pad>.rds.
#'
#' @details The termination message is "received" by the function 
#'          \code{rdsProbeTerm()} by testing for the existence 
#'          of a file with the name TermFrom<spid>ToAllRND<pad>.rds
#'          in a file system shared by all island processes.
#'
#' @param lF      Local function configuration.
#'
#' @return 0 (invisible). 
#' 
#' @family rds communication 
#' 
#' @examples 
#' lF<-list()
#' lF$pid<-function() {4}
#' path<-tempdir()
#' lF$path<- function() {path}
#' rdsBroadcastTerm(lF)
#' DPT<-rdsProbeTerm(lF)
#' cat("DPT", DPT, "\n")
#'@export
rdsBroadcastTerm<-function(lF)
{fn<-rdsTermFileName(lF$pid(), path=lF$path())
 msg<-"Terminate!"
 saveRDS(object=msg, file=fn)
 invisible(0)}

#' Broadcast termination message (mpi).
#'
#' @description Sends termination messages (\code{tag=7})
#'              to all island processes.
#'
#' @details Expects \code{lF$RmpiFNS} elements bound to \code{Rmpi} functions
#'          \code{mpi.iprobe()}, \code{mpi.any.source()}, 
#'          and \code{mpi.recv.Robj()}.       
#'
#'          The termination messages are sent to all processes. 
#'          The message that the broadcaster sends to himself 
#'          is not received and remains in the mpi queue.
#'
#' @param lF      Local function configuration.
#'
#' @return 0 (invisible).
#'
#' @family mpi communication 
#'
#' @export
mpiBroadcastTerm<-function(lF)
{
# tag=7 7 is integer for termination messages.
d<-"Terminate!"
for (i in (0:(lF$npid()-1)))
{ lF$RmpiFNS$mpi.send.Robj(obj=d, dest=i, tag=7, comm=1) }
invisible(0)
}

#' Factory for configuring broadcasting of termination messages.
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "rds": Broadcast termination rds-file.
#'  \item "mpi": Broadcast termination message via mpi. Code with comments.
#'  }
#'
#' @param method    Method. Default: "rds".
#'
#' @return A function for broadcasting a termination message.
#'
#' @family Configuration
#'
#' @examples
#' xegaBroadcastTermFactory(method="rds")
#'
#'@export
xegaBroadcastTermFactory<-function(method="rds")
{
   if (method=="rds") {f<-rdsBroadcastTerm}
   if (method=="mpi") {f<-mpiBroadcastTerm}
if (!exists("f", inherits=FALSE))
        {stop("xegaBroadcastTerm Factory label ", method, " does not exist")}
return(f)
}

