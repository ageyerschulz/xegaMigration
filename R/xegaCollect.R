
#
# xegaCollect.R
# (c) 2026 Andreas Geyer-Schulz
#

#' Collects results of all island processes (rds).
#' 
#' @description Upon termination all island processes 
#'              (except process \code{0}) write their result object
#'              to a rds-file with prefix "xegaResult". 
#'              Process \code{0} reads these files and 
#'              aggregates them.
#' 
#' @param result  A result of xegaRun. Default: \code{list()}.
#' @param lF   Local function configuration. Default: lF.
#'
#' @return A named list with 
#'         \itemize{
#'         \item \code{$results}: A list of xegaRun result objects. 
#'         \item \code{$rc}: The return code. 
#'               A return code of \code{0} means that the results of all 
#'               processes have been collected. 
#'               A return code of \code{-1} means that not all results 
#'               have been collected within a specified time interval.
#'         }
#'
#'@export
rdsCollect<-function(result=list(), lF=lF)
{
r<-list()
pat<-"*\\.rds"
pat2<-"xegaResult"
s<-0.01
j<-1
filesDone<-list()
repeat
{ fnsall<-list.files(path=lF$path(), pattern=pat)
  fns<-fnsall[grepl(pat2, fnsall)]
if (!length(fns)==0)
{
for (i in (1: length(fns)))
{  fname<-fns[[i]]
   if (fname %in% filesDone) {next}
   fn<-file.path(lF$path(), fname)
   readError<-FALSE
   tryCatch(
            {g<-readRDS(fn)},
             error=function(e) 
                     {# cat("rdsCollect: readRDS", fn, "failed.\n")
                       Sys.sleep(0.1)
                       readError<<-TRUE 
                     }
           )
   if (readError) {break}
   r[[length(r)+1]]<-g
   filesDone<-c(filesDone, fname)
   file.remove(fn) }
if (length(r)==lF$npid())
   {rc<-0; break}      
}
   Sys.sleep(s)
   j<-j+1
if ((j*s)>lF$maxDelay())
   {rc<-(-1); break} 
}
res<-list()
res$results<-r
res$rc<-rc
return(res)}

#' Collects results of all island processes (mpi).
#' 
#' @description Upon termination all island processes 
#'              (except process \code{0}) write their result object
#'              to a rds-file with prefix "xegaResult". 
#'              Process \code{0} reads these files and 
#'              aggregates them.
#' 
#' @param result  A result of xegaRun. Default: \code{list()}.
#' @param lF   Local function configuration. Default: lF.
#'
#' @return A named list with 
#'         \itemize{
#'         \item \code{$results}: A list of xegaRun result objects. 
#'         \item \code{$rc}: The return code. 
#'               A return code of \code{0} means that the results of all 
#'               processes have been collected. 
#'               A return code of \code{-1} means that not all results 
#'               have been collected within a specified time interval.
#'         }
#'
#'@export
mpiCollect<-function(result=list(), lF=lF)
{
if (!lF$pid()==0)
   {# cat("mpiCollect: pid ", lF$pid(), " sending results by mpi.\n") 
      mpiSendResults(result=result, lF=lF) 
    # cat("mpiCollect: pid ", lF$pid(), " sent results by mpi.\n") 
    return(result) }

if (lF$pid()==0)
{
r<-list()
r[[1]]<-result
s<-0.01
j<-0
repeat
{  
   # cat("mpiCollect: pid ", lF$pid(), ". No results", length(r), ". Receiving results.\n") 
   g<-mpiReceiveResult(lF)
   # cat("mpiCollect: pid ", lF$pid(), "received results.\n") 
   # print(g)
   r<-c(r,g)
   # cat("mpiCollect: pid ", lF$pid(), "received", length(r),"results.\n") 
if (length(r)==lF$npid())
   {
   # cat("mpicollect: pid", lF$pid(), "return 4 results.\n")
    rc<-0; break}      
   Sys.sleep(s)
   j<-j+1
#if ((j*s)>lF$maxDelay())
#   {cat("mpicollect: pid", lF$pid(), "time out.\n")
#    rc<-(-1); break} 
}
res<-list()
res$results<-r
res$rc<-rc
}

# cat("mpiCollect: pid ", lF$pid(), "returns.\n") 
return(res)}

#' Factory for configuring the collection of results of island results.
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "rds": Collects xegaRun result files.
#'               May terminate by a time out, before all result files 
#'               have been produced. 
#'  \item "mpi": Collects xegaRun result files.
#'               May terminate by a time out, before all result files 
#'               have been produced. 
#'  }
#'
#' @param method    Method. Default: "rds".
#'
#' @return A function for collecting xegaRun result objects.
#'
#' @family Configuration
#'
#' @examples
#' xegaCollectFactory(method="rds")
#'
#'@export
xegaCollectFactory<-function(method="rds")
{
   if (method=="rds") {f<-rdsCollect}
   if (method=="mpi") {f<-mpiCollect}
if (!exists("f", inherits=FALSE))
        {stop("xegaCollect Factory label ", method, " does not exist")}
return(f)
}

