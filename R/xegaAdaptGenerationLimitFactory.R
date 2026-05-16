
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration: Adapt generation limit factory
#          Package: xegaMigration
#

#' The generation limit is adapted to the slowest process.
#'
#' @description The function computes an update of the generation limit 
#'              for faster island processes. The goal is to match the
#'              run-time of the faster island processes to the run-time of 
#'              the slowest island process in order to keep all processors 
#'              busy as long as the slowest process runs.
#'
#' @details     The current naive forecast is not reliable yet.
#'
#' @param lF      Local function configuration.
#'
#' @return The (new) number of generations (integer). 
#'
#' @family Migration
#'
#' @examples
#' lF<-list()
#' lF$slowestTime<-function(){5}
#' lF$Generations<-function() {100}
#' lF$avgTime<-function() {2.5}
#' adaptSlowest(lF)
#'
#' @export
adaptSlowest<-function(lF)
{ 
if (lF$slowestTime()<=lF$avgTime())
  {
  # The slowest process runs for the number of generation set by the user.
    newLimit<-lF$Generation() 
    # cat("adaptSlowest: generations(", generations, ")\n") 
    # cat(rep("*", 20), "\n")
    return(newLimit)
  }
# Faster processes increase their generation limit. 
newLimit<-ceiling(lF$slowestTime()*lF$Generations()/lF$avgTime())
# cat("adaptSlowest: newLimit(", newLimit, ")\n") 
return(newLimit)
}

#' The generation limit is not changed.
#'
#' @param lF      Local function configuration.
#'
#' @return The number of generations (integer). 
#'
#' @family Migration
#'
#' @examples
#' lF<-list()
#' lF$slowestTime<-function(){5}
#' lF$Generations<-function() {100}
#' lF$avgTime<-function() {2.5}
#' adaptId(lF)
#'
#' @export
adaptId<-function(lF)
{ 
a<-force(lF$Generations())
# cat("AdaptId:", a, "\n")
# cat(rep("*", 20), "\n")
return(a)
}

#' Factory for configuring the adaptation of the generation limit.
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "Slowest": Adapt generation limit according to slowest process.
#'  \item "Id":  Do not adapt. Fast processes end earlier.
#'  }
#'
#' @param method    Method. Default: "Adapt".
#'
#' @return A function for the adapting generation limit.
#'
#' @family Configuration
#'
#' @examples
#' xegaAdaptGenerationLimitFactory(method="Slowest")
#'
#'@export
xegaAdaptGenerationLimitFactory<-function(method="Slowest")
{
   if (method=="Slowest") {f<-adaptSlowest}
   if (method=="Id") {f<-adaptId}
if (!exists("f", inherits=FALSE))
   {stop("xegaAdaptGenerationLimit Factory label ", method, " does not exist")}
return(f)
}

