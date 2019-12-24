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


####----Data Access----####
con <-
  dbConnect(
    odbc(),
    Driver = "SQL Server",
    Server = "rfh-information",
    Database = "RF_Performance",
    Trusted_Connection = "True"
  )
# simple event log format
# query <- paste0("
#                 SELECT *
#                 FROM div_perf.dbo.CPG_Elective_EventLog3 ")
#event log with specialty and appointment type
query <- paste0("
                SELECT *
                FROM div_perf.dbo.CPG_Elective_EventLog24")



df1 <- dbGetQuery(con,
                  query)

dbDisconnect(con)

ui <- dashboardPage(
  # Application title
  dashboardHeader(title = "Pathway Explorer"),
  
  
  # Sidebar with a slider input for number of bins
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "Dashboard", icon("dashboard"))
    ),
    disable = FALSE,
    collapsed = FALSE,
    selectInput(
      "site",
      "Select the Site",
      c("All", levels(as.factor(df1$Site))),
      multiple = F,
      selectize = T
    ),
    selectInput(
      "CPG",
      "Select CPG",
      c("All", levels(as.factor(
        df1$CPG_PrimaryDiagnosis
      ))),
      selected =  "ElectiveHip",
      selectize = T
    )
    ,
    
    selectInput(
      "activityLevel",
      "Select Level of Activity",
      as.factor(c("Activity", "Detailed Activity")),
      selected = "Detailed Activity",
      selectize = T,
      multiple = F
    ),
    selectInput(
      "trimstart",
      "Filter by Start Activity",
      levels(as.factor(df1$`Detailed Activity`)),
      selectize = T,
      multiple = FALSE,
      selected = "Referral Date"
    ),
    selectInput(
      "activity2",
      "Select Presence of Appointment Types",
      levels(as.factor(df1$`Detailed Activity`)),
      selectize = T,
      multiple = TRUE 
    ),
    selectInput(
      "specialty",
      "Select Specialty at Discharge",
      levels(as.factor(df1$Specialty)),
      selectize = T,
      multiple = TRUE 

    ),
    
    textInput(
      "Referral_ID",
      "Referral ID",
      value = "",
      width = NULL,
      placeholder = NULL
    ),
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

  
  dashboardBody(
    h2("Map"),
    uiOutput("errorBox"),
    withSpinner(svgPanZoomOutput(outputId = 'map')),
    tableOutput('data')
        )
      )

    #)
  #)

   tableOutput('data')
  # ),
  # mainPanel(
  #   tabsetPanel(type = "tab",
  #               tabPanel("Sustained Data",tableOutput("data")) #,
  #               #tabPanel("Original Data (Input)", dataTableOutput("table"))
  #   ))




server <- function(input, output) {
  
  
  #first build the reactive data frame for the event log with all the filters
  df_eventlog <- reactive({
    
    gc() #clear memory
    
    df1 %>%
      mutate(
        activity_instance = 1:nrow(.),
        resource = NA,
        status = "complete"
      ) %>%
      mutate(Activity = !!as.name(input$activityLevel))%>%
      filter(CPG_PrimaryDiagnosis == input$CPG |
               input$CPG == "All") %>%
      filter(Site == input$site | input$site == "All") %>%
      filter(Case_ID == input$Referral_ID |
               input$Referral_ID == "") %>%
      filter(Specialty %in% input$specialty | is.null(input$specialty))
  })
  #
  
  output$errorBox <- renderUI({
    if (nrow(df_eventlog()) != 0)
      return()
    box(
      title = "Error",
      width = NULL,
      status = "danger",
      solidHeader = TRUE,
      "No pathways have been found for the options you have selected. Please try again."
    )
  })
  output$data <- renderTable(df_eventlog() %>% head(100))
  
  output$map <- renderSvgPanZoom({
    if (nrow(df_eventlog()) == 0)
      return()
    
    logForMap <- df_eventlog() %>%
      eventlog(
        case_id = "Case_ID",
        activity_id = "Activity",
        timestamp = "timestamp",
        activity_instance_id = "activity_instance",
        lifecycle_id = "status",
        resource_id = "resource"
      ) %>%
      filter_trim(start_activities = input$trimstart) %>%
      # filter_activity_presence(input$activity2 |
      #                            input$activity2 == "" ) %>%
      filter_activity_frequency(percentage = input$pcnt_act_freq / 100)
    
    process_map(
      logForMap,
      type_nodes = frequency("absolute"),
      type_edges = frequency("relative")
      # type_edges = performance(mean, "days")
      
      ,
      render = FALSE
    ) %>%
      generate_dot() %>%
      grViz(width = 1000, height = 1800) %>%
      export_svg %>%
      svgPanZoom(height = 1800, controlIconsEnabled = TRUE)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
#runApp('//netshare-ds3/Performance/Projects/Pathway Explorer/Code/Pathway Explorer Test App.R')

