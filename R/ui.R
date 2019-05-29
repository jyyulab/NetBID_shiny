library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel('NetBID2_Shiny(Visualization)'),
  sidebarPanel(width=5,
           fileInput('ms_tab_RData_file',label='choose master table RData file',accept=c('.Rds','.RData','.Rdata')),
           div(htmlOutput('summaryProject')),  hr(),
           div(htmlOutput('initial_para'),style='font-size:80%'),  hr(),
           fluidRow(
             column(5,offset=1,actionButton('loadButton', 'Load/Reload the uploaded RData')),
             column(5,offset=1,actionButton('loadDemoButton', 'Load/Reload the Demo RData'))
           ),
           hr(),
           div(htmlOutput('error_message'),style='font-color:red'),
           hr(),
           div(fluidRow(column(12,div(DT::dataTableOutput("ms_table"), style = "font-size:50%"))))
  ),
  mainPanel(width=7,
      h4('Choose plot type and input parameters',style='text-align:left'),
      tabsetPanel(type = "tabs",
                         tabPanel("Volcano_Plot", div(htmlOutput("VolcanoPlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("NetBID_Plot", div(htmlOutput("NetBIDPlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("GSEA_Plot", div(htmlOutput("GSEAPlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("Heatmap", div(htmlOutput("Heatmap_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("Function_Enrich_Plot", div(htmlOutput("FunctionEnrichPlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("Bubble_Plot", div(htmlOutput("BubblePlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("Target_Net", div(htmlOutput("TargetNetPlot_para"),style = "font-size:80%;margin-top:2%")),
                         tabPanel("Category_BoxPlot", div(htmlOutput("CategoryBoxPlot_para"),style = "font-size:80%;margin-top:2%"))
                       ),
      hr(),
      h4('Modify Plot',style='text-align:left'),
      div(uiOutput("plot.ui")),
      hr(),
      div(htmlOutput('addtionalPerformance'))
  )
)
#

