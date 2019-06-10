---
layout: default
title: NetBIDshiny
nav_order: 1
description: "NetBIDshiny"
permalink: /
---

      
# NetBID2 Shiny app for online analysis and interactive visualization
{: .fs-9 }

Online tutorial and documentation of NetBIDshiny.
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/jyyulab/NetBID_shiny){: .btn .fs-5 }

---

## Overview

NetBIDshiny is a R Shiny web app, it provides an interactive online visualization tool for further analysis of drivers obtained from NetBID2.

NetBID2 is the upgraded second version of NetBID, which is a data-driven systems biology algorithm, using network-based Bayesian inference approach to find drivers from transcriptomics, proteomics and phosphoproteomics data. The NetBID2 R package can be found at [NetBID2](https://github.com/jyyulab/NetBID-dev), and online tutorial can be found at [NetBID2 tutorial](https://jyyulab.github.io/NetBID-dev/).

---

## Getting started

### Dependencies

R, version >= 3.4.0

NetBID2, version >= 0.1.1

### Quick start: install R package (NetBIDshiny)

- install the R package from github (not published yet)

```R
library(devtools)
install_github("jyyulab/NetBID_shiny",ref='master')
```

- OR, download the released source package from [NetBIDshiny_0.1.0.tar.gz](https://github.com/jyyulab/NetBID_shiny/releases/download/0.1.0/NetBIDshiny_0.1.0.tar.gz) and install locally

```R
install.packages('NetBIDshiny_0.1.0.tar.gz',repos=NULL)
```

### Initiate the NetBIDShiny web app

Call `run_NetBID_shiny()` to initiate the app.

```R
library(NetBIDshiny)
run_NetBID_shiny()
```

Then open a browser and enter local url address (e.g: http://127.0.0.1:XXXX).


### Online server

The public online version of NetBIDshiny can be found here [XXX](XXX). This doesn't require the local installation.

---

## Design manual

The manual of all the NetBID2 functions is linked here [NetBIDshiny_0.1.0.pdf](https://github.com/jyyulab/NetBID_shiny/blob/master/NetBIDshiny_0.1.0.pdf).

## Tutorial
 
We choose the demo dataset from GEO database as in NetBID2: [GSE116028](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE116028). 

Please check [Tutorial page](docs/tutorial) for more details.

---

## About the project

For the detailed description of NetBID algorithm, please check our lab page [View Yu Lab@St. Jude](https://stjuderesearch.org/site/lab/yu).

### License

Distributed by an MIT license.
