######################################################################
## Differential expression tag, lfc values, number of sims
######################################################################

#' @name DESetup
#' @aliases DESetup
#' @title Setup options for RNA-seq count simulations.
#' @description This function generates a set of differential expressed gene IDs with associated fold changes for a given number of genes, simulations and fraction of DE genes.
#' @usage DESetup(ngenes, nsims=25, p.DE=0.1, LFC, sim.seed)
#' @param ngenes Number of genes to be simulated.
#' @param nsims Number of simulations to run. Default is 25.
#' @param p.DE Percentage of genes being differentially expressed (DE). Default is 10\%.
#' @param LFC The log2 fold change for DE genes. This can be:
#' (1) a constant, e.g. 2;
#' (2) a vector of values with length being number of DE genes. If the input is a vector and the length is not the number of DE genes, it will be sampled with replacement to generate log-fold change;
#' (3) a function that takes an integer n, and generates a vector of length n, e.g. function(x) rnorm(x, mean=0, sd=1.5).
#' @param sim.seed Simulation seed.
#' @return A list with the following entries:
#' \item{ngenes}{An integer for number of genes.}
#' \item{nsims}{An integer for number of simulations.}
#' \item{sim.seed}{The specified simulation seed.}
#' \item{p.DE}{Percentage of DE genes.}
#' \item{DEid}{A list (length=nsims) of vectors (length=ngenes*p.DE) for the IDs of DE genes.}
#' \item{lfc}{A list (length=nsims) of vectors (length=ngenes) for log fold change of all genes, ie nonDE=0 and DE=lfc.}
#' \item{design}{Two group comparison}
#' @author Beate Vieth
#' @examples
#' \dontrun{
#' desettings <- DESetup(ngenes=10000,
#' nsims=25,
#' p.DE=0.2,
#' LFC=function(x) sample(c(-1,1), size=x,replace=TRUE)*rgamma(x, 3, 3))
#' }
#' @rdname DESetup
#' @export
DESetup <- function(ngenes, nsims=25, p.DE=0.1,
                           LFC, sim.seed) {
  if (missing(sim.seed))
    sim.seed = sample(1:1000000, size = 1)
  set.seed(sim.seed)

  nDE = round(ngenes*p.DE)
  DEids = lfcs = NULL
  for (i in 1:nsims) {
    # generate a random id for DE genes
    DEid <- sample(ngenes, nDE, replace = FALSE)
    DEids[[i]] <- DEid
    ## generate lfc for all genes: 0 for nonDE and LFC for DE
    lfc = rep(0, ngenes)
    lfc[DEid] = .setFC(LFC, nDE)
    lfcs[[i]] = lfc
  }

  sim.seed = as.vector(sample(1:1000000, size = nsims, replace = F))

  set.seed(NULL)

  ## return
  res <- c(list(DEid = DEids, lfc = lfcs, ngenes = ngenes, nsims = nsims, p.DE = p.DE, sim.seed.DESetting = sim.seed), list(sim.seed = sim.seed), design = "2grp")
  return(res)

}


######################################################################
## Combining DE settings with NB parameters
######################################################################

#' @name SimSetup
#' @aliases SimSetup
#' @title DEA options for RNA-seq count simulations in two-group comparison.
#' @description This function adds user provided options for simulating RNA-seq data to RNAseq.SimSetup object. The resulting output list object is the input for \code{\link{simulateDE}} function.
#' @usage SimSetup(desetup, params, size.factors='equal')
#' @param desetup The RNAseq simulation parameters created by \code{\link{DESetup}}.
#' @param params The negative binomial parameters for simulations. This can be:
#' (1) The output of \code{\link{estimateNBParam}}.
#' (2) The output of \code{\link{insilicoNBParam}}.
#' (3) A string specifying the name of precalculated estimates, see details.
#' @param size.factors Size factors representing sample-specific differences/biases in expected mean values of the NB distribution: "equal" or "given". The default is "equal", i.e. equal size factor of 1. If the user defines it as given, the size factors are sampled from the size factors provided by the output of \code{\link{estimateNBParam}} or \code{\link{insilicoNBParam}}.
#' @return A list with the following entries:
#' \item{desetup}{The RNAseq simulation parameters.}
#' \item{params}{The negative binomial parameters for simulations.}
#' \item{size.factors}{Size factor definition: "equal" or "given"}
#' @author Beate Vieth
#' @examples
#' \dontrun{
#' desettings <- DESetup(ngenes=10000,
#' nsims=25, p.DE=0.2,
#' LFC=function(x) sample(c(-1,1), size=x,replace=TRUE)*rgamma(x, 3, 3))
#' simsettings <- SimSetup(desetup=desettings,
#' params=estparam, size.factors='equal')
#' }
#' @rdname SimSetup
#' @export
SimSetup <- function(desetup, params, size.factors='equal') {

  ## return
  res <- c(desetup, params, size.factors=size.factors)
  attr(res, 'param.type') <- attr(params, 'param.type')
  return(res)

}


##############################################################
## function to set fold change for DE genes
##############################################################
.setFC <- function(input, nDEgenes) {
  if (is.vector(input)) { ## vector
    if (length(input) == 1) { ## constant
      lfc = rep(input, nDEgenes)
    } else if (length(input) != nDEgenes) { ## vector
      lfc = sample(input, nDEgenes, replace = TRUE)
    } else {
      lfc = input
    }
  } else if (is.function(input)) { # a function
    lfc = input(nDEgenes)
  }   else {
    stop("Unrecognized form of lfc!\n")
  }
  lfc
}
