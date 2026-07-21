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
#' @description A migration report is a list of named lists.
#'    A named list has the following elements:
#'    \itemize{
#'    \item \code{$timems}: Time in milliseconds.
#'    \item \code{$iterations}: Iteration number.
#'    \item \code{$type}: "E" for (E)migrant or "I" for (I)mmigrant.
#'    \item \code{$pid}: pid. 
#'    \item \code{$tpid}: pid. 
#'    \item \code{$fit}: Fitness.
#'    }
#'
#'    For emigrants, the gene has been sent from \code{$pid} to \code{$tpid}.
#' 
#'    For immigrants, the gene has been received by \code{$pid} from \code{$tpid}.
#'
#' @details Each gene which migrates occurs twice in a complete migration report:
#'          first as an emigrant and then as an immigrant.
#'
#'          The time resolution is supposed to help in ordering genes. However, 
#'          no perfect order of messages sent and received can be established from 
#'          the time stamp, because the time resolution is too coarse.
#'
#' @param report   A migration report. 
#'
#' @return Invisible 0.
#'
#' @family Reporting
#'
#' @examples
#' msg2<-msg1<-list();
#' msg1$timems<-as.numeric(Sys.time())
#' msg1$iteration<-7; msg2$iteration<-6
#' msg1$type<-"I"; msg2$type<-"E"
#' msg1$pid<-0; msg2$pid<-0
#' msg1$tpid<-2; msg2$tpid<-3
#' msg1$fit<-27.33; msg2$fit<-26.49
#' msg2$timems<-as.numeric(Sys.time())
#' r<-list(); r[[1]]<-msg1; r[[2]]<-msg2
#' xegaShowMigrationReport(r)
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
