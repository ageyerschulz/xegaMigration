

#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: Message sending.
#          Package: xegaMigration
#

#' Construct a unique file name with sender and receiver embedded in name.
#'
#' @param from  Integer (pid of message sender).
#' @param to    Integer (pid of message receiver).
#' @param path  File path. Default: ".".
#'
#' @return A file name of the form From<spid>To<rpid>RND<pad>.rds
#' 
#' @family rds communication
#'
#' @examples
#' rdsFileName(3, 2)
#'
#'@export
rdsFileName<-function(from, to, path=".")
{pad<-paste(stats::runif(1))
 pad<-substr(pad, 3, nchar(pad))
fn<-paste0("From", from, "To", to, "RND", pad, ".rds")
return(file.path(path, fn)) }

#' Send genes to neighbor process.
#'
#' @description Uses saveRDS for writing messages to files.
#' The file name is of the form From<spid>To<rpid>RND<pad>.rds
#'
#' @param genes   A gene list.
#' @param lF      Local function configuration.
#'
#' @return 0 (invisible) 
#' 
#' @family rds communication
#' 
#' @examples 
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$pid<-function()  {3}
#' lF$nrecv<-function() {1}
#' lF$CommunicationTopology<-xegaCommunicationTopologyFactory(method="random")
#' path<-tempdir()
#' lF$path<- function() {path}
#' genes<-list(sample(0:1, 10, replace=TRUE))
#' print(genes)
#' rdsSendGenes(genes, lF)
#' fn<-list.files(lF$path(), pattern="*\\.rds")
#' print(fn)
#'@importFrom stats runif
#'@export
rdsSendGenes<-function(genes, lF)
{ dest<-lF$CommunicationTopology(lF)
for (i in (1:length(dest)))
{ fn<-rdsFileName(lF$pid(), dest[i], path=lF$path())
  saveRDS(object=genes, file=fn) }
invisible(0)
}

#' Send genes to neighbor process(es).
#'
#' @description A list of genes (the emigrants) 
#'              is sent to each destination. 
#'              The list of destinations is determined by 
#'              the communication topology used. 
#'              If there is more than one destination, 
#'              the same list of emigrants is sent to each 
#'              destination. 
#'
#' @details   Expects \code{Rmpi::mpi.send.Robj} bound to 
#'              \code{lF$RmpiFNS$mpi.send.Robj}. 
#'            The mpi message must be tagged with $9$.  
#'
#' @param genes   A gene list.
#' @param lF      Local function configuration.
#'
#' @return 0 (invisible) 
#'
#' @family mpi communication
#'
#' @export
mpiSendGenes<-function(genes, lF)
{
# tag=9 9 is integer for gene lists.
dest<-lF$CommunicationTopology(lF)
for (i in (1:length(dest)))
{ lF$RmpiFNS$mpi.send.Robj(obj=genes, dest=dest[i], tag=9, comm=1) }
invisible(0)
}

#' Send a a xega result to pid \code{0} with tag \code{8}.
#'
#' @description Sends the result object of the island 
#'              algorithm to the master process.
#'
#' @details   Expects \code{Rmpi::mpi.send.Robj} bound to 
#'              \code{lF$RmpiFNS$mpi.send.Robj}. 
#'            The mpi message must be tagged with $8$.  
#'
#' @param result  The result of the island algorithm.
#' @param lF      Local function configuration.
#'
#' @return 0 (invisible) 
#'
#' @family mpi communication
#'
#' @export
mpiSendResults<-function(result, lF)
{
# tag=8, 8 integer for results. dest=0: default master process.
lF$RmpiFNS$mpi.send.Robj(obj=result, dest=0, tag=8, comm=1) 
invisible(0)
}

#' Factory for configuring the message sending
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "rds": Message sending genes via rds-file I/O.
#'  \item "mpi": Message sending genes via mpi. Code with comments.
#  \item "mpiResult": Message sending results via mpi. Code with comments.
#'  }
#'
#' @param method    Method. Default: "rds".
#'
#' @return A function for sending a message.
#'
#' @family Configuration
#'
#' @examples
#' xegaSendFactory(method="rds")
#'
#'@export
xegaSendFactory<-function(method="rds")
{
   if (method=="rds") {f<-rdsSendGenes}
   if (method=="mpi") {f<-mpiSendGenes}
#   if (method=="mpiResult") {f<-mpiSendResult}
if (!exists("f", inherits=FALSE))
        {stop("xegaSend Factory label ", method, " does not exist")}
return(f)
}
