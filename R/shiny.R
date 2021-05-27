
#' @import shinyjs shinythemes NetBID2 shinyFiles fs zip
#' @importFrom DT dataTableOutput renderDataTable JS
#' @importFrom shiny shinyApp reactiveValues observeEvent reactive renderUI p htmlOutput HTML tagList fluidRow column selectInput textInput numericInput checkboxInput actionButton radioButtons checkboxGroupInput sliderInput renderPlot downloadHandler downloadButton div htmlOutput hr withProgress incProgress 

##############
library(shiny)
library(shinyjs)
library(shinythemes)
library(DT)
library(NetBID2)
library(shinyFiles)
library(fs)
library(V8)
library(zip)

loadjs<- function() {
  require(shinyjs)
  useShinyjs()
  extendShinyjs(text='shinyjs.refresh=function(){history.go(0);};',
                functions = c("shinyjs.refresh"))
}

#' @title \code{NetBIDshiny.run4Vis} is a function to run a shiny app for NetBID2 result visualization.
#' @description \code{NetBIDshiny.run4Vis} is a shiny app for NetBID2 result visualization. 
#' User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage. 
#'
#' @param load_data_path character, path for the pre-loaded data. If NULL, will pre-load the demo dataset.
#' @param search_path a vector of characters, path for master table Rdata searching in the app server. 
#' User could choose from: 'Current Directory','Home','R Installation','Available Volumes', 
#' and could put user-defined server path (better use absolute path).
#' Default is c('Current Directory','Home').
#' If set to NULL, only 'Current Directory' will be used.
#' @export
NetBIDshiny.run4Vis <- function(load_data_path=NULL,
                                search_path=c('Current Directory','Home')
                               ){
  options(shiny.maxRequestSize = 1000*1024^2)
  .GlobalEnv$search_path <- search_path
  if(exists('analysis.par',envir=.GlobalEnv)==TRUE) rm(analysis.par,envir=.GlobalEnv)
  out.dir.DATA.default <- system.file('demo1','driver/DATA/analysis.par.Step.ms-tab.RData',package = "NetBID2")
  if(is.null(load_data_path)==T) load_data_path <- out.dir.DATA.default
  if(!file.exists(load_data_path)){cat(sprintf('%s not exist!',load_data_path));return(NULL)}
  shinyOptions(out.dir.DATA=load_data_path)
  shiny::shinyApp(ui = ui_Vis, server = server_Vis,onStart=loadjs)
}

#' @title \code{NetBIDshiny.run4MR} is a function to run a shiny app for NetBID2 master regulator identification.
#' @description \code{NetBIDshiny.run4MR} is a shiny app for NetBID2 master regulator 
#' identification and the generation of figures for top drivers with the help of two lazy functions in NetBID2,
#' NetBID.lazyMode.DriverEstimation() and NetBID.lazyMode.DriverVisualization(). 
#' User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage. 
#'
#' @param search_network_path a vector of characters, path for network data searching in the app server. 
#' User could choose from: 'Current Directory','Home','R Installation','Available Volumes', 
#' and could put user-defined server path (better use absolute path).
#' Default is c('Current Directory','Home').
#' If set to NULL, only 'Current Directory' will be used.
#' @param search_eSet_path a vector of characters, path for expressionSet class RData searching in the app server. 
#' User could choose from: 'Current Directory','Home','R Installation','Available Volumes', 
#' and could put user-defined server path (better use absolute path).
#' Default is c('Current Directory','Home').
#' If set to NULL, only 'Current Directory' will be used.
#' @param project_main_dir character, absolute path of the main working directory for driver analysis.
#' If NULL, the server will add a new button for user to select the output directory. Default is NULL.
#' If not NULL, there will be an additional link in the result page for downloading the zip file containing all information.
#' @export
NetBIDshiny.run4MR <- function(search_network_path=c('Current Directory','Home'),
                               search_eSet_path=c('Current Directory','Home'),
                               project_main_dir=NULL){
  options(shiny.maxRequestSize = 1000*1024^2)
  .GlobalEnv$search_network_path <- search_network_path
  .GlobalEnv$search_eSet_path <- search_eSet_path
  .GlobalEnv$pre_project_main_dir <- project_main_dir
  if(exists('analysis.par',envir=.GlobalEnv)==TRUE) rm(analysis.par,envir=.GlobalEnv)
  use_dir <- system.file('',package = "NetBIDshiny")
  tf_network_file.default <- sprintf('%s/demo1_human/human_MB.TF_consensus_network_ncol_.txt',use_dir)
  sig_network_file.default <- sprintf('%s/demo1_human/human_MB.SIG_consensus_network_ncol_.txt',use_dir)
  eset_demo_path.default <- sprintf('%s/demo1_human/demo_human_MB_eset.RData',use_dir)
  eset_path <- eset_demo_path.default
  tf_network_file_path <- tf_network_file.default
  sig_network_file_path <- sig_network_file.default
  shinyOptions(eset_demo_path=eset_path,tf_network_file=tf_network_file_path,sig_network_file=sig_network_file_path)
  shiny::shinyApp(ui = ui_MR, server = server_MR,onStart=loadjs)
}


