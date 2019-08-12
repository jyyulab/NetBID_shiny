---
title: "FAQ"
layout: default
nav_order: 4
permalink: /docs/FAQ
---

## Tutorial for Hidden driver (master regulator) estimation

- [Q & A: How to prepare eSet class object RData file ?](../docs/tutorial4MR#q--a-how-to-prepare-eset-class-object-rdata-file-)

- [Q & A: How to use self-defined network files ?](../docs/tutorial4MR#q--a-how-to-use-self-defined-network-files-)

- [Q & A: How to use if only has TF network without SIG network ?](../docs/tutorial4MR#q--a-how-to-use-if-only-has-tf-network-without-sig-network-)

- [Q & A: How to deploy the application by having pre-generated network files or calculation dataset ?](../docs/tutorial4MR#q--a-how-to-deploy-the-application-by-having-pre-generated-network-files-or-calculation-dataset-)

## Tutorial for Visualization

- [Q & A: How to share results with others by deploying the application by having pre-generated result RData dataset ?](../docs/tutorial4Vis#q--a-how-to-share-results-with-others-by-deploying-the-application-by-having-pre-generated-result-rdata-dataset-)

## Other FAQ

### Q: What to do if there is an error message maximum upload size exceeded ?

**A**: If there is an error message maximum upload size exceeded, please set `options(shiny.maxRequestSize = 1000*1024^2)` to a larger number. 
Here the options means the maximum request size is 1000mb.

### Q: How to publish the application to a remote server ?

**A**: If user could run the server locally, he could directly call the function to open an application (check the Q&A above).

If deploy remotely, run the following code before deploying the application:

```r
## define repo directory, here version 3.9 matches the R version 3.6.1
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.rstudio.com/"
  r["BioCsoft"] <- "https://bioconductor.org/packages/3.9/bioc"
  r["BioCann"] <- "https://bioconductor.org/packages/3.9/data/annotation"
  r["BioCexp"] <- "https://bioconductor.org/packages/3.9/data/experiment"
  options(repos = r)
})
```
Deploy the first application for hidden driver analysis:

```r
search_network_path <- 'data/network_txt/' ## need to modify
search_eSet_path <- 'data/eSet_RData/' ## need to modify
pre_project_main_dir <- 'MR_result/' ## need to modify
options(shiny.maxRequestSize = 1000*1024^2) ## set size for uploading files
appDir <- system.file('app_4MR/',package = "NetBIDshiny") ## the directory for server.R and ui.R
rsconnect::deployApp(appDir=appDir,appName='NetBIDshiny_forMR',server = 'shinyapps.io')
```

Deploy the second application for result visualization:

```r
search_path <- 'data/project_RData' ## need to modify
options(shiny.maxRequestSize = 1000*1024^2) ## set size for uploading files
appDir <- system.file('app_4Vis/',package = "NetBIDshiny") ## the directory for server.R and ui.R
rsconnect::deployApp(appDir=appDir,appName='NetBIDshiny_forVis1',server = 'shinyapps.io')
```

In the current `server.R`, there will be one line to install the `NetBID2` packages. 
Please pay attention if there will be some update on the github repo.

```r
devtools::install_github("jyyulab/NetBID2",ref='master',dependencies='Depends')
```

If user want more modification, he could copy the code to another directory for further modification. 

**Attention**, the code script is not allowed for commercial usage without requiring for permission. 

------


