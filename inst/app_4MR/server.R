## install NetBID2
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.rstudio.com/"
  r["BioCsoft"] <- "https://bioconductor.org/packages/3.9/bioc"
  r["BioCann"] <- "https://bioconductor.org/packages/3.9/data/annotation"
  r["BioCexp"] <- "https://bioconductor.org/packages/3.9/data/experiment"
  options(repos = r)
})
devtools::install_github("jyyulab/NetBID2",ref='master',dependencies='Depends')
##
library(shiny)
library(shinyjs)
library(shinythemes)
library(DT)
#library(NetBID2)
library(shinyFiles)
library(fs)
library(V8)
library(zip)

### need to modify
#search_network_path <- 'data/network_txt/'
#search_eSet_path <- 'data/eSet_RData/'
#pre_project_main_dir <- 'MR_result/'

options(shiny.maxRequestSize = 1000*1024^2) ##
jscode <- "shinyjs.refresh = function() { history.go(0); }"

server <- function(input, output,session){
  if(exists('analysis.par',envir=.GlobalEnv)==TRUE) rm(analysis.par,envir=.GlobalEnv)
  search_network_path <- unique(setdiff(unique(search_network_path),''))
  if(is.null(search_network_path)==FALSE & length(search_network_path)>0){
    pre_path_id <- c('Current Directory','Home','R Installation','Available Volumes')
    w1 <- setdiff(intersect(search_network_path,pre_path_id),'Available Volumes')
    w2 <- setdiff(search_network_path,pre_path_id)
    if(length(w1)>0) volumes_w1 <- c( 'Current Directory'='.',Home = fs::path_home(), "R Installation" = R.home())[w1] else volumes_w1 <- NULL
    if(length(w2)>0){volumes_w2 <- w2; if(is.null(names(volumes_w2))==TRUE){names(volumes_w2)<-sprintf('User Path %s',1:length(w2))}}else{volumes_w2 <- NULL}
    if('Available Volumes' %in% search_network_path) volumes_w3 <- getVolumes()() else volumes_w3 <- NULL
    volumes_network <- c(volumes_w1,volumes_w2,volumes_w3)
  }else{
    volumes_network <- c( 'Current Directory'='.')
  }
  shinyFileChoose(input, "choose_tf_network_file", session = session,roots=volumes_network)
  shinyFileChoose(input, "choose_sig_network_file",session = session,roots=volumes_network)
  #
  search_eSet_path <- unique(setdiff(unique(search_eSet_path),''))
  if(is.null(search_eSet_path)==FALSE & length(search_eSet_path)>0){
    pre_path_id <- c('Current Directory','Home','R Installation','Available Volumes')
    w1 <- setdiff(intersect(search_eSet_path,pre_path_id),'Available Volumes')
    w2 <- setdiff(search_eSet_path,pre_path_id)
    if(length(w1)>0) volumes_w1 <- c( 'Current Directory'='.',Home = fs::path_home(), "R Installation" = R.home())[w1] else volumes_w1 <- NULL
    if(length(w2)>0){volumes_w2 <- w2; if(is.null(names(volumes_w2))==TRUE){names(volumes_w2)<-sprintf('User Path %s',1:length(w2))}}else{volumes_w2 <- NULL}
    if('Available Volumes' %in% search_eSet_path) volumes_w3 <- getVolumes()() else volumes_w3 <- NULL
    volumes_eSet <- c(volumes_w1,volumes_w2,volumes_w3)
  }else{
    volumes_eSet <- c( 'Current Directory'='.')
  }
  shinyFileChoose(input, "choose_eset_RData_file",session = session,roots=volumes_eSet)
  volumes_output <- c( 'Current Directory'='.',Home = fs::path_home())
  if(is.null(pre_project_main_dir)==FALSE){
    if(pre_project_main_dir=='') pre_project_main_dir <- NULL
  }
  if(is.null(pre_project_main_dir)==TRUE) shinyDirChoose(input, "project_main_dir", roots = volumes_output, 
                                                         session = session, restrictions = system.file(package = "base"))
  #shinyFileSave(input, "save", roots = volumes, session = session, restrictions = system.file(package = "base"))
  #
  use_data <- shiny::reactiveValues(eset=NULL,tf_network_file=NULL,sig_network_file=NULL,
                                    project_main_dir='',project_name='',
                                    G0_name='',G1_name='',
                                    comp_name='',intgroup='',
                                    main_id_type='',cal.eset_main_id_type='',
                                    DE_strategy='',use_spe='',cal.eset_use_spe='',
                                    use_level='',pass=0,doQC=FALSE,doPLOT=FALSE,top_number=30)
  control_para <- shiny::reactiveValues(doloadData = FALSE, doanalysis=FALSE,checkanalysis = FALSE) ## control parameters
  shiny::observeEvent(input$loadButton, { control_para$doloadData <- 'doinitialload';})
  shiny::observeEvent(input$loadDemoButton, { control_para$doloadData <- 'doinitialdemoload';})
  shiny::observeEvent(input$doButton, { control_para$doanalysis <- TRUE;},once=FALSE,autoDestroy=FALSE)
  shiny::observeEvent(input$initButton0, { 
    #shinyjs::js$refresh();
    control_para$doloadData <- FALSE; control_para$checkanalysis <- FALSE;control_para$doanalysis <- FALSE;})
  output$filepaths_tf_network_file <- shiny::renderUI({
    shiny::p(parseFilePaths(volumes_network, input$choose_tf_network_file)$datapath)
  })
  output$filepaths_sig_network_file <- shiny::renderUI({
    shiny::p(parseFilePaths(volumes_network, input$choose_sig_network_file)$datapath)
  })
  output$filepaths_choose_eset_RData_file <- shiny::renderUI({
    shiny::p(parseFilePaths(volumes_eSet, input$choose_eset_RData_file)$datapath)
  })
  loadData <- shiny::reactive({
    output$error_message <- shiny::renderUI({shiny::p('')})
    inFile <- input$eset_RData_file
    print(inFile$datapath)
    inFile1 <- list()
    inFile1$datapath <- parseFilePaths(volumes_eSet,input$choose_eset_RData_file)$datapath
    if(is.null(inFile$datapath)==TRUE & length(inFile1$datapath)==0) {
      control_para$doloadData <- FALSE;
      output$error_message <- shiny::renderUI({shiny::p('WARNING : NO upload or choose the RData file for the calculation eset, please check and re-try!')})
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
      output$error_message <- shiny::renderUI({shiny::p('WARNING : NO ExpressionSet class object in the RData file, please check and re-try!')})
      return()
    }
    use_data$eset <- get(all_obj[w2])
    print(all_obj[w2])
    print('Finish loading the dataset')
    #
    inFile_tf1 <- list(); inFile_sig1 <- list();
    inFile_tf1$datapath  <- parseFilePaths(volumes_network,input$choose_tf_network_file)$datapath
    inFile_sig1$datapath <- parseFilePaths(volumes_network,input$choose_sig_network_file)$datapath
    inFile_tf  <- input$tf_network_file
    inFile_sig <- input$sig_network_file
    if(is.null(inFile_tf$datapath)==TRUE & length(inFile_tf1$datapath)==0){
      control_para$doloadData <- FALSE;
      output$error_message <- shiny::renderUI({shiny::p('WARNING : NO choose the TF network file, please check and re-try!')})
      return()
    }
    if(is.null(inFile_sig$datapath)==TRUE & length(inFile_sig1$datapath)==0){
      control_para$doloadData <- FALSE;
      output$error_message <- shiny::renderUI({shiny::p('WARNING : NO choose the SIG network file, please check and re-try!')})
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
  
  loadDemoData <- shiny::reactive({
    eset_demo_path <- 'data/eSet_RData/demo_human_MB_eset.RData'
    load(eset_demo_path)
    use_data$eset <- eset
    use_data$tf_network_file <- 'data/network_txt/Other_network_demo/human_MB.TF_consensus_network_ncol_.txt'
    use_data$sig_network_file <- 'data/network_txt/Other_network_demo/human_MB.SIG_consensus_network_ncol_.txt'
    #use_dir <- system.file('',package = "NetBIDshiny")
    #eset_demo_path <- sprintf('%s/demo1_human/demo_human_MB_eset.RData',use_dir)
    #load(eset_demo_path)
    #use_data$eset <- eset
    #use_data$tf_network_file <- sprintf('%s/demo1_human/human_MB.TF_consensus_network_ncol_.txt',use_dir)
    #use_data$sig_network_file <- sprintf('%s/demo1_human/human_MB.SIG_consensus_network_ncol_.txt',use_dir)
    print('Finish loading the demo dataset')
  })
  output$summaryProject<-shiny::renderUI({
    if(control_para$doloadData==FALSE) return()
    if(control_para$doloadData=='doinitialload') loadData()
    if(control_para$doloadData=='doinitialdemoload') loadDemoData()
    ms_tab <- use_data$ms_tab
    all_comp <- use_data$all_comp
    mess <- sprintf('')
    shiny::HTML(mess)
  })
  output$dirpaths_project_main_dir <- shiny::renderUI({
    shiny::p(sprintf("Output main directory:%s",parseDirPath(volumes_output,input$project_main_dir)),style='color:red')
  })
  output$analysisOption <- shiny::renderUI({
    if(control_para$doloadData==FALSE) return()
    #ensembl <- useEnsembl(biomart = "ensembl", dataset = 'hsapiens_gene_ensembl')
    #tmp1 <- listAttributes(mart = ensembl)$name
    #tmp1 <- tmp1[grep('affy|agilent|illumina',tmp1)]
    all_id_type <- c('external_gene_name','ensembl_gene_id','ensembl_gene_id_version','ensembl_transcript_id','ensembl_transcript_id_version',
                     'refseq_mrna','hgnc_symbol','entrezgene','ucsc','uniprotswissprot','affy_hc_g110','affy_hg_focus','affy_hg_u133a','affy_hg_u133a_2',
                     'affy_hg_u133b','affy_hg_u133_plus_2','affy_hg_u95a','affy_hg_u95av2','affy_hg_u95b','affy_hg_u95c','affy_hg_u95d','affy_hg_u95e','affy_hta_2_0','affy_huex_1_0_st_v2','affy_hugenefl','affy_hugene_1_0_st_v1','affy_hugene_2_0_st_v1','affy_primeview','affy_u133_x3p','agilent_cgh_44b','agilent_gpl6848','agilent_sureprint_g3_ge_8x60k','agilent_sureprint_g3_ge_8x60k_v2','agilent_wholegenome','agilent_wholegenome_4x44k_v1',
                     'agilent_wholegenome_4x44k_v2','illumina_humanht_12_v3','illumina_humanht_12_v4','illumina_humanref_8_v3','illumina_humanwg_6_v1','illumina_humanwg_6_v2','illumina_humanwg_6_v3')
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
    if(is.null(pre_project_main_dir)==TRUE) { ## no pre main directory
      shiny::tagList(
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='intgroup',label='Select the interested sample group for analysis',
                                                      choices=all_int,selected = sel_int)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='G1_name',label='Select type for the case group',
                                                      choices=all_g1,selected = g1)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='G0_name',label='Select type for the control group',
                                                      choices=all_g2,selected = g2))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::textInput(inputId='comp_name',label='Input the comparison name',value=comp_name)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='DE_strategy',label='Choose the analysis strategy',
                                                      choices=c('limma','bid'),selected = 'limma')),
          shiny::column(4,offset=0,shiny::selectInput(inputId='use_level',label='Choose the ID level for the network',
                                                      choices=c('gene','transcript'),selected = 'gene'))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='cal.eset_use_spe',label='Choose the species for calculation dataset',choices=c('human','mouse'),
                                                      selected = 'human')),
          shiny::column(4,offset=0,shiny::selectInput(inputId='use_spe',label='Choose the species for the network files',choices=c('human','mouse'),
                                                      selected = 'human'))
        ),     
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='cal.eset_main_id_type',label='Choose the main id type for calculation dataset',
                                                      choices=all_id_type,selected =from_type)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='main_id_type',label='Choose the main id type for the network files',
                                                      choices=all_id_type,selected =from_type))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shinyDirButton(id='project_main_dir',label='Choose main output directory for the project',
                                                  title='Please choose the directory of the project for saving the output')),
          shiny::column(4,offset=0,shiny::htmlOutput('dirpaths_project_main_dir')),
          shiny::column(4,offset=0,shiny::textInput(inputId='project_name',label='Project name',value=''))
        ),shiny::hr(),
        shiny::HTML('<p><b>More options:</b></p>'),
        shiny::p('Mainly for automatically visualization plot generation for top drivers (Rank by P-value, no filteration for logFC and P-value), 
                 more flexible choice is to use another app in this package by \'NetBIDshiny.run4Vis()\' and load in the RData generated in the output directory.'),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::checkboxInput(inputId='doQC',label='Do QC plot for the network and activity eSet (which will take time) ?',value = FALSE)),
          shiny::column(4,offset=0,shiny::checkboxInput(inputId='doPLOT',label='Do plot for the top drivers (which will take time) ?',value = FALSE)),
          shiny::column(4,offset=0,shiny::numericInput(inputId='top_number',label='Number of top drivers for plotting ?',value = 30,min=10,step=1))
        ),shiny::hr()
      )
    }else{
      shiny::tagList(
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='intgroup',label='Select the interested sample group for analysis',
                                                      choices=all_int,selected = sel_int)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='G1_name',label='Select type for the case group',
                                                      choices=all_g1,selected = g1)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='G0_name',label='Select type for the control group',
                                                      choices=all_g2,selected = g2))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::textInput(inputId='comp_name',label='Input the comparison name',value=comp_name)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='DE_strategy',label='Choose the analysis strategy',
                                                      choices=c('limma','bid'),selected = 'limma')),
          shiny::column(4,offset=0,shiny::selectInput(inputId='use_level',label='Choose the ID level for the network',
                                                      choices=c('gene','transcript'),selected = 'gene'))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='cal.eset_use_spe',label='Choose the species for calculation dataset',choices=c('human','mouse'),
                                                      selected = 'human')),
          shiny::column(4,offset=0,shiny::selectInput(inputId='use_spe',label='Choose the species for the network files',choices=c('human','mouse'),
                                                      selected = 'human'))
        ),     
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::selectInput(inputId='cal.eset_main_id_type',label='Choose the main id type for calculation dataset',
                                                      choices=all_id_type,selected =from_type)),
          shiny::column(4,offset=0,shiny::selectInput(inputId='main_id_type',label='Choose the main id type for the network files',
                                                      choices=all_id_type,selected =from_type))
        ),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::textInput(inputId='project_name',label='Project name',value=''))
        ),shiny::hr(),
        shiny::HTML('<p><b>More options:</b></p>'),
        shiny::p('Mainly for automatically visualization plot generation for top drivers (Rank by P-value, no filteration for logFC and P-value), 
                 more flexible choice is to use another app in this package by \'NetBIDshiny.run4Vis()\' and load in the RData generated in the output directory.'),
        shiny::fluidRow(
          shiny::column(4,offset=0,shiny::checkboxInput(inputId='doQC',label='Do QC plot for the network and activity eSet (which will take time) ?',value = FALSE)),
          shiny::column(4,offset=0,shiny::checkboxInput(inputId='doPLOT',label='Do plot for the top drivers (which will take time) ?',value = FALSE)),
          shiny::column(4,offset=0,shiny::numericInput(inputId='top_number',label='Number of top drivers for plotting ?',value = 30,min=10,step=1))
        ),shiny::hr()
      )
    }
  })
  output$checkReturn <- shiny::renderUI({
    if(control_para$doloadData==FALSE) return()
    #  if(control_para$checkanalysis==FALSE) return()
    if(is.null(pre_project_main_dir)==TRUE){
      j1 <- class(input$project_main_dir)[1]
      #print(j1)
      if(j1!='list'){
        #control_para$doanalysis <- FALSE
        return(shiny::p('WARNING : No selection for the project main directory!',style='color:red;font-size:120%'))
      }
      project_main_dir <- parseDirPath(volumes_output,input$project_main_dir)
    }else{
      project_main_dir <- pre_project_main_dir
    }
    
    j2 <- input$project_name
    #print(j2)
    if(j2==''){
      #control_para$doanalysis <- FALSE
      return(shiny::p('WARNING : No input for the project name !',style='color:red;font-size:120%'))
    }
    project_name <- input$project_name
    if(is.null(pre_project_main_dir)==FALSE){ ## with pre defined dir, add time tag
      current_date <- format(Sys.time(), "%Y-%m-%d")
      project_name <- sprintf('%s_%s',project_name,current_date)
    }
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
    use_data$cal.eset_use_spe <- input$cal.eset_use_spe
    use_data$use_level <- input$use_level
    use_data$pass <- 1
    use_data$doQC <- input$doQC
    use_data$doPLOT <- input$doPLOT
    use_data$top_number <- input$top_number
    return(shiny::tagList(
      h4('Check the options below:'),
      shiny::HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
      shiny::HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
      shiny::HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
      shiny::HTML(sprintf('<p>Main species (network species):<b>%s</b></p>',use_data$use_spe)),
      shiny::HTML(sprintf('<p>Main species (calculation dataset species):<b>%s</b></p>',use_data$cal.eset_use_spe)),
      shiny::HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                          use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
      shiny::HTML('<p>If the species/ID type is not the same between network file and calculation dataset, will use the value in network file ! </p>'),
      shiny::HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
      shiny::HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
      shiny::hr(),
      shiny::fluidRow(
        shiny::column(4,offset=0,shiny::HTML('<p style=\'color:red\'>Click the right button if everything is correct ! <br> And stay at the page until the below message update !</p>')),
        shiny::column(4,offset=0,shiny::actionButton(inputId='doButton',label='Start the driver estimation analysis'))
      ),shiny::hr()
    ))
  })
  output$analysisReturn <- shiny::renderUI({
    if(control_para$doloadData==FALSE) return()
    # if(control_para$checkanalysis==FALSE) return()
    if(use_data$pass==0) return(shiny::tagList(shiny::h4('Result message:'),shiny::p('Input option missing !')))
    if(control_para$doanalysis==FALSE) return(shiny::tagList(shiny::h4('Result message:'),shiny::p('Haven\'t started yet !')))
    output$analysisOption <- shiny::renderUI({})
    output$checkReturn <- shiny::renderUI({})
    db.preload(use_spe=use_data$use_spe,use_level=use_data$use_level,db.dir='db/')
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
    cal.eset_main_id_type <- use_data$cal.eset_main_id_type
    shiny::withProgress(message='processing',value=0.3,{
      # NetBID.lazyMode.DriverEstimation, for species diff input, change eset into network species
      if(use_data$use_spe!=use_data$cal.eset_use_spe){
        shiny::incProgress(0.1, detail = 'Start get ID conversion !')
        to_type <- use_data$main_id_type
        #if(use_data$use_level=='gene') to_type = 'ensembl_gene_id'
        #if(use_data$use_level=='transcript') to_type = 'ensembl_transcript_id'
        transfer_tab1 <- get_IDtransfer_betweenSpecies(from_spe = use_data$cal.eset_use_spe,to_spe=use_data$use_spe,
                                                       from_type = use_data$cal.eset_main_id_type,
                                                       to_type=to_type)
        print(str(transfer_tab1))
        cal.eset_main_id_type <- to_type
        eset <- update_eset.feature(use_eset = eset,use_feature_info = transfer_tab1,
                                    from_feature = sprintf('%s_%s',use_data$cal.eset_main_id_type,toupper(use_data$cal.eset_use_spe)),
                                    to_feature=sprintf('%s_%s',to_type,toupper(use_data$use_spe)))
      }
      if(use_data$doPLOT==TRUE){
        shiny::incProgress(0.1, detail = 'Start calculating')
        analysis.par <- NetBID.lazyMode.DriverEstimation(project_main_dir = project_main_dir,
                                                         project_name = project_name, 
                                                         tf.network.file = use_data$tf_network_file,
                                                         sig.network.file = use_data$sig_network_file, cal.eset = eset, 
                                                         main_id_type = use_data$main_id_type,
                                                         cal.eset_main_id_type = cal.eset_main_id_type, 
                                                         use_level = use_data$use_level,
                                                         transfer_tab = NULL, 
                                                         intgroup = use_data$intgroup, G1_name = use_data$G1_name,
                                                         G0_name = use_data$G0_name, comp_name = use_data$comp_name, do.QC = use_data$doQC,
                                                         DE_strategy = use_data$DE_strategy, return_analysis.par = TRUE)
        shiny::incProgress(0.3, detail = 'Start plotting for top drivers')
        gs.preload(use_spe='Homo sapiens',db.dir='db/')
        #if(use_data$use_spe=='human') gs.preload(use_spe='Homo sapiens')
        #if(use_data$use_spe=='mouse') gs.preload(use_spe='Mus musculus')
        res1 <- NetBID.lazyMode.DriverVisualization(analysis.par=analysis.par,intgroup=use_data$intgroup,use_comp=use_data$comp_name,
                                                    main_id_type=use_data$main_id_type,top_number=use_data$top_number,
                                                    logFC_thre = 0, Pv_thre = 1)
      }else{
        shiny::incProgress(0.1, detail = 'Start calculating')
        analysis.par <- NetBID.lazyMode.DriverEstimation(project_main_dir = project_main_dir,
                                                         project_name = project_name, 
                                                         tf.network.file = use_data$tf_network_file,
                                                         sig.network.file = use_data$sig_network_file, cal.eset = eset, 
                                                         main_id_type = use_data$main_id_type,
                                                         cal.eset_main_id_type = cal.eset_main_id_type, 
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
    if(is.null(pre_project_main_dir)==TRUE){ ## no need to download file
      if(use_data$doPLOT==TRUE){
        return(shiny::tagList(h4('Result message:'),
                              shiny::HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
                              shiny::HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
                              shiny::HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
                              shiny::HTML(sprintf('<p>Main species (network species):<b>%s</b></p>',use_data$use_spe)),
                              shiny::HTML(sprintf('<p>Main species (calculation dataset species):<b>%s</b></p>',use_data$cal.eset_use_spe)),
                              shiny::HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                                                  use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
                              shiny::HTML('<p>If the species/ID type is not the same between network file and calculation dataset, will use the value in network file ! </p>'),
                              shiny::HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
                              shiny::HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
                              shiny::HTML(sprintf('<p style=\'color:red;\'>Finish ! Check Master table excel file in %s/%s/DATA/%s_ms_tab.xlsx <br> 
                                                  RData file in %s/%s/DATA/analysis.par.Step.ms-tab.RData</p>',
                                                  project_main_dir,project_name,project_name,project_main_dir,project_name)),
                              shiny::HTML(sprintf('<p style=\'color:red;\'>Plot for top drivers in %s/%s/PLOT/',
                                                  project_main_dir,project_name)),
                              shiny::HTML('<p>Please click the Refresh button to start another analysis!</p>')))
        
        
      }else{
        return(shiny::tagList(h4('Result message:'),
                              shiny::HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
                              shiny::HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
                              shiny::HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
                              shiny::HTML(sprintf('<p>Main species (network species):<b>%s</b></p>',use_data$use_spe)),
                              shiny::HTML(sprintf('<p>Main species (calculation dataset species):<b>%s</b></p>',use_data$cal.eset_use_spe)),
                              shiny::HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                                                  use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
                              shiny::HTML('<p>If the species/ID type is not the same between network file and calculation dataset, will use the value in network file ! </p>'),
                              shiny::HTML(sprintf('<p>Analysis strategy:<b>%s</b></p>',use_data$DE_strategy)),
                              shiny::HTML(sprintf('<p>Do QC plot:<b>%s</b>; Do plot for top drivers: <b>%s</b></p>',use_data$doQC,use_data$doPLOT)),
                              shiny::HTML(sprintf('<p style=\'color:red;\'>Finish ! Check Master table excel file in %s/%s/DATA/%s_ms_tab.xlsx <br> 
                                                  RData file in %s/%s/DATA/analysis.par.Step.ms-tab.RData</p>',
                                                  project_main_dir,project_name,project_name,project_main_dir,project_name)),
                              shiny::HTML('<p>Please click the Refresh button to start another analysis!</p>')))
      }
    }else{ ## need to download file because of pre-set output directory
      return(shiny::tagList(h4('Result message:'),
                            shiny::HTML(sprintf('<p>Project main directory:<b>%s</b></p>',project_main_dir)),
                            shiny::HTML(sprintf('<p>Project name:<b>%s</b></p>',project_name)),
                            shiny::HTML(sprintf('<p>The case group name :<b>%s</b>;The control group name :<b>%s</b>; The comparison name:<b>%s</b></p>',use_data$G1_name,use_data$G0_name,use_data$comp_name)),
                            shiny::HTML(sprintf('<p>Main species (network species):<b>%s</b></p>',use_data$use_spe)),
                            shiny::HTML(sprintf('<p>Main species (calculation dataset species):<b>%s</b></p>',use_data$cal.eset_use_spe)),
                            shiny::HTML(sprintf('<p>The ID level is at <b>%s</b>; <br>The main ID type for the network files:<b>%s</b>; <br>The main ID type for the calculate eset:<b>%s</b></p>',
                                                use_data$use_level,use_data$main_id_type,use_data$cal.eset_main_id_type)),
                            shiny::HTML('<p>If the species/ID type is not the same between network file and calculation dataset, will use the value in network file ! </p>'),
                            shiny::p('Finish, click the button to download the zipped result file'),
                            shiny::downloadButton(outputId="DownloadRData", label="Download Result Zip File"),shiny::hr(),
                            shiny::HTML('<p>Please click the Refresh button to start another analysis!</p>')))
    }
  })
  output$DownloadRData <- shiny::downloadHandler(
    filename = function() {
      time_tag <- format(Sys.time(), "%Y-%m-%d_%H-%M")
      fn <- sprintf('%s_%s.zip',use_data$project_name,time_tag)
      return(fn)
    },
    content = function(fname) {
      files2zip <- dir(sprintf('%s/%s/',use_data$project_main_dir,use_data$project_name), full.names = TRUE)
      zip::zip(zipfile=fname, files=files2zip)
    },
    contentType = "application/zip"
  )
  }
