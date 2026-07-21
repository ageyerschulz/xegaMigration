
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: Probing for termination messages (non-blocking) 
#          Package: xega
#

#' Construct a unique termination file name with sender embedded in name.
#'
#' @param from  Integer (pid of message sender).
#' @param path  File path. Default: ".".
#'
#' @return A file name of the form TermFrom<spid>ToAllRND<pad>.rds
#' 
#' @family rds communication
#'
#' @examples
#' rdsTermFileName(3)
#'
#'@importFrom stats runif
#'@export
rdsTermFileName<-function(from, path=".")
{pad<-paste(stats::runif(1))
 pad<-substr(pad, 3, nchar(pad))
fn<-paste0("TermFrom", from, "ToAllRND", pad, ".rds")
return(file.path(path, fn)) }

#' Probes for termination message(s) (rds).
#'
#' @description Tests if a rds file with the 
#'              filename TermFrom<spid>ToAllRND<pad>.rds
#'              exists.
#'              If such a file exists, returns \code{TRUE} for 
#'              setting the \code{DTP} (the Distributed Termination Predicate).
#'
#' @details The termination message is sent by the function 
#'          \code{rdsBroadcastTerm()} in the form of a rds file with the
#'          filename TermFrom<spid>ToAllRND<pad>.rds.
#'
#' @param lF      Local function configuration.
#'
#' @return Boolean. \code{TRUE} indicates that a termination message
#'                  has been received and that the process should terminate.
#' 
#' @family rds communication
#' 
#' @examples 
#' lF<-list()
#' path<-tempdir()
#' lF$path<- function() {path}
#' DPT<-rdsProbeTerm(lF)
#' cat("DPT", DPT, "\n")
#' fn<-rdsTermFileName(5, path=lF$path())
#' d<-"Terminate!"
#' saveRDS(object=d, file=fn)
#' DPT<-rdsProbeTerm(lF)
#' cat("DPT", DPT, "\n")
#'@export
rdsProbeTerm<-function(lF)
{ 
pat<-"*\\.rds"
fns<-list.files(path=lF$path(), pattern=pat)
pat2<-paste0("ToAllRND")
fns<-fns[grepl(pat2, fns)]
if (length(fns)==0) {return(FALSE)}
return(TRUE)}

#' Probes for termination message(s) (MPI).
#'
#' @description Probes for termination messages (\code{tag=7}). 
#'              If messages exist, returns \code{TRUE} for 
#'              setting the \code{DTP} (the Distributed Termination Predicate) 
#'              and consumes all termination messages.
#'
#' @details Expects \code{lF$RmpiFNS} elements bound to \code{Rmpi} functions
#'          \code{mpi.iprobe()}, \code{mpi.any.source()}, and \code{mpi.recv.Robj()}.       
#'
#' @param lF      Local function configuration.
#'
#' @return Boolean. \code{TRUE} indicates that a termination message
#'                  has been received and that the process should terminate.
#'
#' @family MPI communication
#'
#' @export
mpiProbeTerm<-function(lF)
{
# tag=7 7 is integer for termination messages.
DPT<-lF$RmpiFNS$mpi.iprobe(source=lF$RmpiFNS$mpi.any.source(), tag=7, comm=1, status=0)
while (lF$RmpiFNS$mpi.iprobe(source=lF$RmpiFNS$mpi.any.source(), tag=7, comm=1, status=0))
{ g<-lF$RmpiFNS$mpi.recv.Robj(source=lF$RmpiFNS$mpi.any.source(), tag=7, comm=1, status=0)}
return(DPT)
}

#' Factory for configuring probing for termination messages.
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "rds": Probing for termination rds-file.
#'  \item "mpi": Probing for termination message via MPI.
#'  }
#'
#' @param method    Method. Default: "rds".
#'
#' @return A function for probing a termination message.
#'
#' @family Configuration
#'
#' @examples
#' xegaProbeTermFactory(method="rds")
#'
#'@export
xegaProbeTermFactory<-function(method="rds")
{
   if (method=="rds") {f<-rdsProbeTerm}
   if (method=="mpi") {f<-mpiProbeTerm}
if (!exists("f", inherits=FALSE))
        {stop("xegaProbe Factory label ", method, " does not exist")}
return(f)
}
