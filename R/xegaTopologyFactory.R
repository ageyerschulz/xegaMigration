
#
# (c) 2026 Andreas Geyer-Schulz
#          Migration between algorithms: Communication Topology
#          Package: xegaMigrate
#

#' Select neighbor in ring topology.
#'
#' @param  lF  Local function condiguration. 
#'             Required element are 
#'             \itemize{ 
#'             \item \code{lF$npid()}:   Total number of processes.
#'             \item \code{lF$pid()}:    Process number of message sender.
#'             }
#' 
#' @return Process number of message receiver. 
#' 
#' @family Communication Topology
#' 
#' @examples
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$pid<-function()  {3}
#' ringTop(lF)
#' lF$pid<-function()  {9}
#' ringTop(lF)
#'
#' @export
ringTop<-function(lF)
{ dest<-(lF$pid()+1) %% lF$npid()
  return(dest)}

#' Select neighbors in bidirectional ring topology.
#'
#' @param  lF  Local function condiguration. 
#'             Required element are 
#'             \itemize{ 
#'             \item \code{lF$npid()}:   Total number of processes.
#'             \item \code{lF$pid()}:    Process number of message sender.
#'             }
#' 
#' @return Process numbers of message receivers. 
#' 
#' @family Communication Topology
#' 
#' @examples
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$pid<-function()  {3}
#' ring2Top(lF)
#' lF$pid<-function()  {9}
#' ring2Top(lF)
#'
#' @export
ring2Top<-function(lF)
{ dest1<-(lF$pid()+1) %% lF$npid()
  dest2<-(lF$pid()-1) %% lF$npid()
  return(c(dest1, dest2))}

#' Select neighbors in 2D-torus.
#'
#' @description Processors are arranged in a X times Y grid. 
#'              This implies that \code{lF$npid()==lF$torusX()*lF$torusY()}.
#'
#' @details The algorithm works in the following way:
#'          \enumerate{
#'          \item \code{lF$pif()} is converted into the grid coordinates 
#'                (x, y) by the local function \code{n2xy()}.
#'          \item The four neighbours in a distance of 1 are determined.
#'          \item The coordinates are converted back to processor identifiers
#'                by the local function \code{xy2n()}.
#'          \item The list of identifiers of the neighbor processes is returned.
#'          }
#'
#' @param  lF  Local function condiguration. 
#'             Required element are 
#'             \itemize{ 
#'             \item \code{lF$torusX()}: Number of elements in X axes.
#'             \item \code{lF$torusY()}: Number of elements in Y axes.
#'             \item \code{lF$pid()}:    Process number of message sender.
#'             }
#' 
#' @return Process numbers of message receivers. 
#' 
#' @family Communication Topology
#' 
#' @examples
#' lF<-list()
#' lF$pid<-function() {5}
#' lF$torusX<-function() {3}
#' lF$torusY<-function() {2}
#' torus2DTop(lF)
#'
#' @export
torus2DTop<-function(lF)
{
n2xy<-function(lF)
{ y1<-floor(lF$pid()/lF$torusX())
  x1<-lF$pid()-(lF$torusX()*(y1))
  return(c((x1+1), (y1+1))) }

xy2n<-function(x, y, lF)
{ x1<-x; y1<-y
  if (x1==0) {x1<-lF$torusX()}
  if (y1==0) {y1<-lF$torusY()}
  return((x1-1)+(y1-1)*lF$torusX()) }

pos<-n2xy(lF)
p1<-xy2n(((pos[1]+1) %% lF$torusX()), pos[2], lF)
p2<-xy2n(((pos[1]-1) %% lF$torusX()), pos[2], lF)
p3<-xy2n(pos[1], ((pos[2]+1) %% lF$torusY()), lF)
p4<-xy2n(pos[1], ((pos[2]-1) %% lF$torusY()), lF)

return(c(p1, p2, p3, p4))
}

#' Select one or more random neighbors from all neighbors. 
#'
#' @param  lF  Local function condiguration. 
#'             Required element are 
#'             \itemize{ 
#'             \item \code{lF$npid()}:   Total number of processes.
#'             \item \code{lF$pid()}:    Process number of message sender.
#'             \item \code{lF$nrecv()}: Number of message receivers.   
#'             }
#' 
#' @return Process number(s) of message receiver(s). 
#' 
#' @family Communication Topology
#' 
#' @examples
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$pid<-function()  {3}
#' lF$nrecv<-function() {1}
#' rndTop(lF)
#' lF$nrecv<-function() {2}
#' rndTop(lF)
#'
#' @export
rndTop<-function(lF)
{ dest<-sample(0:(lF$npid()-1), lF$nrecv())
  while (lF$pid() %in% dest) { dest<-sample(0:(lF$npid()-1), lF$nrecv())}
  return(dest)}

