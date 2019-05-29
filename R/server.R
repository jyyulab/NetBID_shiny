
options(shiny.maxRequestSize = 500 * 1024 ^ 2) ## 500mb
library(shinyjs)
library(NetBID2)

server <- function(input, output) {
  ################
  use_data <- reactiveValues(ori_ms_tab=NULL,ms_tab=NULL,tmp_ms_tab=NULL,use_para='',basic_info='',
                             project.name=NULL,main.dir=NULL,
                             cal.eset=NULL,merge.ac.eset=NULL,merge.network=NULL,DE=NULL,DA=NULL,
                             transfer_tab=NULL, all_gs2gene=NULL, all_gs2gene_info=NULL,
                             all_comp=NULL,choose_comp=NULL,plot_height=500,plot_width=800) ## global variables
  control_para <- reactiveValues(doloadData = FALSE, doplot=FALSE) ## control parameters
  ################
  observeEvent(input$loadButton, { control_para$doloadData <- 'doinitialload'; control_para$doplot=FALSE; use_data$use_para <- ''; use_data$ms_tab <- use_data$ori_ms_tab;})
  observeEvent(input$loadDemoButton, { control_para$doloadData <- 'doinitialdemoload'; control_para$doplot=FALSE; use_data$use_para <- ''; use_data$ms_tab <- use_data$ori_ms_tab;})
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
    all_comp <- colnames(ms_tab)[grep('Z.',colnames(ms_tab))]
    all_comp <- unique(gsub('Z.(.*)','\\1',all_comp))
    use_data$all_comp <- all_comp
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
    if('transfer_tab' %in% names(analysis.par)) use_data$transfer_tab <- analysis.par$transfer_tab
  })
  # summary
  output$summaryProject<-renderUI({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doloadData=='doinitialload') loadData()
    if(control_para$doloadData=='doinitialdemoload') loadDemoData()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    mess <- sprintf('The project name is %s <br> with the main directory in %s; %s; <br>  %s<br><br>In total %d TF and %d SIG. <br><br> %d comparisons are found in the master table: %s ',
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
      column(6,offset=0,selectInput(inputId='use_spe',label='choose the species',choices=msigdbr_show_species(),selected = use_spe)),
      column(6,offset=0,selectInput(inputId='use_level',label='choose the gene/transcript level',choices=c('gene','transcript'),selected = use_level))
    ),
    fluidRow(
      column(6,offset=0,selectInput(inputId='choose_main_id_type',label='choose the main id type',choices=all_id_type,selected =from_type)),
      column(6,offset=0,textInput(inputId='other_main_id_type',label='input the main id type (if choose other, name need to be found in biomaRT)', value = ''))
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
     pageLength = 10)
    )
  ################
  # draw options
  # 1
  output$VolcanoPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
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
    ms_tab <- use_data$ms_tab
    cal.eset <- use_data$cal.eset
    all_choose <- c('Activity for top drivers in the master table','Expression for top drivers in the master table')
    all_phe <- get_int_group(use_data$cal.eset)
    phe <- pData(use_data$cal.eset)
    target_phe <- sapply(phe[,all_phe],function(x){sum(unlist(lapply(x,function(x1)grep(x1,use_data$choose_comp))))})
    all_phe <- all_phe[order(target_phe,decreasing = TRUE)]
    all_cluster <- c('pearson','spearman','euclidean','maximum','manhattan','canberra','binary','minkowski','kendall')
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
  })
  # 3
  output$CategoryBoxPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
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
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
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
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    uc <- gsub('(.*)_DA','\\1',use_data$choose_comp)
    uc <- gsub('(.*)_DE','\\1',uc)
    all_p_col <- intersect(colnames(use_data$DE[[uc]]),c('t','logFC','Z-statistics'))
    tagList(
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
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    use_gs1 <- unique(cbind(all_gs2gene_info$Category,all_gs2gene_info$Category_Info))
    use_gs2 <- unique(cbind(all_gs2gene_info$`Sub-Category`,all_gs2gene_info$`Sub-Category_Info`))[-1,]
    use_gs1[,2] <- paste(use_gs1[,1],use_gs1[,2],sep=':')
    use_gs2[,2] <- paste(use_gs2[,1],use_gs2[,2],sep=':')
    tagList(
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
    if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
    ms_tab <- use_data$ms_tab
    use_gs1 <- unique(cbind(all_gs2gene_info$Category,all_gs2gene_info$Category_Info))
    use_gs2 <- unique(cbind(all_gs2gene_info$`Sub-Category`,all_gs2gene_info$`Sub-Category_Info`))[-1,]
    use_gs1[,2] <- paste(use_gs1[,1],use_gs1[,2],sep=':')
    use_gs2[,2] <- paste(use_gs2[,1],use_gs2[,2],sep=':')
    tagList(
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
      p("NOTE: bubble plot will generate large size figures, please choose small top driver number !")
    )
  })
  # 8
  output$NetBIDPlot_para <- renderUI({
    if(control_para$doloadData==FALSE) return()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    all_comp <- unique(gsub('(.*)_DA','\\1',all_comp))
    all_comp <- unique(gsub('(.*)_DE','\\1',all_comp))
    choose_comp <- use_data$choose_comp
    choose_comp <- unique(gsub('(.*)_DA','\\1',choose_comp))
    tagList(
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
      #print(str(mat1))
      rr <- 12;rc <- 12;
      if(is.null(input$row_cex)==FALSE) rr <- as.numeric(input$row_cex)
      if(is.null(input$col_cex)==FALSE) rc <- as.numeric(input$col_cex);
      #print(rc);print(rr)
      res1 <- draw.heatmap(mat=mat1,use_gene_label = display_row, phenotype_info = phe,use_phe = input$use_phe2,
                           show_row_names=input$show_row_names, show_column_names=input$show_column_names,
                           cluster_rows=input$cluster_rows, cluster_columns=input$cluster_columns,
                           row_names_gp=gpar(fontsize = rr),
                           column_names_gp=gpar(fontsize = rc),scale=input$scale,
                           clustering_distance_rows=input$clustering_distance_rows,clustering_distance_columns=input$clustering_distance_columns)
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
    #
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
  #
    if(control_para$doplot=='doGSEAPlot'){ # 5
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height5)
      use_data$plot_width <- as.numeric(input$plot_width5)
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
                         Z_sig_thre = input$Z_sig_thre)
    }
  #
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
  #
    if(control_para$doplot=='doBubblePlot'){ # 7
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height7)
      use_data$plot_width <- as.numeric(input$plot_width7)
      z_col <- paste0('Z.',input$choose_comp)
      ms_tab <- get_top_ms_tab(ms_tab,input$top_strategy7,input$top_num7,z_col)
      bg_gene <- unique(unlist(lapply(use_data$merge.network,function(x)x$target)))
      #print(str(ms_tab))
      #print(str(bg_gene))
      #print(c(input$label_col7,z_col,input$min_gs_size7,input$max_gs_size7,input$Pv_adj7,input$Pv_thre7,input$top_geneset_number,input$top_num7))
      res1 <- draw.bubblePlot(driver_list = ms_tab$originalID_label, show_label = ms_tab[,input$label_col7],
                      Z_val = ms_tab[,z_col], driver_type = NULL, target_list = use_data$merge.network,
                      transfer2symbol2type = use_data$transfer_tab, bg_list = bg_gene, min_gs_size = input$min_gs_size7,
                      max_gs_size = input$max_gs_size7, use_gs = c(input$use_gs1_7,input$use_gs2_7),
                      display_gs_list = NULL, Pv_adj = input$Pv_adj7, Pv_thre = input$Pv_thre7,
                      top_geneset_number = input$top_geneset_number, top_driver_number = input$top_num7,
                      mark_gene = NULL, driver_cex = input$driver_cex7, gs_cex = input$gs_cex7)
    }
  #
    if(control_para$doplot=='doNetBIDPlot'){ # 8
      if(is.null(use_data$choose_comp)==TRUE) return(p('Please plot volcano plot first in order to choose the targeted comparison !'))
      use_data$plot_height <- as.numeric(input$plot_height8)
      use_data$plot_width <- as.numeric(input$plot_width8)
      DA <- use_data$DA; DE <- use_data$DE;
      DA_list <- input$DA_list;
      DE_list <- input$DE_list;
      choose_comp <- use_data$choose_comp
      choose_comp <- unique(gsub('(.*)_DA','\\1',choose_comp))
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
      mess <- sprintf('%d drivers passed by the filter !',nrow(use_data$tmp_ms_tab));
       tagList(
        fluidRow(
          column(4,offset=0,HTML(mess)),
          column(6,offset=0,actionButton(inputId='doupdateMsTab',label='Update the master table by using the parameters and top number above'))
        )
      )
    }
  })
  ##
  output$plot.ui <- renderUI({
    if(control_para$doplot==FALSE) return()
    tagList(
      div(htmlOutput('plotWarnning')),
      div(htmlOutput('plotPara'),style="align:center;font-size:70%;height:50%;background-color:#F8F9F9;width:100%;margin:0%;padding-left:5%;text-align:center"),
      div(htmlOutput("mainPlot"),style="background-color:#FDFEFE")
    )
  })
}
##

