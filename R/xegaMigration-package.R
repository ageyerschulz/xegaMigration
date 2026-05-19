
#' The migration support for island models for \code{xega}
#' package.
#'
#' @section An Adaptive Completely Decentral Migration Strategy:
#'
#' The goal of the migration strategy of \code{xega} is to exploit 
#' the computing power of a set of loosely coupled processors is 
#' well as possible: 
#' \itemize{
#' \item The number of messages exchanged between 
#'       islands should be small (and configurable).  
#' \item The communication topology should be configurable.
#' \item All processes should terminate almost at the same time,
#'       so that no processor is idle. 
#' \item The algorithm should terminate, when either
#'       \itemize{
#'       \item one process fulfills a local termination predicate
#'             (reaches the optimal solution),
#'       \item the slowest processor reaches its generation limit.
#'             It is not known which of the processes is the slowest.
#'       }
#' }
#'       
#'
#'
#' @section The Migration Algorithm: 
#'
#' \enumerate{
#' \item Probe (non-blocking) for a distributed termination predicate DTP.
#'       from other islands.
#'       If a distributed termination predicate is set, return DTP to main.
#' \item If local termination predicate LTP, broadcast termination signal
#'       to other islands.
#' \item Select emigrants from population and send emigrants to 
#'       to other islands.
#' \item Receive immigrants and replace genes in population 
#'       by immigrants.
#' \item Update generation limit and identify slowest pid.
#' }
#'
#' @section An Adaptive Completely Decentral Migration Strategy:
#'
#' @section The Asynchronous Message Exchange Protocol:
#'
#' aaa
#'
#' @section The Asynchronous Termination Protocol:
#'
#' bbb
#'
#' @section rds Communication Primitives:
#'
#' ccc
#'
#' @section mpi Communication Primitives:
#'
#' ddd
#'
"_PACKAGE"

