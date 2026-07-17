#
# (c) 2026 Andreas Geyer-Schulz
# xegaMigrationReport
# Package: xegaMigration
#

#' Produce a migration report.
#'
#' @param msgSent      Messages sent.
#' @param msgReceived  Mesages received.
#' @param lF           Local function configuration and algorithm state.
#'
#' @return A list of named lists. Each named list has the form:
#'         \itemize{
#'         \item \code{$type}: "I" indicates an immigrant, "e" an emigrant.
#'         \item \code{$pid}:  pid.
#'         \item \code{$tpid}: \code{frompid} for an immigrant, 
#'                                 \code{topid}   for an emigrant.
#'         \item \code{$iteration}: Which generation?
#'         \item \code{$timems}: Time in Milliseconds (see \code{base::Sys.time()}).
#'         \item \code{$fit}: Fitness.
#'         \item \code{$gene}: The gene. 
#'         }           
#' 
#' @family Reporting
#'
#' @examples
#' cat("TODO\n")
#'
#'@export
xegaMigrationReport<-function(msgSent=list(), msgReceived=list(), lF)
{
result<-list()
iteration<-lF$cGeneration()
pid<-lF$pid()
if (!(length(msgSent)==0))
{
# 1. Emigrants.
emigrants<-msgSent[[1]]$genes
pid<-msgSent[[1]]$fromPid
timems<-msgSent[[1]]$timems
dest<-lF$CommunicationTopology(lF)
for (j in (1:length(dest))) {
for (i in (1:length(emigrants)))
{
g<-emigrants[[i]]
# cat(i, j, "g:\n")
# print(g)
rec<-list()
rec$type<-"E"
rec$pid<-pid
rec$tpid<-dest[j]
rec$timems<-timems
rec$iteration<-iteration
rec$fit<-g$fit
rec$gene<-g$gene1
result[[1+length(result)]]<-rec
}}
}
# 2. Immigrants.
if (length(msgReceived$data)>0)
{
     #  cat("msgReceived Start.\n")
     #  print(msgReceived)
     #  cat("msgReceived End.\n")
      for (i in (1:length(msgReceived$data)))
      { genes<-msgReceived$data[[i]]$genes
        fromPid<-msgReceived$data[[i]]$fromPid
        timems<-msgReceived$data[[i]]$timems
        for (j in (1:length(genes)))
        {
        rec<-list()
        rec$type<-"I"
        rec$pid<-pid
        rec$tpid<-fromPid
        rec$timems<-timems
        rec$iteration<-iteration
        rec$fit<-genes[[j]]$fit
        rec$gene<-genes[[j]]$gene1
        result[[1+length(result)]]<-rec
      }}
}
# 3. Return.
return(result)
}

#' Print migration report.
#'
#' @param report   A migration report.
#'
#' @return Innvisible 0.
#'
#' @family Reporting
#'
#' @examples
#' cat("TODO\n")
#'
#'@export
xegaShowMigrationReport<-function(report)
{
if (length(report)==0) {return(invisible(0))}
for (i in (1:length(report)))
{
r<-report[[i]]
cat(r$timems, " ", r$iteration, ":", r$type," ", r$pid, " ",r$tpid, " ", r$fit, "\n")
}
invisible(0)
}
