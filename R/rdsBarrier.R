
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: rdsBarrier (synchronize processes) 
#          Package: xegaMigration
#
# Simulates mpi.barrier() with file primitives.
#

#' Construct a unique barrier file name with sender embedded in name.
#'
#' @param from  Integer (pid of message sender).
#' @param path  File path. Default: ".".
#'
#' @return A file name of the form Barrier<pid>.rds
#' 
#' @family rds communication
#'
#' @examples
#' rdsBarrierFileName(3)
#'
#'@importFrom stats runif
#'@export
rdsBarrierFileName<-function(from, path=".")
{pad<-paste(stats::runif(1))
 pad<-substr(pad, 3, nchar(pad))
fn<-paste0("Barrier", from, "pad", pad, ".rds")
return(file.path(path, fn)) }

#' Stop until all processes have reached the barrier.
#'
#' @description The island process reaching the barrier stops until 
#'              all other island processes also reach the barrier. 
#'              Then all island processes continue. 
#'              \code{rdsBarrier()} implements a group lock mechanism 
#'              based on file I/O operations with the same 
#'              synchronization behavior as \code{Rmpi::mpiBarrier()}. 
#'                 
#' @details Each island process writes its barrier file and tests 
#'          if the number of barrier files in the directory matches
#'          the number of island processes. 
#'          The island process which detects that all island processes
#'          have arrived at the barrier, removes all barrier files 
#'          (and thus releases all other island processes) before
#'          it continues.
#' 
#' @param lF    Local function configuration.
#'
#' @return 0    (invisible)
#' 
#' @family rds communication
#'
#' @examples
#' cat("No examples available!\n")
#'
#'@export
rdsBarrier<-function(lF)
{ 
fn<-rdsBarrierFileName(lF$pid(), path=lF$path())
saveRDS(object="Barrier!", file=fn)
pat<-"*\\.rds"
repeat 
{ Sys.sleep(0.00001)
  fns<-list.files(path=lF$path(), pattern=pat)
  pat2<-"Barrier"
  fnsb<-fns[grepl(pat2, fns)]

  if (lF$npid()==length(fnsb))
     { for (i in 1: length(fnsb))
     { fnrem<-file.path(lF$path(), fnsb[i])
       suppressWarnings(file.remove(fnrem)) }
     break }

  if (!file.exists(fn))
     { break}

}

return(invisible(0)) }

