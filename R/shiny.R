
#' @import shiny shinyjs shinythemes DT NetBID2

##############
library(shiny)
library(shinyjs)
library(NetBID2)
library(shinythemes)
library(DT)


#' @title \code{run_NetBID_shiny} is a function to run a shiny app for NetBID2 result visualization.
#' @description \code{run_NetBID_shiny} is a shiny app for NetBID2 result visualization. No option is required. 
#' User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage. 
#' @export
run_NetBID_shiny <- function(){
  shinyApp(ui = ui, server = server)
}