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
  #useShinyjs(),extendShinyjs(text = jscode,functions=c("refresh")),
  useShinyjs(),extendShinyjs(text = "shinyjs.refresh=function(){history.go(0);};",
                             functions = c("shinyjs.refresh")),
  theme = shinytheme("sandstone"),
  titlePanel('NetBID2 Viewer: A Shiny app to visualize NetBID2 output'),
  HTML('<p>Tutorial: <a href="https://jyyulab.github.io/NetBID_shiny/docs/tutorial4viewer" target="_">tutorial4viewer</a></p>'),hr(),
  sidebarPanel(width=5,
               div(
                 h4('Current loaded dataset information',
                    style='text-align:left;text-decoration:underline;font-weight:700;'),
                 div(shiny::htmlOutput('summaryProject')),
                 style='padding:1%;margin:1%;background:#FFFFCC;'), shiny::hr(),
               div(shiny::htmlOutput('error_message'),style='color:red'),shiny::hr(),
               h4('Upload the dataset',style='text-align:left'),
               fileInput('ms_tab_RData_file',label='choose master table RData file',accept=c('.Rds','.RData','.Rdata')),
               h4('OR choose the local master table RData file',style='text-align:left'),
               shinyFilesButton('choose_ms_tab_RData_file', 'choose the master table RData file', 
                                'choose the RData file containing the master table', FALSE),
               shiny::htmlOutput('filepaths_choose_ms_tab_RData_file'),
               shiny::HTML("<p style='color:#8A0808;font-size:70%'>Note:The RData file must contain a list object <b>analysis.par</b> containing required elements (detailed check online tutorial)</p>"),
               shiny::hr(),
               div(shiny::htmlOutput('initial_para'),style='font-size:80%'),  shiny::hr(),
               actionButton('loadButton', 'Load/Reload the uploaded RData'),
               actionButton('loadDemoButton', 'Load/Reload the Demo Data',
                            style="height:80%;font-size:80%;background:grey"),
               shiny::hr(),
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
                        tabPanel("Target_Function_Enrich_Plot", div(shiny::htmlOutput("TargetFunctionEnrichPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Category_BoxPlot", div(shiny::htmlOutput("CategoryBoxPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("Driver_GSEA_Plot", div(shiny::htmlOutput("DriverGSEAPlot_para"),style = "font-size:80%;margin-top:2%")),
                        tabPanel("About", div(shiny::htmlOutput("about.ui"),style = "font-size:80%;margin-top:2%"))
            ),
            div(uiOutput("plot.ui")),
            div(shiny::htmlOutput('addtionalPerformance'))
  ),
  tags$style(type = 'text/css', 
             "footer{text-align:center;position: absolute; bottom:0; width:100%;padding:5px;z-index: 1000;}"
  )
)


