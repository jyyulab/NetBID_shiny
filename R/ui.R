library(shiny)
library(shinyjs)
library(shinythemes)
library(DT)
library(NetBID2)
library(shinyFiles)
library(fs)
library(V8)
library(zip)

jscode <- "shinyjs.refresh=function(){history.go(0);};"

ui_Vis <- fluidPage(
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
#
ui_MR <- fluidPage(
  #useShinyjs(),extendShinyjs(text = jscode,functions=c("refresh")),
  useShinyjs(),extendShinyjs(text = "shinyjs.refresh=function(){history.go(0);};",
                             functions = c("shinyjs.refresh")),
  theme = shinytheme("sandstone"),
  titlePanel('NetBID2 Runner: A Shiny server to run NetBID2 without coding'),
  HTML('<p>Tutorial: <a href="https://jyyulab.github.io/NetBID_shiny/docs/tutorial4runner" target="_">tutorial4runner</a></p>'),hr(),
  sidebarPanel(width=5,
               h3('Upload or choose the files for calculation'),shiny::hr(),
               h4('1. Upload the calculation dataset',style='text-align:left'),
               shiny::p('NOTE: For preparation, user could use functions such as load.exp.GEO(), load.exp.RNASeq.demoSalmon(), generate.eset() in NetBID2 to generate ExpressionSet class object and save into RData file!'),
               fileInput('eset_RData_file',label='choose RData file containing the ExpressionSet class object',accept=c('.Rds','.RData','.Rdata','.eset')),
               h4('OR choose the local calculation dataset file',style='text-align:left'),
               shinyFilesButton('choose_eset_RData_file', 'choose the RData file containing the ExpressionSet class object', 
                                'choose the RData file containing the ExpressionSet class object', FALSE),
               shiny::htmlOutput('filepaths_choose_eset_RData_file'),
               shiny::hr(),
               h4('2. Upload the network files from SJAracne output',style='text-align:left'),
               fileInput('tf_network_file',label='choose the TF network file',accept=c('.txt')),
               fileInput('sig_network_file',label='choose the SIG network file',accept=c('.txt')),
               h4('OR choose the local network files',style='text-align:left'),
               fluidRow(
                 column(4,offset=1,shinyFilesButton('choose_tf_network_file', 'choose the TF network file', 'choose the TF network file', FALSE)),
                 column(4,offset=1,shinyFilesButton('choose_sig_network_file', 'choose the SIG network file', 'choose the SIG network file', FALSE))
               ),
               fluidRow(
                 column(4,offset=1,shiny::htmlOutput('filepaths_tf_network_file')),
                 column(4,offset=1,shiny::htmlOutput('filepaths_sig_network_file'))
               ),
               shiny::hr(),
               h4('3. Click the button to upload the files'),
               actionButton('loadButton', 'Load the Data'),
               shiny::hr(),
               shiny::p('Click the load demo button to check the usage'),
               actionButton('loadDemoButton', 'Load the Demo Data',style="height:80%;font-size:80%;background:grey"),
               shiny::hr(),
               actionButton(inputId='initButton0',label='Refresh the app',style='width:100%;color:blue;background:white'),shiny::hr(),
               div(shiny::htmlOutput('error_message'),style="font-size:120%;color:red")
  ),
  mainPanel(width=7,
            h3('Select the options for the uploaded dataset',style='text-align:left'),
            div(shiny::htmlOutput('summaryProject')),shiny::hr(),
            div(shiny::htmlOutput('analysisOption')),
            div(shiny::htmlOutput('checkReturn')),
            div(shiny::htmlOutput('analysisReturn')),hr(),
            shiny::HTML("<p style='text-align:center'>\u00A9 2019 St. Jude Children\'s Research Hospital</p>
                        <p style='text-align:center'>Contact: <a href='https://stjuderesearch.org/site/lab/yu/contact',target='_'>YuLab</a> <a href='https://github.com/jyyulab/NetBID_shiny',target='_'>Github</a></p>
                        <p style='text-align:center'>Email: xinran.dong@stjude.org or xinran.dong@foxmail.com</p>")
            )
)


