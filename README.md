# NetBID2shiny
A shiny app to perform the NetBID2 hidden driver analysis or visualize the NetBID2 results

# Install

## remote install

```
library(devtools)
library(BiocManager)
library(NetBID2)
# set repos, for R version 3.6.0, Bioconductor version 3.9
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.rstudio.com/"
  r["BioCsoft"] <- "https://bioconductor.org/packages/3.9/bioc"
  r["BioCann"] <- "https://bioconductor.org/packages/3.9/data/annotation"
  r["BioCexp"] <- "https://bioconductor.org/packages/3.9/data/experiment"
  options(repos = r)
})
install_github("jyyulab/NetBID_shiny",ref='master') 
```

Download the R package from https://github.com/jyyulab/NetBID_shiny/releases/download/0.1.0/NetBIDshiny_0.1.0.tar.gz and local install it.

## local install

download the directory to your workspace and then run:

devtools::install(pkg='.') ## please input the path to the directory

# Manual & Tutorial

manual: NetBIDshiny_0.1.0.pdf

tutorial: https://jyyulab.github.io/NetBID_shiny/

