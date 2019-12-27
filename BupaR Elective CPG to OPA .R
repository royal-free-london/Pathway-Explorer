library(odbc) 
library(DBI)
library(tidyverse) 
library(ggplot2)
library(knitr)
library(dplyr)
library(plotly)
library(bupaR)
library(edeaR)
library(processmapR)
library(processanimateR)
source("//NETSHARE-DS3/Performance/Team/R/RFLStyle.r")


con <- dbConnect(
  odbc(),
  Driver = "SQL Server",
  Server = "rfh-information",
  Database = "DIV_Perf",  
  Trusted_Connection = "True"
)


cpg20 <- dbGetQuery(con, "
              	SELECT *
	FROM div_perf.dbo.CPG_Elective_EventLog3
order by Case_ID, TIMESTAMP
 ")
View(cpg20)

# cpg20 %>%
#   order(Case_ID)
# View(cpg20)

eventLog20 <- cpg20 %>%
  filter(CPG_PrimaryDiagnosis == 'HPB Tumours') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) %>%
  filter_trim(start_activities = ("Referral Date"), end_activities =  c("Final Outpatient Appointment", "Inpatient Spell")) 


# eventLog20 %>%
#   filter_precedence(antecedents = "Referral Date",
#                     consequents = c("First Outpatient Appointment", "Inpatient Spell", "Decision to Admit", "Subsequent Outpatient appointment"),
#                     precedence_type = "eventually_follows",
#                     filter_method = "one_of") %>%
#   traces

p11 <- eventLog20 %>% 
  #filter_activity_frequency(percentage = 0.70) %>%
  #process_map(type=frequency("relative")) # %>%
  process_map(type=performance(mean, "days"))

p11

p12 <- eventLog20 %>%
  process_map(type_nodes = frequency("absolute"),
              type_edges = performance(mean, "days"))
p12

p13 <- eventLog20 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p13

p14 <- eventLog20 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = frequency("absolute"))
p14




eventLog21 <- cpg20 %>%
  filter(Case_ID == '5804890') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) %>%
  filter_trim(start_activities = ("Referral Date"), end_activities =  c("Final Outpatient Appointment", "Inpatient Spell")) 


p15 <- eventLog21 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p15




eventLog22 <- cpg20 %>%
  filter(Case_ID == '4801889') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) 
p16 <- eventLog22 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p16




eventLog23 <- cpg20 %>%
  filter(Case_ID == '6205889') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) 
p17 <- eventLog23 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p17



eventLog24 <- cpg20 %>%
  filter(Case_ID == '1DDFZ7ON29') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) 
p18 <- eventLog23 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p18