#' Select neighbours in a Generalized Petersen graph GP(n,k).
#'
#' @description The Generalized Petersen graph GP(n, k) is a 3-regular
#'   graph on \code{2n} vertices. Outer ring vertices \code{0:(n-1)}
#'   form a cycle; inner ring vertices \code{n:(2n-1)} form a
#'   \code{k}-skip cycle; each outer vertex \code{i} is connected to
#'   inner vertex \code{n + i} by a spoke. The most famous instance
#'   GP(5, 2) is the Petersen graph itself: vertex- and
#'   edge-transitive, distance-transitive, strongly regular,
#'   adjacent vertices without common neigbour, and 
#'   non-connected vertices share exactly one common neighbor.
#'
#' @details Each processing unit in GP(n, k) has exactly three neighbours
#'   (the graph is cubic). \code{gpTop()} returns all three by
#'   default. TODO: The receiver count and migration semantics still
#'   flow through \code{lF$Nmigrants()} as in the rest of the
#'   migration pipeline; \code{gpTop()} only specifies *which*
#'   ranks may receive.
#'   (Author: M. Zamani-Shandiz.)
#'
#' @param  lF  Local function configuration.
#'             Required elements are
#'             \itemize{
#'             \item \code{lF$npid()}: Total number of processes;
#'                   must equal \code{2 * lF$gp_n()}.
#'             \item \code{lF$pid()}: Process number of message sender.
#'             \item \code{lF$GP_n()}: Integer \eqn{n} of the
#'                   GP(n, k) family. Must be \eqn{\ge 3}.
#'             \item \code{lF$GP_k()}: Integer \eqn{k} of the
#'                   GP(n, k) family. Must satisfy
#'                   \eqn{1 \le k \le n - 1}.
#'             }
#'
#' @return Integer vector of process numbers of message receivers.
#'   Length 3 (the cubic neighbour set).
#'
#' @family Communication Topology
#'
#' @references
#'   Watkins, M. E. (1969). A theorem on Tait colorings with an
#'   application to the generalized Petersen graphs.
#'   \emph{J. Combin. Theory} 6:152-164.
#'   <doi:10.1016/S0021-9800(69)80116-X>
#'
#'   Holton, D. A. & Sheehan, J. (1993). \emph{The Petersen Graph}.
#'   Cambridge University Press.
#'   (ISBN:978-0521435949)
#'
#' @examples
#' lF<-list()
#' lF$npid<-function() {10}
#' lF$GPn<-function() {5}
#' lF$GPk<-function() {2}
#' lF$pid<-function()  {0}
#' gPetersenTop(lF)    # outer vertex 0: prev=4, next=1, spoke=5
#' lF$pid<-function()  {7}
#' gPetersenTop(lF)    # inner vertex 7 (= n+2): inner_prev, inner_next, spoke=2
#'
#' @export
gPetersenTop<-function(lF)
{ n<-as.integer(lF$GPn())
  k<-as.integer(lF$GPk())
  npid<-as.integer(lF$npid())
  pid<-as.integer(lF$pid())
  if (npid != 2L*n)
  stop(sprintf("gPetersenTop: npid must be 2*GPn; got npid=%d, GPn=%d",
                 npid, n))
  if (n < 3L)
  stop(sprintf("gPetersonTop: GPn must be >= 3; got n=%d", n))
  if (k < 1L || k >= n)
  stop(sprintf("gPetersenTop: GPk must be in [1, n-1]; got k=%d (n=%d)", k, n))
  if (pid < n) {
    outer_prev<-(pid - 1L) %% n
    outer_next<-(pid + 1L) %% n
    spoke     <-n + pid
    dest<-c(outer_prev, outer_next, spoke)
  } else {
    inner_idx<-pid - n
    inner_prev<-n + ((inner_idx - k) %% n)
    inner_next<-n + ((inner_idx + k) %% n)
    spoke     <-inner_idx
    dest<-c(inner_prev, inner_next, spoke)
  }
  return(as.integer(dest))
}

## Stop if specifications of generalized Petersen graph are inconsistent.
##
## @param CommunicationTopology   A string specifying the communication topology.
## @param lF   Local function list. 
##
## @return invisible(0)
##
## export
#testIfgPetersenInconsistent(CommunicationTopology ,lF)
#{
#if ("gPetersen"==CommunicationTopology)
#{
#   n<-as.integer(lF$GPn())
#   k<-as.integer(lF$GPk())
#   npid<-as.integer(lF$npid())
#   if (npid != 2L*n)
#      {stop(sprintf("gPetersenTop: npid must be 2*GPn; got npid=%d, GPn=%d",
#                 npid, n))}
#   if (n < 3L)
#      {stop(sprintf("gPetersonTop: GPn must be >= 3; got n=%d", n))}
#  if (k < 1L || k >= n)
#     {stop(sprintf("gPetersenTop: GPk must be in [1, n-1]; got k=%d (n=%d)", k, n))}
#}
#return(invisible(0))
#}

#' Factory for configuring the communication topology.
#'
#' Avalailable methods: 
#' \enumerate{
#'  \item "random": Returns a function which selects (a) random message receiver(s).
#'  \item "ring": Returns a function which selects the ring neighbour mod(i+1, n)  of node i 
#'                  as message receiver.
#'  \item "ring2": Returns a function which selects the ring neighbours 
#'                 mod(i+1, n) and
#'                 mod(i-1, n)  of node i 
#'                  as message receiver.
#'  \item "torus2D": Returns a function which selects the neighbours 
#'                   on a 2D-torus.
#'  \item "gPetersen": Returns a function which selects the neigbors of the process in a 
#'                     generalized Petersen Graph PG(n, k). The number of processes must be
#'                     \code{2n}, and \code{1<k<n}. 
#'  }
#'
#' @param method    Method. Default: "random".
#'
#' @return A function containing the communication topology for migration.
#'
#' @family Configuration
#'
#' @examples
#' xegaCommunicationTopologyFactory(method="random")
#'
#'@export
xegaCommunicationTopologyFactory<-function(method="random")
{
   if (method=="random") {f<-rndTop}
   if (method=="ring") {f<-ringTop}
   if (method=="ring2") {f<-ring2Top}
   if (method=="torus2D") {f<-torus2DTop}
   if (method=="gPetersen") {f<-gPetersenTop}
if (!exists("f", inherits=FALSE))
        {stop("xegaCommunicationTopology Factory label ", method, " does not exist")}
return(f)
}

