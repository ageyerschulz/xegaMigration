

#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: Message receiving (non-blocking).
#          Package: xegaMigration
#

#' Receive genes from neighbor processes (non-blocking).
#'
#' @description Multiple messages are received, if they exist
#'              (non-blocking).  
#'
#' @param lF      Local function configuration.
#'
#' @return A gene list. 
#' 
#' @family rds communication
#' 
#' @examples 
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$pid<-function()  {3}
#' lF$nrecv<-function() {1}
#' lF$CommunicationTopology<-xegaCommunicationTopologyFactory(method="ring")
#' path<-tempdir()
#' lF$path<- function() {path}
#' genes<-list(sample(0:1, 10, replace=TRUE))
#' rdsSendGenes(genes, lF)
#' fn<-list.files(lF$path())
#' rdsReceiveGenes(lF)
#' lF$pid<-function()  {4}
#' rdsReceiveGenes(lF)
#'@export
rdsReceiveGenes<-function(lF)
{ genes<-list()
pat<-"*\\.rds"
fns<-list.files(path=lF$path(), pattern=pat)
pat2<-paste0("To", lF$pid(), "RND")
fns<-fns[grepl(pat2, fns)]
if (length(fns)==0) {return(genes)}
for (i in (1:length(fns)))
{  fn<-file.path(lF$path(), fns[i])
   readError<-FALSE
   tryCatch(
     {g<-readRDS(fn)},
     error=function(e) {readError<<-TRUE}
      )
   if (readError) {next}
   genes<-c(genes, g)
   file.remove(fn)
}
return(genes) }

#' Receive genes from neighbor processes (blocking).
#'
#' @description Blocking means barrier synchronization.
#'              
#' @param lF      Local function configuration.
#'
#' @return A gene list. 
#' 
#' @family rds communication
#' 
#'@export
rdsReceiveGenesBlocking<-function(lF)
{ invisible(rdsBarrier(lF))
  return(rdsReceiveGenes(lF)) }

#' Receive genes from neighbor processes (non-blocking).
#'
#' @description Multiple MPI messages are received, if they exist
#'              (non-blocking).  
#'              Test for existence of message: Rmpi::mpi.iprobe()
#'              and message receive: Rmpi::mpi.recv.Robj().  
#'
#' @param lF      Local function configuration.
#'
#' @return A gene list. 
#'
#' @family MPI communication
#'
#' @export
mpiReceiveGenes<-function(lF)
{ genes<-list()
while (lF$RmpiFNS$mpi.iprobe(source=lF$RmpiFNS$mpi.any.source(), tag=9, comm=1, status=0))
{ g<-lF$RmpiFNS$mpi.recv.Robj(source=lF$RmpiFNS$mpi.any.source(), tag=9, comm=1, status=0)
genes<-c(genes, g) }
return(genes)
}

#' Receive a result (non-blocking).
#'
#' @description A result object (\code{tag=8}) is received, if one exists.
#'                
#'
#' @param lF      Local function configuration.
#'
#' @return  A result object or an empty list.
#'
#' @family MPI communication
#'
#' @export
mpiReceiveResult<-function(lF)
{ result<-list()
if (lF$RmpiFNS$mpi.iprobe(source=lF$RmpiFNS$mpi.any.source(), tag=8, comm=1, status=0))
{ result[[1]]<-lF$RmpiFNS$mpi.recv.Robj(source=lF$RmpiFNS$mpi.any.source(), tag=8, comm=1, status=0)}
return(result)
}

#' Receive genes from neighbor processes (blocking).
#'
#' @description Blocking means barrier synchronization.
#'              Multiple MPI messages are received, if they exist.
#'              Test for existence of message (blocks): mpi.probe() 
#'              and message receive: mpi.recv.Robj().  
#'
#' @param lF      Local function configuration.
#'
#' @return A gene list. 
#'
#' @family MPI communication
#'
#' @export
mpiReceiveGenesBlocking<-function(lF)
{ invisible(lF$RmpiFNS$mpi.barrier())
  return(mpiReceiveGenes(lF)) }

#' Factory for configuring the message receiving
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "rds": Message receiving via rds-file I/O. Non-blocking.
#'  \item "rdsb": Message receiving via rds-file I/O. Barrier synchronization.
#'  \item "mpi": Message receiving via mpi. Code with comments. Non-blocking.
#'  \item "mpib": Message receiving via mpi. Code with comments. 
#'                Barrier synchronization. 
#'  }
#'
#' @param method    Method. Default: "rds".
#'
#' @return A function for sending a message.
#'
#' @family Configuration
#'
#' @examples
#' xegaReceiveFactory(method="rds")
#'
#'@export
xegaReceiveFactory<-function(method="rds")
{
   if (method=="rds") {f<-rdsReceiveGenes}
   if (method=="rdsb") {f<-rdsReceiveGenesBlocking}
   if (method=="mpi") {f<-mpiReceiveGenes}
   if (method=="mpib") {f<-mpiReceiveGenesBlocking}
if (!exists("f", inherits=FALSE))
        {stop("xegaReceive Factory label ", method, " does not exist")}
return(f)
}

