
<!-- README.md is generated from README.Rmd. Please edit that file -->
powsim: Power analysis for bulk and single cell RNA-seq experiments
===================================================================

To install powsim, make sure you have installed the following R packages:

``` r
ipak <- function(pkg, repository=c('CRAN', 'Bioconductor', 'github')){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) {
    if(repository=='CRAN') {
      install.packages(new.pkg, dependencies = TRUE)
    }
    if(repository=='Bioconductor') {
      source("https://bioconductor.org/biocLite.R")
      biocLite(new.pkg, dependencies=TRUE, ask=FALSE)
    }
    if(repository=='github') {
      devtools::install_github(pkg, build_vignettes = FALSE)
    }
  }
}

# CRAN PACKAGES
cranpackages <- c("gamlss.dist", "methods", "stats", "moments", "doParallel", "parallel", "reshape2", "dplyr", "tidyr", "data.table", 'ggplot2', 'ggthemes', 'ggExtra', 'cowplot', 'scales', 'fitdistrplus', 'MASS', 'pscl', 'nonnest2', 'cobs', 'msir', 'drc', 'devtools', 'XML')
# Note: To install msir, the dependency rgl needs to be installed (apt-get install libx11-dev mesa-common-dev libglu1-mesa-dev).
# Note to install XML, xml2 config is needed (apt-get install libxml2-dev).
ipak(cranpackages, repository='CRAN')

# BIOCONDUCTOR
biocpackages <- c('S4Vectors', 'AnnotationDbi', 'Biobase', 'BiocParallel', 'scater', 'scran', 'edgeR', 'limma', 'DESeq2', 'baySeq', 'NOISeq', 'EBSeq', 'DSS', 'MAST', 'ROTS', "IHW", 'qvalue')
ipak(biocpackages, repository='Bioconductor')

# GITHUB
# Note: to install scde cairo and x11 are needed (apt-get install libcairo2-dev, apt-get install libxt-dev).
githubpackages <- c('gu-mi/NBGOF', 'hms-dbmi/scde', 'nghiavtr/BPSC')
ipak(githubpackages, repository = 'github')
devtools::install_github('kdkorthauer/scDD', build_vignettes = FALSE, ref = 'develop')
```

For examples and tips on using the package, please see the vignette PDF [here](https://github.com/bvieth/powsim/vignettes/powsim.pdf) which you can alternatively bring up by typing

``` r
browseVignettes("powsim")
```

after installing and loading the package into R.

Please send bug reports and feature requests by opening a new issue on [this page](https://github.com/bvieth/powsim/issues)

Note: The package was built using R version of R 3.3.2 (2016-10-31).
