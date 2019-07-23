
#' @import shiny shinyjs shinythemes DT NetBID2

##############
library(shiny)
library(shinyjs)
library(NetBID2)
library(shinythemes)
library(DT)
library(shinyFiles)

options(shiny.maxRequestSize = 1000*1024^2)

#' @title \code{NetBIDshiny.run4Vis} is a function to run a shiny app for NetBID2 result visualization.
#' @description \code{NetBIDshiny.run4Vis} is a shiny app for NetBID2 result visualization. 
#' No option is required. 
#' User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage. 
#' @export
NetBIDshiny.run4Vis <- function(){
  shinyApp(ui = ui, server = server)
}

#' @title \code{NetBIDshiny.run4MR} is a function to run a shiny app for NetBID2 master regulator identification.
#' @description \code{NetBIDshiny.run4MR} is a shiny app for NetBID2 master regulator 
#' identification and the generation of figures for top drivers with the help of two lazy functions in NetBID2,
#' NetBID.lazyMode.DriverEstimation() and NetBID.lazyMode.DriverVisualization(). 
#' No option is required. 
#' User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage. 
#' @export
NetBIDshiny.run4MR <- function(){
  shinyApp(ui = ui_MR, server = server_MR)
}





