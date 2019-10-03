library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(bupaR)
library(odbc)
library(lubridate)
library(edeaR)
library(processmapR)
library(shinyAce)
library(DiagrammeR)
library(DiagrammeRsvg)
library(svgPanZoom)
library(shinyjqui)
library(tidyverse)


ui <- dashboardPage(
  # Application title
  dashboardHeader(title = "Pathway Explorer TEST"),
  
  # Sidebar with a slider input for number of bins
  
  dashboardSidebar(
    disable = FALSE,
    collapsed = FALSE,
    selectInput(
     "site",
      "Select the Site",
      c("All", "ROYAL FREE HOSPITAL", "BARNET HOSPITAL"),
      multiple = F,
       selectize = T
     ),
    selectInput(
      "CPG",
      "Select CPG",
      c(
        "Haematuria",
        "Dyspepsia",
        "InflamBowelDisease",
        "HeartFailure",
        "ElectiveKnee",
        "ElectiveHip",
        "HPB Tumours",
        "Cataracts",
        "COPD",
        "RightUpperQuadrantPain",
        "IOL_Balloon_Other",
        "InflamBowelDisease",
        "AcuteKidneyInjury",
        "Vascular Prehab",
        "PaediatricDIB",
        "ChestPain",
        "Pneumonia",
        "AcuteTonsilitis",
        "Epistaxis",
        "PulmonaryEmbolism"
      ),
      selected =  "HPB Tumours",
      selectize = T
    ),
    selectInput(
      "activity",
      "select activity",
      as.factor(
        c(
          "decision to admit",
          "referral date",
          "first outpatient appointment",
          "subsequent outpatient appointment",
          "inpatient spell",
          "final outpatient appointment"
        )
      ),
      
      selected = as.factor(
        c(
          "decision to admit",
          "referral date",
          "first outpatient appointment",
          "subsequent outpatient appointment",
          "inpatient spell",
          "final outpatient appointment"
        )
      ),
      selectize = T,
      multiple = TRUE
    ),
    
    textInput("Referral_ID", "Referral ID", 
              value = "", width = NULL, placeholder = NULL),
    sliderInput(
      "pcnt_act_freq",
      "% all activity to show",
      0,
      100,
      70,
      step = 10,
      post  = " %"
    ),
    div(style = "text-align:center", submitButton("Update Pathway Map", icon("refresh")))
  ),
  
  dashboardBody(h2("Map"),
                withSpinner(
                  svgPanZoomOutput(outputId = 'map')
                )#, 
                #textOutput("inputLog")
  )
)
  
  server <- function(input, output) {
    
    #output$inputLog <- renderText({class(input$site)})
    
    output$map <- renderSvgPanZoom({
      ###---- Variables ----####
      site <- input$site 
      CPG_PrimaryDiagnosis <- input$CPG
      Activity <- input$Activity
      Case_ID <- input$Referral_ID
      pcnt_act_freq <- input$pcnt_act_freq / 100
      
      ####----Data Access----####
      con <-
        dbConnect(
          odbc(),
          Driver = "SQL Server",
          Server = "rfh-information",
          Database = "RF_Performance",
          Trusted_Connection = "True"
        )
      
      
      query <- paste0("              	SELECT *
                      FROM div_perf.dbo.CPG_Elective_EventLog3
                      ")
      
      df1 <- dbGetQuery(con,
                        query)
      dbDisconnect(con)
      
      ####----Data Prep----####
      
      ##create initial eventlog and  filter for cpg
      eventLog20 <- df1 %>%
        mutate(
          activity_instance = 1:nrow(.),
          resource = NA,
          status = "complete"
        ) %>%
        filter(CPG_PrimaryDiagnosis==input$CPG)

      #if site selected filter for site
      if(length(input$site)!="All") {
        eventLog20 <- eventLog20 %>%
          filter(site ==input$site)
        }
      
      if(isTruthy(input$Referral_ID)) {
        eventLog20 <- eventLog20 %>%
          filter(case_id==input$Referral_ID)
      }
      
        
      eventLog20 <- eventLog20 %>%
        eventlog(
          case_id = "Case_ID",
          activity_id = "Activity",
          timestamp = "timestamp",
          activity_instance_id = "activity_instance",
          lifecycle_id = "status",
          resource_id = "resource"
        )# %>%
        # filter_trim(
        #   start_activities = "Referral Date",
        #   end_activities =  c("Final Outpatient Appointment", "Inpatient Spell")
        # )
      
      
      ##Filter the event log for map based on other user selections
      
      logForMap <-
        filter_activity_frequency(eventLog20, percentage = pcnt_act_freq) # filter by % activity threashold
      
      # logForMap <- eventlog20 %>%   process_map(type_nodes = frequency("relative"),
      #                                          type_edges = performance(mean, "days"))
      
      #if (!is.null(input$CPG)) {
      #  logForMap <- filter_trim(logForMap, start_activities = Activity)
      #}
      process_map(logForMap,
                  type_nodes = frequency("absolute"),
                  type_edges = performance(mean, "days")
                  
                  #type = frequency("relative")
                  , render = FALSE) %>%
        generate_dot() %>% 
        grViz(width = 800, height = 1600) %>% 
        export_svg %>% 
        svgPanZoom(height=800, controlIconsEnabled = TRUE)
    })
    
  }
  
  # Run the application
  shinyApp(ui = ui, server = server)
