
library(shinyjs)
library(NetBID2)
library(shinyFiles)
library(fs)
library(V8)

options(shiny.maxRequestSize = 1000*1024^2) ##
jscode <- "shinyjs.refresh = function() { history.go(0); }"

server <- function(input, output) {
  ################
  use_data <- reactiveValues(ori_ms_tab=NULL,ms_tab=NULL,tmp_ms_tab=NULL,use_para='',basic_info='',
                             project.name=NULL,main.dir=NULL,
                             cal.eset=NULL,merge.ac.eset=NULL,merge.network=NULL,DE=NULL,DA=NULL,
                             transfer_tab=NULL, all_gs2gene=NULL, all_gs2gene_info=NULL,
                             all_comp=NULL,choose_comp=NULL,plot_height=500,plot_width=800) ## global variables
  control_para <- reactiveValues(doloadData = FALSE, doplot=FALSE) ## control parameters
  ################
  observeEvent(input$loadButton, { control_para$doloadData <- 'doinitialload'; use_data$choose_comp <- NULL; control_para$doplot=FALSE; use_data$use_para <- ''; use_data$ms_tab <- use_data$ori_ms_tab;})
  observeEvent(input$loadDemoButton, { control_para$doloadData <- 'doinitialdemoload'; use_data$choose_comp <- NULL; control_para$doplot=FALSE; use_data$use_para <- ''; use_data$ms_tab <- use_data$ori_ms_tab;})
  observeEvent(input$initButton0, { js$refresh();control_para$doloadData <- FALSE; control_para$doplot <- FALSE;})
  observeEvent(input$doupdateMsTab, {
    control_para$doloadData <- 'doupdateMsTab';
    use_data$ms_tab <- use_data$tmp_ms_tab;
    use_data$use_para <- sprintf('<b>Filter</b>: <br> min_Size:%s,max_Size:%s<br>Focus on <b>%s</b><br>logFC_col:%s,logFC_thre:%s<br>Pv_col:%s,Pv_thre:%s',
                                 input$min_Size,input$max_Size,input$choose_comp,input$logFC_col,input$logFC_thre,input$Pv_col,input$Pv_thre);
    control_para$doplot <- FALSE;
    control_para$doloadData <- TRUE;
  })
  #
  observeEvent(input$doVolcalnoPlot, {control_para$doplot <- 'doVolcalnoPlot'}) #1
  observeEvent(input$doHeatmap, {control_para$doplot <- 'doHeatmap'}) #2
  observeEvent(input$doCategoryBoxPlot, {control_para$doplot <- 'doCategoryBoxPlot'}) #3
  observeEvent(input$doTargetNetPlot, {control_para$doplot <- 'doTargetNetPlot'}) #4
  observeEvent(input$doGSEAPlot, {control_para$doplot <- 'doGSEAPlot'}) #5
  observeEvent(input$doFunctionEnrichPlot, {control_para$doplot <- 'doFunctionEnrichPlot'}) #6
  observeEvent(input$doBubblePlot, {control_para$doplot <- 'doBubblePlot'}) #7
  observeEvent(input$doNetBIDPlot, {control_para$doplot <- 'doNetBIDPlot'}) #8

  ################
  # functions
  get_top_ms_tab <- function(ms_tab,top_strategy,top_num,z_col){
    top_num <- as.numeric(top_num)
    if(top_num<nrow(ms_tab)){
      tmp_ms_tab <- ms_tab
      tmp_ms_tab_up <- tmp_ms_tab[which(tmp_ms_tab[,z_col]>0),]
      tmp_ms_tab_down <- tmp_ms_tab[which(tmp_ms_tab[,z_col]<0),]
      tmp_ms_tab <- tmp_ms_tab[order(abs(tmp_ms_tab[,z_col]),decreasing=TRUE),]
      tmp_ms_tab_up <- tmp_ms_tab_up[order(tmp_ms_tab_up[,z_col],decreasing=TRUE),]
      tmp_ms_tab_down <- tmp_ms_tab_down[order(tmp_ms_tab_down[,z_col],decreasing=FALSE),]
      if(top_strategy=='Both') ms_tab <- tmp_ms_tab[1:min(top_num,nrow(tmp_ms_tab)),]
      if(top_strategy=='UP') ms_tab <- tmp_ms_tab_up[1:min(top_num,nrow(tmp_ms_tab_up)),]
      if(top_strategy=='DOWN') ms_tab <- tmp_ms_tab_down[1:min(top_num,nrow(tmp_ms_tab_down)),]
    }
    return(ms_tab)
  }
  ################
  # load the data
  loadData <- reactive({
    inFile <- input$ms_tab_RData_file
    print(inFile$datapath)
    if(is.null(inFile$datapath)==TRUE) {
      control_para$doloadData <- FALSE;
      output$error_message <- renderUI({p('WARNING : No input data, please check and re-try!')})
      return()
    }
    output$error_message <- renderUI({p('')})
    load(inFile$datapath)
    ms_tab <- analysis.par$final_ms_tab
    col_class <- unlist(lapply(ms_tab,class))
    w1 <- which(col_class=='numeric')
    for(i in w1) ms_tab[,i] <- signif(ms_tab[,i],digits=3)
    use_data$project.name <- analysis.par$project.name
    use_data$main.dir <- analysis.par$main.dir
    use_data$ms_tab <- ms_tab
    use_data$ori_ms_tab <- ms_tab
    use_data$cal.eset <- analysis.par$cal.eset
    use_data$merge.ac.eset <- analysis.par$merge.ac.eset
    use_data$merge.network <- analysis.par$merge.network$target_list
    use_data$DE <- analysis.par$DE
    use_data$DA <- analysis.par$DA
    all_comp <- colnames(ms_tab)[grep('Z.',colnames(ms_tab))]
    all_comp <- unique(gsub('Z.(.*)','\\1',all_comp))
    use_data$all_comp <- all_comp
    use_data$choose_comp <- NULL
    print('Finish loading the dataset')
    if('transfer_tab' %in% names(analysis.par)) use_data$transfer_tab <- analysis.par$transfer_tab
  })
  # load in demo data
  loadDemoData <- reactive({
    analysis.par <- list()
    analysis.par$out.dir.DATA <- system.file('demo1','driver/DATA/',package = "NetBID2")
    load(sprintf('%s/analysis.par.Step.ms-tab.RData',analysis.par$out.dir.DATA))
    ms_tab <- analysis.par$final_ms_tab
    col_class <- unlist(lapply(ms_tab,class))
    w1 <- which(col_class=='numeric')
    for(i in w1) ms_tab[,i] <- signif(ms_tab[,i],digits=3)
    use_data$project.name <- analysis.par$project.name
    use_data$main.dir <- analysis.par$main.dir
    use_data$ms_tab <- ms_tab
    use_data$ori_ms_tab <- ms_tab
    use_data$cal.eset <- analysis.par$cal.eset
    use_data$merge.ac.eset <- analysis.par$merge.ac.eset
    use_data$merge.network <- analysis.par$merge.network$target_list
    use_data$DA <- analysis.par$DA
    use_data$DE <- analysis.par$DE
    all_comp <- colnames(ms_tab)[grep('Z.',colnames(ms_tab))]
    all_comp <- unique(gsub('Z.(.*)','\\1',all_comp))
    use_data$all_comp <- all_comp
    use_data$choose_comp <- NULL
    if('transfer_tab' %in% names(analysis.par)) use_data$transfer_tab <- analysis.par$transfer_tab
  })
  # summary
  output$summaryProject<-renderUI({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doloadData=='doinitialload') loadData()
    if(control_para$doloadData=='doinitialdemoload') loadDemoData()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    mess <- sprintf('<b>NOTE</b>: <br>* The project name is <b>%s</b> with the main directory in %s; <br>* %s;
                     <br>%s<br>
                     * In total <b>%d</b> TF and <b>%d</b> SIG. <br> %d comparisons are found in the master table: %s ',
                     use_data$project.name,use_data$main.dir,use_data$basic_info,use_data$use_para,
                     table(ms_tab$funcType)['TF'],table(ms_tab$funcType)['SIG'],
                     length(all_comp),paste(all_comp,collapse=' ;'))
    HTML(mess)
  })
  #
  output$initial_para <- renderUI({
   # if(control_para$doloadData==FALSE) return()
    all_id_type <- c('external_gene_name','ensembl_gene_id','ensembl_gene_id_version','ensembl_transcript_id','ensembl_transcript_id_version',
                     'refseq_mrna','hgnc_symbol','entrezgene','ucsc','uniprotswissprot','other')
    use_spe <- 'Homo sapiens'
    use_level <- 'gene'
    from_type <- 'external_gene_name'
    if(use_data$basic_info != ''){
      use_spe   <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\1',use_data$basic_info)
      use_level <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\2',use_data$basic_info)
      from_type <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\3',use_data$basic_info)
    }
    tagList(
    fluidRow(
      column(6,offset=0,selectInput(inputId='use_spe',label='Choose the species',choices=msigdbr_show_species(),selected = use_spe)),
      column(6,offset=0,selectInput(inputId='use_level',label='Choose the gene/transcript level',choices=c('gene','transcript'),selected = use_level))
    ),
    fluidRow(
      column(6,offset=0,selectInput(inputId='choose_main_id_type',label='Choose the main id type',choices=all_id_type,selected =from_type)),
      column(6,offset=0,textInput(inputId='other_main_id_type',label='Input the main id type (if choose other, name need to be found in biomaRT)', value = ''))
    )
    )
  })
  # error message
  output$error_message <- renderUI({
    if(is.null(use_data$transfer_tab)==FALSE){
      if(nrow(use_data$transfer_tab)==0){
        p('WARNING : Wrong input parameters for species or level or main id type, plsease check !')
      }
    }
  })
  output$plotWarnning <- renderUI({
    if(control_para$doplot=='doVolcalnoPlot'){ # 1
      choose_comp <- use_data$choose_comp
      all_col   <- colnames(use_data$ms_tab)
      all_logFC <- all_col[grep('logFC',all_col,ignore.case=TRUE)]
      all_Pv <- all_col[grep('P.Val',all_col,ignore.case=TRUE)]
      if(is.null(choose_comp)==TRUE) return()
      use_Fc <- all_logFC[grep(choose_comp,all_logFC,ignore.case=TRUE)]
      use_Pv <- all_Pv[grep(choose_comp,all_Pv,ignore.case=TRUE)]
      if(!input$logFC_col %in% use_Fc | !input$Pv_col %in% use_Pv){
        p('WARNING : logFC or P-value column does not match the comparison, please check !')
      }
    }
  })
  ################
  # master table display
  output$ms_table <- DT::renderDataTable({
    if(control_para$doloadData==FALSE) return()
    if(is.null(use_data$project.name)==TRUE) return()
    if(control_para$doloadData=='doupdateMsTab'){
      use_data$ms_tab <- use_data$tmp_ms_tab
      control_para$doloadData <- TRUE
    }
    if(control_para$doloadData=='doinitialload' | control_para$doloadData=='doinitialdemoload'){
      use_spe=input$use_spe;use_level=input$use_level;ori_from_type=input$choose_main_id_type;
      print(use_data$basic_info)
      if(use_data$basic_info != ''){
        use_spe   <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\1',use_data$basic_info)
        use_level <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\2',use_data$basic_info)
        ori_from_type <- gsub('Choose species:(.*); analysis level:(.*); main id type:(.*)','\\3',use_data$basic_info)
      }
      if(is.null(use_data$all_gs2gene)==TRUE | input$use_spe != use_spe){
        gs.preload(use_spe=input$use_spe)
        use_data$all_gs2gene <- all_gs2gene
        use_data$all_gs2gene_info <- all_gs2gene_info
      }
      from_type <- input$choose_main_id_type
      if(from_type=='other') from_type <- input$other_main_id_type
      if(is.null(use_data$transfer_tab)==TRUE | input$use_level != use_level | from_type!=ori_from_type){
        use_genes <- unique(unlist(lapply(use_data$merge.network,function(x)x$target)))
        print(str(use_genes))
        print('Original RData do not contain gene ID transfer table, the program will automatically generate it, please wait !')
        db.preload(use_spe=input$use_spe,use_level=input$use_level)
        transfer_tab <- get_IDtransfer2symbol2type(from_type = from_type,use_genes=use_genes,use_level=input$use_level) ## get transfer table !!!
        use_data$transfer_tab <- transfer_tab
      }
      use_data$ms_tab <- use_data$ori_ms_tab
      use_data$basic_info <- sprintf('Choose species:%s; analysis level:%s; main id type:%s',input$use_spe,input$use_level, from_type)
      use_data$use_para <- ''
      control_para$doloadData <- TRUE
    }
    use_data$ms_tab
  },rownames=FALSE,extensions = c('FixedColumns',"FixedHeader"),
     options = list(
     scrollX = TRUE,fixedColumns=list(leftColumns=4),
     columnDefs = list(list(className = 'dt-center')),
     filter='top',
     pageLength = 5)
    )
  ################
  # draw options
  # 1
  output$VolcanoPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    #control_para$doplot <- FALSE    
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    if(is.null(all_comp)==TRUE) return()
    all_col   <- colnames(ms_tab)
    all_logFC <- all_col[grep('logFC',all_col,ignore.case=TRUE)]
    all_Pv <- all_col[grep('P.Val',all_col,ignore.case=TRUE)]
    if(is.null(use_data$choose_comp)==TRUE){
      choose_comp <- all_comp[1]
    }else{
      choose_comp <- use_data$choose_comp
    }
    use_Fc <- all_logFC[grep(choose_comp,all_logFC,ignore.case=TRUE)[1]]
    use_Pv <- all_Pv[grep(choose_comp,all_Pv,ignore.case=TRUE)[1]]
    fluidRow(
        column(7,offset=0,tagList(
          fluidRow(
            column(8,offset=0,selectInput(inputId='choose_comp',label='choose the comparison want to focus in the following studies',choices=all_comp,selected = choose_comp)),
            column(4,offset=0,selectInput(inputId='label_col1',label='choose column to display',choices=colnames(ms_tab)[1:4],selected=colnames(ms_tab)[1]))
            ),
          fluidRow(
            column(8,offset=0,selectInput(inputId='logFC_col',label='choose logFC column',choices=all_logFC,selected = use_Fc)),
            column(4,offset=0,numericInput(inputId='logFC_thre',label='input logFC threshold',value=0.2,min=0,max=Inf))
          ),
          fluidRow(
            column(8,offset=0,selectInput(inputId='Pv_col',label='choose P-value column',choices=all_Pv,selected = use_Pv)),
            column(4,offset=0,numericInput(inputId='Pv_thre',label='input P-value threshold',value=0.1,min=0,max=1))
          )
        )),
        column(5,offset=0,tagList(
          fluidRow(
            column(6,offset=0,numericInput(inputId='min_Size',label='minimum target size for the driver',value=30,min=1,max=Inf,step=1)),
            column(6,offset=0,numericInput(inputId='max_Size',label='maximum target size for the driver',value=1000,min=1,max=Inf,step=1))
          ),
          fluidRow(
            column(10,offset=2,checkboxInput(inputId='show_label',label='Display significant items on plot?',value = FALSE))
          ),
          fluidRow(
            column(10,offset=2,actionButton(inputId='doVolcalnoPlot',label='Draw Volcano Plot'))
          )
        ))
    )
  })
  # 2
  output$Heatmap_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    control_para$doplot <- FALSE    
    ms_tab <- use_data$ms_tab
    cal.eset <- use_data$cal.eset
    all_choose <- c('Activity for top drivers in the master table','Expression for top drivers in the master table')
    all_phe <- get_int_group(use_data$cal.eset)
    phe <- pData(use_data$cal.eset)
    target_phe <- sapply(phe[,all_phe],function(x){sum(unlist(lapply(x,function(x1)grep(x1,use_data$choose_comp))))})
    all_phe <- all_phe[order(target_phe,decreasing = TRUE)]
    all_cluster <- c('pearson','spearman','euclidean','maximum','manhattan','canberra','binary','minkowski','kendall')
    tagList(
      p(sprintf('You are focusing on %s',use_data$choose_comp)),
      fluidRow(
        column(3,tagList(
          fluidRow(column(12,offset=0,radioButtons(inputId='draw_category',label='choose what to display',choices=all_choose,selected = all_choose[1]))),
          fluidRow(column(12,offset=0,checkboxGroupInput(inputId='use_phe2',label='choose sample feature to display',choices=all_phe,selected =all_phe[1])))
        )),
        column(3,offset=0,tagList(
          fluidRow(column(6,offset=0,checkboxInput(inputId='cluster_rows',label='cluster genes/drivers?',value = TRUE)),
                   column(6,offset=0,checkboxInput(inputId='cluster_columns',label='cluster samples?',value = TRUE))),
          fluidRow(column(6,offset=0,selectInput(inputId='clustering_distance_rows',label='strategy to cluster rows?',choices=all_cluster,selected=all_cluster[1])),
                   column(6,offset=0,selectInput(inputId='clustering_distance_columns',label='strategy to cluster columns?',choices=all_cluster,selected=all_cluster[1]))),
          fluidRow(column(6,offset=0,checkboxInput(inputId='show_row_names',label='display gene/driver name on the plot?',value = FALSE)),
                   column(6,offset=0,checkboxInput(inputId='show_column_names',label='display sample name on the plot?',value = FALSE)))
        )),
        column(5,offset=1,tagList(
          fluidRow(column(4,offset=0,radioButtons(inputId='top_strategy2',label='choose the top strategy for selection',choiceValues=c('UP','DOWN','Both'),
                                                  choiceNames=c('Up(Z-statistics>0)','Down(Z-statistics<0)','Both'),selected = 'Both')),
                   column(4,offset=0,numericInput(inputId='top_num2',label='number of top driver number (order by Z-statistics)',value=30,
                                                  min=0,max=Inf,step=1)),
                   column(4,offset=0,radioButtons(inputId='scale',label='Scale by ?',choices=c('none','row','column'),selected = 'none'))),
          fluidRow(column(4,offset=0,selectInput(inputId='label_col2',label='choose column to display name for the driver',choices=colnames(ms_tab)[1:4],selected=colnames(ms_tab)[1])),
                   column(6,offset=2,actionButton(inputId='doHeatmap',label='Draw Heatmap')))
        )
        ))
    )
  })
  # 3
  output$CategoryBoxPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    control_para$doplot <- FALSE    
    ms_tab <- use_data$ms_tab
    all_phe <- get_int_group(use_data$cal.eset)
    phe <- pData(use_data$cal.eset)
    target_phe <- sapply(phe[,all_phe],function(x){sum(unlist(lapply(x,function(x1)grep(x1,use_data$choose_comp))))})
    all_phe <- all_phe[order(target_phe,decreasing = TRUE)]
    all_driver <- ms_tab$originalID_label ## unique!!!
    tagList(
      fluidRow(column(4,offset=0,selectInput(inputId='choose_driver3',label='choose the driver to plot',choices=all_driver,selected = all_driver[1])),
               column(4,offset=0,checkboxGroupInput(inputId='use_phe3',label='choose sample feature to display',choices=all_phe,selected =all_phe[1])),
               column(4,offset=0,actionButton(inputId='doCategoryBoxPlot',label='Draw Category Box-Plot'))
      )
    )
  })
  # 4
  output$TargetNetPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    control_para$doplot <- FALSE    
    ms_tab <- use_data$ms_tab
    all_driver <- ms_tab$originalID_label ## unique!!!
    tagList(
      fluidRow(
               column(4,offset=0,selectInput(inputId='choose_driver4',label='choose the driver to plot',choices=all_driver,selected = all_driver[1])),
               column(4,offset=0,selectInput(inputId='label_col4',label='choose column to display',choices=colnames(ms_tab)[1:4],selected=colnames(ms_tab)[1])),
               column(4,offset=0,selectInput(inputId='choose_driver4_2',label='choose the second driver to plot (optinal)',choices=all_driver,selected = all_driver[1]))
      ),
      fluidRow(
               column(3,offset=0,checkboxInput(inputId='use_gene_symbol4',label='Display gene symbol',value = FALSE)),
               column(3,offset=0,checkboxInput(inputId='use_protein_coding4',label='Only Display protein coding genes/transcripts',value = FALSE)),
               column(3,offset=0,checkboxInput(inputId='alphabetical_order',label='alphabetical_order',value = FALSE)),
               column(3,offset=0,actionButton(inputId='doTargetNetPlot',label='Draw TargetNet Plot'))
      ),
      p('NOTE: Only accepet originalID_label for its uniqueness, please search the the box in the left to get the label !')
    )
  })
  #5
  output$GSEAPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    control_para$doplot <- FALSE    
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    uc <- gsub('(.*)_DA','\\1',use_data$choose_comp)
    uc <- gsub('(.*)_DE','\\1',uc)
    all_p_col <- intersect(colnames(use_data$DE[[uc]]),c('t','logFC','Z-statistics'))
    tagList(
      p(sprintf('You are focusing on %s',use_data$choose_comp)),
      fluidRow(
        column(2,offset=0,selectInput(inputId='profile_col5',label='choose profile to plot',choices=all_p_col,selected = all_p_col[1])),
        column(2,offset=0,selectInput(inputId='profile_trend',label='choose profile trend',choices=c('pos2neg','neg2pos'),selected='pos2neg')),
        column(2,offset=0,selectInput(inputId='target_nrow',label='choose number of target row to display',choices=c(1,2),selected=2)),
        column(2,offset=0,selectInput(inputId='target_col',label='choose whether to use color to display target',choices=c('RdBu','black'),selected='RdBu')),
        column(2,offset=0,selectInput(inputId='target_col_type',label='choose color strategy to display target',choices=c('PN','DE'),selected='PN')),
        column(2,offset=0,numericInput(inputId='profile_sig_thre',label='Threshold for significance (only applied for DE)',value=0,min=0))
        ),
      fluidRow(
        column(2,offset=0,numericInput(inputId='Z_sig_thre',label='Threshold for Z statistics to display color for top drivers',value=1.64,min=0,max=NA)),
        column(2,offset=0,radioButtons(inputId='top_strategy5',label='choose the top strategy for selection',choiceValues=c('UP','DOWN','Both'),
                                       choiceNames=c('Up(Z-statistics>0)','Down(Z-statistics<0)','Both'),selected = 'Both')),
        column(2,offset=0,numericInput(inputId='top_num5',label='number of top driver number (order by Z-statistics)',value=30,step=1,min=0,max=Inf)),
        column(2,offset=0,selectInput(inputId='label_col5',label='choose column to display',choices=colnames(ms_tab)[1:4],selected=colnames(ms_tab)[1])),
        column(4,offset=0,actionButton(inputId='doGSEAPlot',label='Draw GSEA Plot'))
      ),
      p("NOTE:
        1. Two options in 'choose target row color strategy','PN' or 'DE'.
        If set as 'PN', the positive regulated genes will be colored in red and negative regulated genes in blue.
        If set as 'DE', the color for the target genes is set according to its value in the differentiated expression profile.
        2. Two options in 'choose whether to use color to display target','black' or 'RdBu'.
        If set to 'black', the lines will be colored in black.
        If set to 'RdBu', the lines will be colored into Red to Blue color bar.
        If 'target row color strategy' is set as 'PN', the positive regulated genes will be colored in red and negative regulated genes in blue.
        If 'target row color strategy' is set as 'DE', the color for the target genes is set according to its value in the differentiated expression profile,
         with significant high set for red and low for blue. The significant threshold is set by profile_sig_thre.
         !")
    )
  })
  #6
  output$FunctionEnrichPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    control_para$doplot <- FALSE    
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    use_gs1 <- unique(cbind(all_gs2gene_info$Category,all_gs2gene_info$Category_Info))
    use_gs2 <- unique(cbind(all_gs2gene_info$`Sub-Category`,all_gs2gene_info$`Sub-Category_Info`))[-1,]
    use_gs1[,2] <- paste(use_gs1[,1],use_gs1[,2],sep=':')
    use_gs2[,2] <- paste(use_gs2[,1],use_gs2[,2],sep=':')
    tagList(
      p(sprintf('You are focusing on %s',use_data$choose_comp)),
      fluidRow(
        column(2,offset=0,checkboxGroupInput(inputId='use_gs1_6',label='choose Category to analyze',choiceNames=use_gs1[,2],choiceValues=use_gs1[,1],selected ='H')),
        column(3,offset=0,checkboxGroupInput(inputId='use_gs2_6',label='choose Sub-Category to analyze',choiceNames=use_gs2[,2],choiceValues=use_gs2[,1],
                                             selected =c('CP:BIOCARTA','CP:REACTOME','CP:KEGG'))),
        column(7,offset=0,tagList(
          fluidRow(column(3,offset=0,numericInput(inputId='min_gs_size6',label='minimum gene set size to analyze',value=5,min=0,max=NA)),
                   column(3,offset=0,numericInput(inputId='max_gs_size6',label='maximum gene set size to analyze',value=300,min=0,max=NA)),
                   column(3,offset=0,selectInput(inputId='Pv_adj6',label='P value adjusted strategy',
                                                 choices=c("fdr","BH","none","holm","hochberg","hommel", "bonferroni","BY"),selected='none')),
                   column(3,offset=0,numericInput(inputId='Pv_thre6',label='P value threshold',value=0.1,min=0,max=1))
                   ),
          fluidRow(
            column(3,offset=0,radioButtons(inputId='top_strategy6',label='choose the top strategy for selection',choiceValues=c('UP','DOWN','Both'),
                                           choiceNames=c('Up(Z-statistics>0)','Down(Z-statistics<0)','Both'),selected = 'Both')),
            column(3,offset=0,numericInput(inputId='top_num6',label='number of top driver number (order by Z-statistics)',value=300,step=1,min=0,max=Inf)),
            column(3,offset=0,numericInput(inputId='top_gs_num6',label='number of top gene set number (order by p-value)',value=30,step=1,min=0,max=Inf)),
            column(3,offset=0,numericInput(inputId='h6',label='threshold for cluster',value=0.9,step=0.01,min=0,max=1))
          ),
          fluidRow(
            column(3,offset=0,checkboxInput(inputId='cluster_gs',label='whether or not to cluster gene sets',value = TRUE)),
            column(3,offset=0,checkboxInput(inputId='cluster_gene',label='whether or not to cluster genes gene symbol',value = TRUE)),
            column(6,offset=0,actionButton(inputId='doFunctionEnrichPlot',label='Draw FunctionEnrich Plot'))
          )
        ))),
      p("")
      )
  })
  #7
  output$BubblePlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    control_para$doplot <- FALSE    
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    use_gs1 <- unique(cbind(all_gs2gene_info$Category,all_gs2gene_info$Category_Info))
    use_gs2 <- unique(cbind(all_gs2gene_info$`Sub-Category`,all_gs2gene_info$`Sub-Category_Info`))[-1,]
    use_gs1[,2] <- paste(use_gs1[,1],use_gs1[,2],sep=':')
    use_gs2[,2] <- paste(use_gs2[,1],use_gs2[,2],sep=':')
    tagList(
      p(sprintf('You are focusing on %s',use_data$choose_comp)),
      fluidRow(
        column(2,offset=0,checkboxGroupInput(inputId='use_gs1_7',label='choose Category to analyze',choiceNames=use_gs1[,2],choiceValues=use_gs1[,1],selected ='H')),
        column(3,offset=0,checkboxGroupInput(inputId='use_gs2_7',label='choose Sub-Category to analyze',choiceNames=use_gs2[,2],choiceValues=use_gs2[,1],
                                             selected =c('CP:BIOCARTA','CP:REACTOME','CP:KEGG'))),
        column(7,offset=0,tagList(
          fluidRow(column(3,offset=0,numericInput(inputId='min_gs_size7',label='minimum gene set size to analyze',value=5,min=0,max=NA)),
                   column(3,offset=0,numericInput(inputId='max_gs_size7',label='maximum gene set size to analyze',value=300,min=0,max=NA)),
                   column(3,offset=0,selectInput(inputId='Pv_adj7',label='P value adjusted strategy',
                                                 choices=c("fdr","BH","none","holm","hochberg","hommel", "bonferroni","BY"),selected='none')),
                   column(3,offset=0,numericInput(inputId='Pv_thre7',label='P value threshold',value=0.1,min=0,max=1))
          ),
          fluidRow(
            column(4,offset=0,radioButtons(inputId='top_strategy7',label='choose the top strategy for selection',choiceValues=c('UP','DOWN','Both'),
                                           choiceNames=c('Up(Z-statistics>0)','Down(Z-statistics<0)','Both'),selected = 'Both')),
            column(4,offset=0,numericInput(inputId='top_num7',label='number of top driver number (order by Z-statistics)',value=10,step=1,min=0,max=Inf)),
            column(4,offset=0,numericInput(inputId='top_geneset_number',label='number of top gene set number (order by p-value)',value=30,step=1,min=0,max=Inf))
          ),
          fluidRow(
            column(4,offset=0,selectInput(inputId='label_col7',label='choose column to display',choices=colnames(ms_tab)[1:4],selected=colnames(ms_tab)[1])),
            column(6,offset=2,actionButton(inputId='doBubblePlot',label='Draw Bubble Plot'))
          )
        ))),
      p("NOTE: bubble plot will generate large size figures, please choose small top driver number or use download button to get the pdf format figure file !")
    )
  })
  # 8
  output$NetBIDPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    control_para$doplot <- FALSE    
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    all_comp <- unique(gsub('(.*)_DA','\\1',all_comp))
    all_comp <- unique(gsub('(.*)_DE','\\1',all_comp))
    choose_comp <- use_data$choose_comp
    choose_comp <- unique(gsub('(.*)_DA','\\1',choose_comp))
    tagList(
      p(sprintf('You are focusing on %s',use_data$choose_comp)),
      fluidRow(column(6,offset=0,checkboxGroupInput(inputId='DA_list',label='choose DA comparisons to display',choices=all_comp,selected =choose_comp)),
               column(6,offset=0,checkboxGroupInput(inputId='DE_list',label='choose DE comparisons to display',choices=all_comp,selected =choose_comp))
      ),
      fluidRow(
#               column(3,offset=0,selectInput(inputId='main_id',label='main comparison to visualize',choices=all_comp,selected=choose_comp)),
               column(3,offset=0,numericInput(inputId='top_number8',label='number of top drivers',value=30,step=1,min=0,max=Inf)),
               column(3,offset=0,selectInput(inputId='DA_display_col',label='columns for DA display',choices=c("P.Value",'logFC'),selected='P.Value')),
               column(3,offset=0,selectInput(inputId='DE_display_col',label='columns for DE display',choices=c("P.Value",'logFC'),selected='logFC')),
               column(3,offset=0,actionButton(inputId='doNetBIDPlot',label='Draw NetBID-Plot'))
      )
    )
  })
  ################
  # main plot # plotOutput('mainPlot',height=input$plot_height)
  output$plotPara <- renderUI({
    if(control_para$doplot==FALSE) return()
    switch(control_para$doplot,
           'doVolcalnoPlot'=fluidRow(
             column(6,offset=0,sliderInput('plot_width1','plot_width(px)',min=100,max=2000,value=900)),
             column(6,offset=0,sliderInput('plot_height1','plot_height(px)',min=100,max=2000,value=600))
           ),
           'doHeatmap'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width2','plot_width(px)',min=100,max=2000,value=900)),
               column(6,offset=0,sliderInput('plot_height2','plot_height(px)',min=100,max=2000,value=600))
             ),
             fluidRow(
               column(6,offset=0,sliderInput('row_cex','row label fontsize',min=2,max=50,value=12)),
               column(6,offset=0,sliderInput('col_cex','column label fontsize',min=2,max=50,value=12))
             )
           ),
           'doCategoryBoxPlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width3','plot_width(px)',min=100,max=2000,value=600)),
               column(6,offset=0,sliderInput('plot_height3','plot_height(px)',min=100,max=2000,value=600))
             ),
             fluidRow(
               column(4,offset=0,sliderInput('class_cex','class label cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('strip_cex','point cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('main_cex','main cex',min=0.1,max=3,value=1))
             )
           ),
           'doTargetNetPlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width4','plot_width(px)',min=100,max=2000,value=900)),
               column(6,offset=0,sliderInput('plot_height4','plot_height(px)',min=100,max=2000,value=900))
             ),
             fluidRow(
               column(4,offset=0,sliderInput('source_cex','driver cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('label_cex','target cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('n_layer','number of layer',min=1,max=10,value=1,step=1))
             )
           ),
           'doGSEAPlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width5','plot_width(px)',min=100,max=2000,value=900)),
               column(6,offset=0,sliderInput('plot_height5','plot_height(px)',min=100,max=2000,value=900))
             )
           ),
           'doFunctionEnrichPlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width6','plot_width(px)',min=100,max=2000,value=900)),
               column(6,offset=0,sliderInput('plot_height6','plot_height(px)',min=100,max=2000,value=600))
             ),
             fluidRow(
               column(4,offset=0,sliderInput('gs_cex6','gene set cex',min=0.1,max=3,value=0.7)),
               column(4,offset=0,sliderInput('gene_cex6','gene cex',min=0.1,max=3,value=0.8)),
               column(4,offset=0,sliderInput('pv_cex6','p-value cex',min=0.1,max=3,value=0.7))
             )
           ),
           'doBubblePlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width7','plot_width(px)',min=100,max=2000,value=1200)),
               column(6,offset=0,sliderInput('plot_height7','plot_height(px)',min=100,max=2000,value=1200))
             ),
             fluidRow(
               column(6,offset=0,sliderInput('gs_cex7','gene set cex',min=0.1,max=3,value=0.7)),
               column(6,offset=0,sliderInput('driver_cex7','driver cex',min=0.1,max=3,value=0.8))
             )
           ),
           'doNetBIDPlot'=tagList(
             fluidRow(
               column(6,offset=0,sliderInput('plot_width8','plot_width(px)',min=100,max=2000,value=600)),
               column(6,offset=0,sliderInput('plot_height8','plot_height(px)',min=100,max=2000,value=600))
             ),
             fluidRow(
               column(4,offset=0,sliderInput('row_cex','row names cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('column_cex','column names cex',min=0.1,max=3,value=1)),
               column(4,offset=0,sliderInput('text_cex','text cex',min=0.1,max=3,value=1))
             )
           )
    )
  })
  ###############
  output$mainPlot <- renderUI({ fluidRow(column(12,align = 'center',renderPlot({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doplot==FALSE) return()
    ms_tab <- use_data$ms_tab
    merge.ac.eset <- use_data$merge.ac.eset
    cal.eset <- use_data$cal.eset
    phe <- pData(cal.eset)
    if(control_para$doplot=='doVolcalnoPlot'){ # 1
      use_data$plot_height <- as.numeric(input$plot_height1)
      use_data$plot_width <- as.numeric(input$plot_width1)
      use_ms_tab <- ms_tab[which(ms_tab$Size>=as.numeric(input$min_Size) & ms_tab$Size<=as.numeric(input$max_Size)),]
      res1 <- draw.volcanoPlot(dat=use_ms_tab,label_col = input$label_col1,logFC_col = input$logFC_col, Pv_col=input$Pv_col,
                       logFC_thre = as.numeric(input$logFC_thre), Pv_thre=as.numeric(input$Pv_thre), show_label = input$show_label)
      w1 <- which(abs(use_ms_tab[,input$logFC_col])>=as.numeric(input$logFC_thre) & use_ms_tab[,input$Pv_col]<=as.numeric(input$Pv_thre))
      tmp_ms_tab <- use_ms_tab[w1,]
      use_data$tmp_ms_tab <- tmp_ms_tab
      use_data$choose_comp <- input$choose_comp
    }
    if(control_para$doplot=='doHeatmap'){ #2
      use_data$plot_height <- as.numeric(input$plot_height2)
      use_data$plot_width <- as.numeric(input$plot_width2)
      z_col <- paste0('Z.',input$choose_comp)
      ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy2,input$top_num2,z_col)
      if(input$draw_category=='Activity for top drivers in the master table'){mat <- exprs(use_data$merge.ac.eset);mat1 <- mat[ms_tab$originalID_label,];}
      if(input$draw_category=='Expression for top drivers in the master table'){mat <- exprs(use_data$cal.eset);mat1 <- mat[ms_tab$originalID,];}
      display_row <- ms_tab[,input$label_col2]
      mat1 <- as.matrix(mat1)
      print(str(mat1))
      rr <- 12;rc <- 12;
      if(is.null(input$row_cex)==FALSE) rr <- as.numeric(input$row_cex)
      if(is.null(input$col_cex)==FALSE) rc <- as.numeric(input$col_cex);
      print(rc);print(rr)
      res1 <- draw.heatmap(mat=mat1,use_gene_label = display_row, phenotype_info = phe,use_phe = input$use_phe2,
                           show_row_names=input$show_row_names, show_column_names=input$show_column_names,
                           cluster_rows=input$cluster_rows, cluster_columns=input$cluster_columns,
                           row_names_gp=gpar(fontsize = rr),
                           column_names_gp=gpar(fontsize = rc),scale=input$scale,
                           clustering_distance_rows=input$clustering_distance_rows,
                           clustering_distance_columns=input$clustering_distance_columns)
    }
    if(control_para$doplot=='doCategoryBoxPlot'){ # 3
      use_data$plot_height <- as.numeric(input$plot_height3)
      use_data$plot_width <- as.numeric(input$plot_width3)
      mat_ac <- exprs(use_data$merge.ac.eset)
      mat_exp <- exprs(use_data$cal.eset)
      phe <- pData(use_data$cal.eset)
      use_driver <- input$choose_driver3
      rownames(ms_tab) <- ms_tab$originalID_label
      use_obs_class <- get_obs_label(phe,use_col=input$use_phe3)
      use_gene <- ms_tab[use_driver,'originalID']
      if(use_gene %in% rownames(mat_exp)){
        res1 <- draw.categoryValue(ac_val=mat_ac[use_driver,],exp_val=mat_exp[use_gene,],use_obs_class = use_obs_class,
                           main_ac=ms_tab[use_driver,'gene_label'],main_exp=ms_tab[use_driver,'geneSymbol'],
                           main_cex=input$main_cex,strip_cex=input$strip_cex,class_cex=input$class_cex)
      }else{
        res1 <- draw.categoryValue(ac_val=mat_ac[use_driver,],use_obs_class = use_obs_class,main_ac=ms_tab[use_driver,'gene_label'],
                                   main_cex=input$main_cex,strip_cex=input$strip_cex,class_cex=input$class_cex)
      }
    }
    if(control_para$doplot=='doTargetNetPlot'){ # 4
      use_data$plot_height <- as.numeric(input$plot_height4)
      use_data$plot_width <- as.numeric(input$plot_width4)
      use_driver <- input$choose_driver4
      use_driver2 <- input$choose_driver4_2
      use_target <- use_data$merge.network[[use_driver]]
      edge_score <- use_target$MI*sign(use_target$spearman)
      names(edge_score) <- use_target$target
      z_col <- paste0('Z.',input$choose_comp)
      print(str(use_data$transfer_tab))
      if(input$use_protein_coding4==TRUE){
        w1 <- which(names(edge_score) %in% use_data$transfer_tab[which(use_data$transfer_tab[,3]=='protein_coding'),1])
        edge_score <- edge_score[w1]
      }
      if(input$use_gene_symbol4==TRUE) names(edge_score) <- get_name_transfertab(use_genes=names(edge_score),transfer_tab=use_data$transfer_tab)
      if(use_driver2!=use_driver){
        use_target2 <- use_data$merge.network[[use_driver2]]
        edge_score2 <- use_target2$MI*sign(use_target2$spearman)
        names(edge_score2) <- use_target2$target
        z_col <- paste0('Z.',input$choose_comp)
        if(input$use_protein_coding4==TRUE){
          w1 <- which(names(edge_score2) %in% use_data$transfer_tab[which(use_data$transfer_tab[,3]=='protein_coding'),1])
          edge_score2 <- edge_score2[w1]
        }
        if(input$use_gene_symbol4==TRUE) names(edge_score2) <- get_name_transfertab(use_genes=names(edge_score2),transfer_tab=use_data$transfer_tab)
        draw.targetNet.TWO(source1_label = ms_tab[use_driver,input$label_col4],source2_label = ms_tab[use_driver2,input$label_col4],
                           source1_z=ms_tab[use_driver,z_col],source2_z=ms_tab[use_driver2,z_col],
                           edge_score1=edge_score,edge_score2=edge_score2,
                           label_cex=input$label_cex,source_cex=input$source_cex,n_layer=input$n_layer,alphabetical_order=input$alphabetical_order)
      }else{
        print(str(edge_score))
        #print(ms_tab[use_driver,input$label_col4])
        #print(ms_tab[use_driver,z_col])
        #print(input$label_cex)
        #print(input$source_cex)
        draw.targetNet(source_label = ms_tab[use_driver,input$label_col4],source_z=ms_tab[use_driver,z_col],edge_score=edge_score,
                       label_cex=input$label_cex,source_cex=input$source_cex,n_layer=input$n_layer,alphabetical_order=input$alphabetical_order)
      }
    }
    if(control_para$doplot=='doGSEAPlot'){ # 5
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height5)
      use_data$plot_width <- as.numeric(input$plot_width5)
      ms_tab <- use_data$ms_tab
      z_col <- paste0('Z.',input$choose_comp)
      z_col_DE <- gsub("_DA","_DE",z_col)
      z_col_DA <- gsub("_DE","_DA",z_col)
      ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy5,input$top_num5,z_col)
      uc <- gsub('(.*)_DA','\\1',use_data$choose_comp)
      uc <- gsub('(.*)_DE','\\1',uc)
      res1 <- draw.GSEA.NetBID(DE = use_data$DE[[uc]], name_col = 'ID', profile_col = input$profile_col5,
                         profile_trend = input$profile_trend, driver_list = ms_tab$originalID_label,
                         show_label = ms_tab[,input$label_col5],
                         driver_DA_Z = ms_tab[,z_col_DA], driver_DE_Z = ms_tab[,z_col_DE],
                         target_list = use_data$merge.network,
                         top_driver_number = nrow(ms_tab), target_nrow = input$target_nrow,
                         target_col = input$target_col, target_col_type = input$target_col_type, left_annotation = "",
                         right_annotation = "", main = "", profile_sig_thre = input$profile_sig_thre,
                         Z_sig_thre = input$Z_sig_thre)
    }
    if(control_para$doplot=='doFunctionEnrichPlot'){ # 6
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height6)
      use_data$plot_width <- as.numeric(input$plot_width6)
      z_col <- paste0('Z.',input$choose_comp)
      ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy6,input$top_num6,z_col)
      funcEnrich_res <- funcEnrich.Fisher(input_list = ms_tab$geneSymbol, bg_list = unique(use_data$ori_ms_tab$geneSymbol),
                                          use_gs = c(input$use_gs1_6,input$use_gs2_6),
                                          min_gs_size = input$min_gs_size6, max_gs_size = input$max_gs_size6,
                                          Pv_adj = input$Pv_adj6, Pv_thre = input$Pv_thre6)
      res1 <- draw.funcEnrich.cluster(funcEnrich_res = funcEnrich_res, top_number = input$top_gs_num6,
                              Pv_col = "Ori_P", name_col = "#Name",
                              item_col = "Intersected_items", Pv_thre = input$Pv_thre6, gs_cex = input$gs_cex6,
                              gene_cex = input$gene_cex6, pv_cex = input$pv_cex6, main = "", h = input$h6,
                              cluster_gs = input$cluster_gs, cluster_gene = input$cluster_gene,
                              use_genes = NULL, return_mat = FALSE)
    }
    if(control_para$doplot=='doBubblePlot'){ # 7
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height7)
      use_data$plot_width <- as.numeric(input$plot_width7)
      z_col <- paste0('Z.',input$choose_comp)
      z_col_DA <- gsub("_DE","_DA",z_col)
      ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy7,input$top_num7,z_col)
      bg_gene <- unique(unlist(lapply(use_data$merge.network,function(x)x$target)))
      #print(str(ms_tab))
      #print(str(bg_gene))
      #print(c(input$label_col7,z_col,input$min_gs_size7,input$max_gs_size7,input$Pv_adj7,input$Pv_thre7,input$top_geneset_number,input$top_num7))
      res1 <- draw.bubblePlot(driver_list = ms_tab$originalID_label, show_label = ms_tab[,input$label_col7],
                      Z_val = ms_tab[,z_col_DA], driver_type = NULL, target_list = use_data$merge.network,
                      transfer2symbol2type = use_data$transfer_tab, bg_list = bg_gene, min_gs_size = input$min_gs_size7,
                      max_gs_size = input$max_gs_size7, use_gs = c(input$use_gs1_7,input$use_gs2_7),
                      display_gs_list = NULL, Pv_adj = input$Pv_adj7, Pv_thre = input$Pv_thre7,
                      top_geneset_number = input$top_geneset_number, top_driver_number = input$top_num7,
                      mark_gene = NULL, driver_cex = input$driver_cex7, gs_cex = input$gs_cex7)
    }
    if(control_para$doplot=='doNetBIDPlot'){ # 8
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height8)
      use_data$plot_width <- as.numeric(input$plot_width8)
      DA <- use_data$DA; DE <- use_data$DE;
      DA_list <- input$DA_list;
      DE_list <- input$DE_list;
      choose_comp <- use_data$choose_comp
      choose_comp <- unique(gsub('(.*)_DA','\\1',choose_comp))
      print(DA_list);print(names(DA))
      print(str(DA[DA_list])); print(str(DE[DE_list])); print(input$choose_comp)
      res1 <- draw.NetBID(DA_list = DA[DA_list], DE_list = DE[DE_list], main_id = choose_comp,
                          top_number = input$top_number8, DA_display_col = input$DA_display_col,
                          DE_display_col = input$DE_display_col, z_col = "Z-statistics", digit_num = 2,
                          row_cex = input$row_cex, column_cex = input$column_cex, text_cex = input$text_cex, col_srt = 60)
    }
    #
  },height = use_data$plot_height,width=use_data$plot_width)))})
  ########################
  # addtionalPerformance
  output$addtionalPerformance <- renderUI({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doplot==FALSE) return()
    if(control_para$doplot=='doVolcalnoPlot'){ #1
      mess <- sprintf('<b>MESSAGE</b>: %d drivers passed by the filter !',nrow(use_data$tmp_ms_tab));
       tagList(
         hr(),
         fluidRow(
          column(4,offset=1,HTML(mess)),
          column(6,offset=0,actionButton(inputId='doupdateMsTab',label='Update the master table by using the parameters and top number above'))
        )
      )
    }
  })
  ##
  output$downloadPlotButton <- downloadHandler(
    filename = function(){sprintf('%s.pdf',gsub('do(.*)','\\1',control_para$doplot))},
    content = function(file) {
      if(control_para$doloadData==FALSE) return()
      if(control_para$doplot==FALSE) return()
      ms_tab <- use_data$ms_tab
      merge.ac.eset <- use_data$merge.ac.eset
      cal.eset <- use_data$cal.eset
      phe <- pData(cal.eset)
      if(control_para$doplot=='doVolcalnoPlot'){ # 1
        use_ms_tab <- ms_tab[which(ms_tab$Size>=as.numeric(input$min_Size) & ms_tab$Size<=as.numeric(input$max_Size)),]
        res1 <- draw.volcanoPlot(dat=use_ms_tab,label_col = input$label_col1,logFC_col = input$logFC_col, Pv_col=input$Pv_col,
                                 logFC_thre = as.numeric(input$logFC_thre), Pv_thre=as.numeric(input$Pv_thre), show_label = input$show_label,
                                 pdf_file = file)
      }
      if(control_para$doplot=='doHeatmap'){ #2
        z_col <- paste0('Z.',input$choose_comp)
        ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy2,input$top_num2,z_col)
        if(input$draw_category=='Activity for top drivers in the master table'){mat <- exprs(use_data$merge.ac.eset);mat1 <- mat[ms_tab$originalID_label,];}
        if(input$draw_category=='Expression for top drivers in the master table'){mat <- exprs(use_data$cal.eset);mat1 <- mat[ms_tab$originalID,];}
        display_row <- ms_tab[,input$label_col2]
        mat1 <- as.matrix(mat1)
        rr <- 12;rc <- 12;
        if(is.null(input$row_cex)==FALSE) rr <- as.numeric(input$row_cex)
        if(is.null(input$col_cex)==FALSE) rc <- as.numeric(input$col_cex);
        res1 <- draw.heatmap(mat=mat1,use_gene_label = display_row, phenotype_info = phe,use_phe = input$use_phe2,
                             show_row_names=input$show_row_names, show_column_names=input$show_column_names,
                             cluster_rows=input$cluster_rows, cluster_columns=input$cluster_columns,
                             row_names_gp=gpar(fontsize = rr),
                             column_names_gp=gpar(fontsize = rc),scale=input$scale,
                             clustering_distance_rows=input$clustering_distance_rows,clustering_distance_columns=input$clustering_distance_columns,pdf_file = file)
      }
      if(control_para$doplot=='doCategoryBoxPlot'){ # 3
        mat_ac <- exprs(use_data$merge.ac.eset)
        mat_exp <- exprs(use_data$cal.eset)
        phe <- pData(use_data$cal.eset)
        use_driver <- input$choose_driver3
        rownames(ms_tab) <- ms_tab$originalID_label
        use_obs_class <- get_obs_label(phe,use_col=input$use_phe3)
        use_gene <- ms_tab[use_driver,'originalID']
        if(use_gene %in% rownames(mat_exp)){
          res1 <- draw.categoryValue(ac_val=mat_ac[use_driver,],exp_val=mat_exp[use_gene,],use_obs_class = use_obs_class,
                                     main_ac=ms_tab[use_driver,'gene_label'],main_exp=ms_tab[use_driver,'geneSymbol'],
                                     main_cex=input$main_cex,strip_cex=input$strip_cex,class_cex=input$class_cex,pdf_file = file)
        }else{
          res1 <- draw.categoryValue(ac_val=mat_ac[use_driver,],use_obs_class = use_obs_class,main_ac=ms_tab[use_driver,'gene_label'],
                                     main_cex=input$main_cex,strip_cex=input$strip_cex,class_cex=input$class_cex,pdf_file = file)
        }
      }
      if(control_para$doplot=='doTargetNetPlot'){ # 4
        use_driver <- input$choose_driver4
        use_driver2 <- input$choose_driver4_2
        use_target <- use_data$merge.network[[use_driver]]
        edge_score <- use_target$MI*sign(use_target$spearman)
        names(edge_score) <- use_target$target
        z_col <- paste0('Z.',input$choose_comp)
        print(str(use_data$transfer_tab))
        if(input$use_protein_coding4==TRUE){
          w1 <- which(names(edge_score) %in% use_data$transfer_tab[which(use_data$transfer_tab[,3]=='protein_coding'),1])
          edge_score <- edge_score[w1]
        }
        if(input$use_gene_symbol4==TRUE) names(edge_score) <- get_name_transfertab(use_genes=names(edge_score),transfer_tab=use_data$transfer_tab)
        if(use_driver2!=use_driver){
          use_target2 <- use_data$merge.network[[use_driver2]]
          edge_score2 <- use_target2$MI*sign(use_target2$spearman)
          names(edge_score2) <- use_target2$target
          z_col <- paste0('Z.',input$choose_comp)
          if(input$use_protein_coding4==TRUE){
            w1 <- which(names(edge_score2) %in% use_data$transfer_tab[which(use_data$transfer_tab[,3]=='protein_coding'),1])
            edge_score2 <- edge_score2[w1]
          }
          if(input$use_gene_symbol4==TRUE) names(edge_score2) <- get_name_transfertab(use_genes=names(edge_score2),transfer_tab=use_data$transfer_tab)
          draw.targetNet.TWO(source1_label = ms_tab[use_driver,input$label_col4],source2_label = ms_tab[use_driver2,input$label_col4],
                             source1_z=ms_tab[use_driver,z_col],source2_z=ms_tab[use_driver2,z_col],
                             edge_score1=edge_score,edge_score2=edge_score2,
                             label_cex=input$label_cex,source_cex=input$source_cex,n_layer=input$n_layer,alphabetical_order=input$alphabetical_order,pdf_file = file)
        }else{
          print(str(edge_score))
          draw.targetNet(source_label = ms_tab[use_driver,input$label_col4],source_z=ms_tab[use_driver,z_col],edge_score=edge_score,
                         label_cex=input$label_cex,source_cex=input$source_cex,n_layer=input$n_layer,alphabetical_order=input$alphabetical_order,pdf_file = file)
        }
      }
      if(control_para$doplot=='doGSEAPlot'){ # 5
        if(is.null(use_data$choose_comp)==TRUE) return()
        ms_tab <- use_data$ms_tab
        z_col <- paste0('Z.',input$choose_comp)
        z_col_DE <- gsub("_DA","_DE",z_col)
        ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy5,input$top_num5,z_col)
        uc <- gsub('(.*)_DA','\\1',use_data$choose_comp)
        uc <- gsub('(.*)_DE','\\1',uc)
        res1 <- draw.GSEA.NetBID(DE = use_data$DE[[uc]], name_col = 'ID', profile_col = input$profile_col5,
                                 profile_trend = input$profile_trend, driver_list = ms_tab$originalID_label,
                                 show_label = ms_tab[,input$label_col5],
                                 driver_DA_Z = ms_tab[,z_col], driver_DE_Z = ms_tab[,z_col_DE],
                                 target_list = use_data$merge.network,
                                 top_driver_number = nrow(ms_tab), target_nrow = input$target_nrow,
                                 target_col = input$target_col, target_col_type = input$target_col_type, left_annotation = "",
                                 right_annotation = "", main = "", profile_sig_thre = input$profile_sig_thre,
                                 Z_sig_thre = input$Z_sig_thre,pdf_file = file)
      }
      if(control_para$doplot=='doFunctionEnrichPlot'){ # 6
        if(is.null(use_data$choose_comp)==TRUE) return()
        z_col <- paste0('Z.',input$choose_comp)
        ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy6,input$top_num6,z_col)
        funcEnrich_res <- funcEnrich.Fisher(input_list = ms_tab$geneSymbol, bg_list = unique(use_data$ori_ms_tab$geneSymbol),
                                            use_gs = c(input$use_gs1_6,input$use_gs2_6),
                                            min_gs_size = input$min_gs_size6, max_gs_size = input$max_gs_size6,
                                            Pv_adj = input$Pv_adj6, Pv_thre = input$Pv_thre6)
        res1 <- draw.funcEnrich.cluster(funcEnrich_res = funcEnrich_res, top_number = input$top_gs_num6,
                                        Pv_col = "Ori_P", name_col = "#Name",
                                        item_col = "Intersected_items", Pv_thre = input$Pv_thre6, gs_cex = input$gs_cex6,
                                        gene_cex = input$gene_cex6, pv_cex = input$pv_cex6, main = "", h = input$h6,
                                        cluster_gs = input$cluster_gs, cluster_gene = input$cluster_gene,
                                        use_genes = NULL, return_mat = FALSE,pdf_file = file)
      }
      if(control_para$doplot=='doBubblePlot'){ # 7
        if(is.null(use_data$choose_comp)==TRUE) return()
        z_col <- paste0('Z.',input$choose_comp)
        ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy7,input$top_num7,z_col)
        bg_gene <- unique(unlist(lapply(use_data$merge.network,function(x)x$target)))
        res1 <- draw.bubblePlot(driver_list = ms_tab$originalID_label, show_label = ms_tab[,input$label_col7],
                                Z_val = ms_tab[,z_col], driver_type = NULL, target_list = use_data$merge.network,
                                transfer2symbol2type = use_data$transfer_tab, bg_list = bg_gene, min_gs_size = input$min_gs_size7,
                                max_gs_size = input$max_gs_size7, use_gs = c(input$use_gs1_7,input$use_gs2_7),
                                display_gs_list = NULL, Pv_adj = input$Pv_adj7, Pv_thre = input$Pv_thre7,
                                top_geneset_number = input$top_geneset_number, top_driver_number = input$top_num7,
                                mark_gene = NULL, driver_cex = input$driver_cex7, gs_cex = input$gs_cex7,pdf_file = file)
      }
      if(control_para$doplot=='doNetBIDPlot'){ # 8
        if(is.null(use_data$choose_comp)==TRUE) return()
        DA <- use_data$DA; DE <- use_data$DE;
        DA_list <- input$DA_list;
        DE_list <- input$DE_list;
        choose_comp <- use_data$choose_comp
        choose_comp <- unique(gsub('(.*)_DA','\\1',choose_comp))
        print(str(DA[DA_list])); print(str(DE[DE_list])); print(input$choose_comp)
        res1 <- draw.NetBID(DA_list = DA[DA_list], DE_list = DE[DE_list], main_id = choose_comp,
                            top_number = input$top_number8, DA_display_col = input$DA_display_col,
                            DE_display_col = input$DE_display_col, z_col = "Z-statistics", digit_num = 2,
                            row_cex = input$row_cex, column_cex = input$column_cex, text_cex = input$text_cex, col_srt = 60,pdf_file = file)
      }
    }
  )
  ##
  output$masterTable.ui <- renderUI({
    if(control_para$doloadData==FALSE) return()
    tagList(
      hr(),      
      h4('Master table for the dataset',style='text-align:left')
    )
  })
  output$about.ui <- renderUI({
    control_para$doplot <- FALSE
    tagList(
      hr(),      
      h4('NetBIDShiny: A shiny app to visualize the NetBID results',style='text-align:left'),
      a('Github address: https://github.com/jyyulab/NetBID_shiny/',href='https://github.com/jyyulab/NetBID_shiny/',target='_',style = "font-size:120%;"),
      br(),
      a('Online manual: https://jyyulab.github.io/NetBID_shiny/',href='https://jyyulab.github.io/NetBID_shiny/',target='_',style = "font-size:120%;"),
      h4('Current NetBID algorithm, NetBID2: data-driven Network-based Bayesian Inference of Drivers, Version II'),
      a('Github address: https://github.com/jyyulab/NetBID-dev',href='https://github.com/jyyulab/NetBID-dev/',target='_',style = "font-size:120%;"),
      br(),
      a('Online manual: https://jyyulab.github.io/NetBID-dev/',href='https://jyyulab.github.io/NetBID-dev/',target='_',style = "font-size:120%;")
    )
  })
  output$plot.ui <- renderUI({
    if(control_para$doplot==FALSE) return()
    tagList(
      hr(),
      fluidRow(
        column(5,offset=0,h4('Plot Region',style='text-align:left')),
        column(5,offset=2,downloadButton('downloadPlotButton', 'Download the current plot',style='text-align:right'))
      ),br(),br(),
      div(htmlOutput('plotWarnning')),
      div(htmlOutput('plotPara'),style="align:center;font-size:70%;height:50%;background-color:#F8F9F9;width:100%;margin:0%;padding-left:5%;text-align:center"),
      div(htmlOutput("mainPlot"),style="background-color:#FDFEFE")
    )
  })
}
##
server_MR <- function(input, output,session){
  #
  volumes <- c( 'Current Directory'='.',Home = fs::path_home(), "R Installation" = R.home(),getVolumes()())
  shinyFileChoose(input, "choose_tf_network_file", session = session,roots=volumes)
  shinyFileChoose(input, "choose_sig_network_file",session = session,roots=volumes)
  shinyFileChoose(input, "choose_eset_RData_file",session = session,roots=volumes)
  shinyDirChoose(input, "project_main_dir", roots = volumes, session = session, restrictions = system.file(package = "base"))
  #shinyFileSave(input, "save", roots = volumes, session = session, restrictions = system.file(package = "base"))
  #
  use_data <- reactiveValues(eset=NULL,tf_network_file=NULL,sig_network_file=NULL,
                             project_main_dir='',project_name='',
                             G0_name='',G1_name='',
                             comp_name='',intgroup='',
                             main_id_type='',cal.eset_main_id_type='',
                             DE_strategy='',use_spe='',
                             use_level='',pass=0,doQC=FALSE,doPLOT=FALSE,top_number=30)
  control_para <- reactiveValues(doloadData = FALSE, doanalysis=FALSE,checkanalysis = FALSE) ## control parameters
  observeEvent(input$loadButton, { control_para$doloadData <- 'doinitialload';})
  observeEvent(input$loadDemoButton, { control_para$doloadData <- 'doinitialdemoload';})
  observeEvent(input$doButton, { control_para$doanalysis <- TRUE;},once=FALSE,autoDestroy=FALSE)
  observeEvent(input$initButton0, { js$refresh();control_para$doloadData <- FALSE; control_para$checkanalysis <- FALSE;control_para$doanalysis <- FALSE;})
  output$filepaths_tf_network_file <- renderUI({
      p(parseFilePaths(volumes, input$choose_tf_network_file)$datapath)
  })
  output$filepaths_sig_network_file <- renderUI({
      p(parseFilePaths(volumes, input$choose_sig_network_file)$datapath)
  })
  output$filepaths_choose_eset_RData_file <- renderUI({
      p(parseFilePaths(volumes, input$choose_eset_RData_file)$datapath)
  })
  loadData <- reactive({
    output$error_message <- renderUI({p('')})
    inFile <- input$eset_RData_file
    print(inFile$datapath)
    inFile1 <- list()
    inFile1$datapath <- parseFilePaths(volumes,input$choose_eset_RData_file)$datapath
    if(is.null(inFile$datapath)==TRUE & length(inFile1$datapath)==0) {
      control_para$doloadData <- FALSE;
      output$error_message <- renderUI({p('WARNING : NO upload or choose the RData file for the calculation eset, please check and re-try!')})
      return()
    }
    if(is.null(inFile$datapath)==FALSE){
      load(inFile$datapath)
    }else{
      load(inFile1$datapath)
    }
    #
    all_obj <- ls()
    all_obj_class <- lapply(all_obj,function(x)class(get(x)))
    w1 <- unlist(lapply(all_obj_class,function(x)ifelse('ExpressionSet' %in% x,1,0))) ## find the first expression set object
    w2 <- which(w1==1)[1]
    if(length(w2)==0){
      control_para$doloadData <- FALSE;
      output$error_message <- renderUI({p('WARNING : NO ExpressionSet class object in the RData file, please check and re-try!')})
      return()
    }
    use_data$eset <- get(all_obj[w2])
    print(all_obj[w2])
    print('Finish loading the dataset')
    #
    inFile_tf1 <- list(); inFile_sig1 <- list();
    inFile_tf1$datapath  <- parseFilePaths(volumes,input$choose_tf_network_file)$datapath
    inFile_sig1$datapath <- parseFilePaths(volumes,input$choose_sig_network_file)$datapath
    inFile_tf  <- input$tf_network_file
    inFile_sig <- input$sig_network_file
    if(is.null(inFile_tf$datapath)==TRUE & length(inFile_tf1$datapath)==0){
      control_para$doloadData <- FALSE;
      output$error_message <- renderUI({p('WARNING : NO choose the TF network file, please check and re-try!')})
      return()
    }
    if(is.null(inFile_sig$datapath)==TRUE & length(inFile_sig1$datapath)==0){
      control_para$doloadData <- FALSE;
      output$error_message <- renderUI({p('WARNING : NO choose the SIG network file, please check and re-try!')})
      return()
    }
    if(is.null(inFile_tf$datapath)==FALSE){
      use_data$tf_network_file <- inFile_tf$datapath
    }else{
      use_data$tf_network_file <- inFile_tf1$datapath
    }
    if(is.null(inFile_sig$datapath)==FALSE){
      use_data$sig_network_file <- inFile_sig$datapath
    }else{
      use_data$sig_network_file <- inFile_sig1$datapath
    }
    print(use_data$tf_network_file)
    print(use_data$sig_network_file)
    print('Finish loading the network files')
  })
  
  loadDemoData <- reactive({
    use_dir <- sprintf('%s/inst/',getwd())
    eset_demo_path <- sprintf('%s/demo1/demo_eset.Rdata',use_dir)
    load(eset_demo_path)
    use_data$eset <- eset
    use_data$tf_network_file <- sprintf('%s/demo1/TF_consensus_network_ncol_.txt',use_dir)
    use_data$sig_network_file <- sprintf('%s/demo1/SIG_consensus_network_ncol_.txt',use_dir)
    print('Finish loading the demo dataset')
  })
  output$summaryProject<-renderUI({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doloadData=='doinitialload') loadData()
    if(control_para$doloadData=='doinitialdemoload') loadDemoData()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    mess <- sprintf('')
    HTML(mess)
  })
  output$dirpaths_project_main_dir <- renderUI({
    p(sprintf("Output main directory:%s",parseDirPath(volumes,input$project_main_dir)),style='color:red')
  })
  output$analysisOption <- renderUI({
    if(control_para$doloadData==FALSE) return()
    all_id_type <- c('external_gene_name','ensembl_gene_id','ensembl_gene_id_version','ensembl_transcript_id','ensembl_transcript_id_version',
                     'refseq_mrna','hgnc_symbol','entrezgene','ucsc','uniprotswissprot','other')
    from_type <- 'external_gene_name'
    eset <- use_data$eset
    phe  <- pData(eset)
    all_int <- get_int_group(eset)
    if(is.null(input$intgroup)==FALSE){
      sel_int <- input$intgroup
      all_g   <- unique(phe[,sel_int])
      g1 <- unique(phe[,sel_int])[1]
      g2 <- unique(phe[,sel_int])[2]
    } else{
      sel_int <- all_int[1]
      all_g   <- unique(phe[,sel_int])
      g1 <- unique(phe[,sel_int])[1]
      g2 <- unique(phe[,sel_int])[2]
    } 
    all_g1 <- all_g
    if(is.null(input$G1_name)==FALSE){
      g1 <- input$G1_name
      g2 <- input$G0_name
    }
    all_g2 <- c(setdiff(all_g,g1),paste0('Non-',all_g))
    comp_name <- sprintf('%s Vs. %s',g1,g2)
    tagList(
      fluidRow(
        column(4,offset=0,selectInput(inputId='intgroup',label='Select the interested sample group for analysis',
                                      choices=all_int,selected = sel_int)),
        column(4,offset=0,selectInput(inputId='G1_name',label='Select type for the case group',
                                      choices=all_g1,selected = g1)),
        column(4,offset=0,selectInput(inputId='G0_name',label='Select type for the control group',
                                      choices=all_g2,selected = g2))
      ),
      fluidRow(
        column(4,offset=0,textInput(inputId='comp_name',label='Input the comparison name',value=comp_name)),
        column(4,offset=0,selectInput(inputId='DE_strategy',label='Choose the analysis strategy',
                                      choices=c('limma','bid'),selected = 'limma')),
        column(4,offset=0,selectInput(inputId='use_spe',label='Choose the species',choices=c('human','mouse'),
                                      selected = 'human'))
      ),     
      fluidRow(
        column(4,offset=0,selectInput(inputId='use_level',label='Choose the ID level for the network',
                                      choices=c('gene','transcript'),selected = 'gene')),
        column(4,offset=0,selectInput(inputId='cal.eset_main_id_type',label='Choose the main id type for the calculation dataset',
                                      choices=all_id_type,selected =from_type)),
        column(4,offset=0,selectInput(inputId='main_id_type',label='Choose the main id type for the network files',
                                      choices=all_id_type,selected =from_type))
      ),
      fluidRow(
        column(4,offset=0,shinyDirButton(id='project_main_dir',label='Choose main output directory for the project',
                                         title='Please choose the directory of the project for saving the output')),
        column(4,offset=0,htmlOutput('dirpaths_project_main_dir')),
        column(4,offset=0,textInput(inputId='project_name',label='Project name',value=''))
      ),hr(),
      HTML('<p><b>More options:</b></p>'),
      p('Mainly for automatically visualization plot generation for top drivers (Rank by P-value, no filteration for logFC and P-value), 
        more flexible choice is to use another app in this package by \'NetBIDshiny.run4Vis()\' and load in the RData generated in the output directory.'),
      fluidRow(
        column(4,offset=0,checkboxInput(inputId='doQC',label='Do QC plot for the network and activity eSet (which will take time) ?',value = FALSE)),
        column(4,offset=0,checkboxInput(inputId='doPLOT',label='Do plot for the top drivers (which will take time) ?',value = FALSE)),
        column(4,offset=0,numericInput(inputId='top_number',label='Number of top drivers for plotting ?',value = 30,min=10,step=1))
      ),hr()
    )
  })
  output$checkReturn <- renderUI({
    if(control_para$doloadData==FALSE) return()
  #  if(control_para$checkanalysis==FALSE) return()
    j1 <- class(input$project_main_dir)[1]
    #print(j1)
    if(j1!='list'){
      #control_para$doanalysis <- FALSE
      return(p('WARNING : No selection for the project main directory!',style='color:red;font-size:120%'))
    }
    j2 <- input$project_name
    #print(j2)
    if(j2==''){
      #control_para$doanalysis <- FALSE
      return(p('WARNING : No input for the project name !',style='color:red;font-size:120%'))
    }
    project_main_dir <- parseDirPath(volumes,input$project_main_dir)
    project_name <- input$project_name
    use_data$project_main_dir <- project_main_dir
    use_data$project_name <- project_name
    use_data$G0_name <- input$G0_name
    use_data$G1_name <- input$G1_name
    use_data$comp_name <- input$comp_name
    use_data$intgroup <- input$intgroup
    use_data$main_id_type <- input$main_id_type
    use_data$cal.eset_main_id_type <- input$cal.eset_main_id_type
    use_data$DE_strategy <- input$DE_strategy
    use_data$use_spe <- input$use_spe
    use_data$use_level <- input$use_level
    use_data$pass <- 1
    use_data$doQC <- input$doQC
    use_data$doPLOT <- input$doPLOT
    use_data$top_number <- input$top_number
    return(tagList(
      h4('Check the options below:'),
      HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
      HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
      HTML(sprintf('<p>Main species:<b>%s</b></p>',use_data$use_spe)),
      HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
      HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
      HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
      HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
      hr(),
      fluidRow(
        column(4,offset=0,HTML('<p style=\'color:red\'>Click the right button if everything is correct ! <br> And stay at the page until the below message update !</p>')),
        column(4,offset=0,actionButton(inputId='doButton',label='Start the driver estimation analysis'))
      ),hr()
    ))
  })
  output$analysisReturn <- renderUI({
    if(control_para$doloadData==FALSE) return()
   # if(control_para$checkanalysis==FALSE) return()
    if(use_data$pass==0) return(tagList(h4('Result message:'),p('Input option missing !')))
    if(control_para$doanalysis==FALSE) return(tagList(h4('Result message:'),p('Haven\'t started yet !')))
    output$analysisOption <- renderUI({})
    output$checkReturn <- renderUI({})
    db.preload(use_spe=use_data$use_spe,use_level=use_data$use_level)
    project_main_dir <- use_data$project_main_dir
    project_name <- use_data$project_name
    G0_name <- use_data$G0_name
    print(G0_name)
    G0_name_mod <- gsub('Non-','',G0_name)
    eset <- use_data$eset
    intgroup <- use_data$intgroup
    if(G0_name_mod!=G0_name){
      phe1 <- pData(eset)
      w1 <- phe1[,intgroup]
      w1[which(w1!=G0_name_mod)] <- G0_name
      phe1[,intgroup] <- w1
      pData(eset) <- phe1
    }
    withProgress(message='processing',value=0.3,{
      if(use_data$doPLOT==TRUE){
        incProgress(0.5, detail = 'Start calculating')
        analysis.par <- NetBID.lazyMode.DriverEstimation(project_main_dir = project_main_dir,
                                                         project_name = project_name, 
                                                         tf.network.file = use_data$tf_network_file,
                                                         sig.network.file = use_data$sig_network_file, cal.eset = eset, 
                                                         main_id_type = use_data$main_id_type,
                                                         cal.eset_main_id_type = use_data$cal.eset_main_id_type, 
                                                         use_level = use_data$use_level,
                                                         transfer_tab = NULL, 
                                                         intgroup = use_data$intgroup, G1_name = use_data$G1_name,
                                                         G0_name = use_data$G0_name, comp_name = use_data$comp_name, do.QC = use_data$doQC,
                                                         DE_strategy = use_data$DE_strategy, return_analysis.par = TRUE)
        incProgress(0.8, detail = 'Start plotting for top drivers')
        if(use_data$use_spe=='human') gs.preload(use_spe='Homo sapiens')
        if(use_data$use_spe=='mouse') gs.preload(use_spe='Mus musculus')
        res1 <- NetBID.lazyMode.DriverVisualization(analysis.par=analysis.par,intgroup=use_data$intgroup,use_comp=use_data$comp_name,
                                                    main_id_type=use_data$main_id_type,top_number=use_data$top_number,
                                                    logFC_thre = 0, Pv_thre = 1)
      }else{
        incProgress(0.5, detail = 'Start calculating')
        analysis.par <- NetBID.lazyMode.DriverEstimation(project_main_dir = project_main_dir,
                                                         project_name = project_name, 
                                                         tf.network.file = use_data$tf_network_file,
                                                         sig.network.file = use_data$sig_network_file, cal.eset = eset, 
                                                         main_id_type = use_data$main_id_type,
                                                         cal.eset_main_id_type = use_data$cal.eset_main_id_type, 
                                                         use_level = use_data$use_level,
                                                         transfer_tab = NULL, 
                                                         intgroup = use_data$intgroup, G1_name = use_data$G1_name,
                                                         G0_name = use_data$G0_name, comp_name = use_data$comp_name, do.QC = use_data$doQC,
                                                         DE_strategy = use_data$DE_strategy, return_analysis.par = FALSE)
      }
    })
    output_README_file <- sprintf('%s/%s/README_%s_%s.txt',project_main_dir,project_name,project_name,use_data$comp_name)
    information <- sprintf('Analysis Date:%s\nProject main directory:%s\nProject name:%s\nMain species:%s\nThe case group name :%s\nThe control group name :%s\nThe comparison name:%s\nThe ID level is at %s\nThe main ID type for the network files:%s\nThe main ID type for the calculate eset:%s\nAnalysis strategy:%s',
                           format(Sys.time(), "%a %b %d %H:%M:%S %Y"),
                           project_main_dir,project_name,use_data$use_spe,use_data$G1_name,use_data$G0_name,use_data$comp_name,
                           use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type,use_data$DE_strategy)
    write.table(information,file=output_README_file,quote=F,row.names=F,col.names=F)
    if(use_data$doPLOT==TRUE){
      return(tagList(h4('Result message:'),
                     HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
                     HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
                     HTML(sprintf('<p>Main species:<b>%s</b></p>',use_data$use_spe)),
                     HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
                     HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                                  use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
                     HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
                     HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
                     HTML(sprintf('<p style=\'color:red;\'>Finish ! Check Master table excel file in %s/%s/DATA/%s_ms_tab.xlsx <br> 
                                  RData file in %s/%s/DATA/analysis.par.Step.ms-tab.RData</p>',
                                  project_main_dir,project_name,project_name,project_main_dir,project_name)),
                     HTML(sprintf('<p style=\'color:red;\'>Plot for top drivers in %s/%s/PLOT/',
                                  project_main_dir,project_name)),
                     HTML('<p>Please click the Refresh button to start another analysis!</p>')))
    }else{
      return(tagList(h4('Result message:'),
                     HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
                     HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
                     HTML(sprintf('<p>Main species:<b>%s</b></p>',use_data$use_spe)),
                     HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
                     HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                                  use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
                     HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
                     HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
                     HTML(sprintf('<p style=\'color:red;\'>Finish ! Check Master table excel file in %s/%s/DATA/%s_ms_tab.xlsx <br> 
                                  RData file in %s/%s/DATA/analysis.par.Step.ms-tab.RData</p>',
                                  project_main_dir,project_name,project_name,project_main_dir,project_name)),
                     HTML('<p>Please click the Refresh button to start another analysis!</p>')))
    }
  })
}






