---
layout: default
title: NetBIDshiny
nav_order: 1
description: "NetBIDshiny"
permalink: /
---

      
# A shiny app for NetBID2 result analyze and visualization.
{: .fs-9 }

This is the documentation for the usage of NetBIDshiny.
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/jyyulab/NetBID_shiny){: .btn .fs-5 }

---

## Overview

NetBIDshiny is a shiny app for NetBID2 (data-driven context-specific network and Bayesian inference, version II) visualization functions.

Current newest version of NetBID is NetBID2, which could be found at [NetBID2](https://github.com/jyyulab/NetBID-dev) with online tutorial found at [NetBID2 tutorial](https://jyyulab.github.io/NetBID-dev/).

---

## Getting started

### Dependencies

R, version >= 3.4.0

NetBID2, version >= 0.1.1

### Quick start: install R packages (NetBIDshiny)

- install the R packages from github (not published yet)

```R
library(devtools)
install_github("jyyulab/NetBID_shiny",ref='master')
```

- OR, download the released source package from [NetBIDshiny_0.1.0.tar.gz](https://github.com/jyyulab/NetBID_shiny/releases/download/0.1.0/NetBIDshiny_0.1.0.tar.gz) and local install

```R
install.packages('NetBIDshiny_0.1.0.tar.gz',repos=NULL)
```

### Usage of NetBIDShiny

There is only one function in the package, directly call it and a local web server will be ready for use. 

```R
library(NetBIDshiny)
run_NetBID_shiny()
```

Then open a browser and enter local url address (e.g: http://127.0.0.1:XXXX).


### Online demo server

The online public version of NetBIDshiny could be found at [XXX](XXX). User could choose to use it without local install. 

---

## Design manual

The manual for all functions in NetBID2 could be obtained from [NetBIDshiny_0.1.0.pdf](https://github.com/jyyulab/NetBID_shiny/blob/master/NetBIDshiny_0.1.0.pdf).

## Tutorial
 
We choose the same demo dataset as NetBID2 from GEO database: [GSE116028](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE116028). 

Check [Tutorial page](docs/tutorial) for detail.

---

## About the project

For the detailed description of NetBID algorithm, please refer our lab page [View Yu Lab@St. Jude](https://stjuderesearch.org/site/lab/yu).

### License

Distributed by an MIT license.
