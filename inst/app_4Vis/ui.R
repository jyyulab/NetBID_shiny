##
library(shiny)
library(shinyjs)
library(shinythemes)
library(DT)
library(shinyFiles)
library(fs)
library(V8)
library(zip)

ui <- fluidPage(
  #useShinyjs(),extendShinyjs(text = jscode),
  theme = shinytheme("sandstone"),
  titlePanel('NetBIDShiny for result visualization'),
  sidebarPanel(width=5,
               h4('Upload the dataset',style='text-align:left'),
               fileInput('ms_tab_RData_file',label='choose master table RData file',accept=c('.Rds','.RData','.Rdata')),
               h4('OR choose the local master table RData file',style='text-align:left'),
               shinyFilesButton('choose_ms_tab_RData_file', 'choose the master table RData file', 
                                'choose the RData file containing the master table', FALSE),
               shiny::htmlOutput('filepaths_choose_ms_tab_RData_file'),
               div(shiny::htmlOutput('summaryProject')),  shiny::hr(),
               div(shiny::htmlOutput('initial_para'),style='font-size:80%'),  shiny::hr(),
               fluidRow(
                 column(4,offset=1,actionButton('loadButton', 'Load/Reload the uploaded RData')),
                 column(4,offset=1,actionButton('loadDemoButton', 'Load/Reload the Demo RData'))
               ),
               shiny::hr(),
               div(shiny::htmlOutput('error_message'),style='color:red'),
               div(uiOutput("masterTable.ui")),
               div(fluidRow(column(12,div(DT::dataTableOutput("ms_table"), style = "font-size:70%")))),shiny::hr(),
               actionButton(inputId='initButton0',label='Refresh the app',style='width:100%;color:blue;background:white')
  ),
  mainPanel(width=7,
            h4('Choose plot type and input parameters',style='text-align:left'),
            tabsetPanel(type = "tabs",selected='Volcano_Plot',
                        tabPanel("Volcano_Plot", div(shiny::htmlOutput("VolcanoPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("NetBID_Plot", div(shiny::htmlOutput("NetBIDPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("GSEA_Plot", div(shiny::htmlOutput("GSEAPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Heatmap", div(shiny::htmlOutput("Heatmap_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Function_Enrich_Plot", div(shiny::htmlOutput("FunctionEnrichPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Bubble_Plot", div(shiny::htmlOutput("BubblePlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Target_Net", div(shiny::htmlOutput("TargetNetPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Category_BoxPlot", div(shiny::htmlOutput("CategoryBoxPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("About", div(shiny::htmlOutput("about.ui"),style = "font-size:80%;margin-top:2%"))
            ),
            div(uiOutput("plot.ui")),
            div(shiny::htmlOutput('addtionalPerformance'))
  ),
  tags$style(type = 'text/css', 
             "footer{text-align:center;position: absolute; bottom:0; width:100%;padding:5px;z-index: 1000;}"
  )
)


