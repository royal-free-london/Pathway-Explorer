.libPaths("Z:/Team/GENESIS working files/R/Rpackages")
.libPaths()

library(odbc) 
library(DBI)
library(tidyverse) 
library(ggplot2)
library(knitr)
library(dplyr)
library(plotly)
library(bupaR)

source("//NETSHARE-DS3/Performance/Team/R/RFLStyle.r")


con <- dbConnect(
  odbc(),
  Driver = "SQL Server",
  Server = "rfh-information",
  Database = "DIV_Perf",  
  Trusted_Connection = "True"
)

#d1 <-
#  # dbGetQuery(con, "select *
#      from [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Backup] A")
# #View(d1)

#memory.limit()
#memory.limit(size = 4095)
#memory.limit()


d2 <- dbGetQuery(con, "select Local_Patient_ID, Attendance_Date, Referral_ID, Attended_or_Did_Not_Attend , Consultant_Code, Main_Specialty_Code, Service_Line_Desc, [Primary_Diagnosis_(ICD)], First_Attendance_Desc, Outcome_of_Attendance_Desc, 
             Appointment_Location, Appointment_Resource, Appointment_Type, 
             specialty_Desc,  referral_request_received_date, [Primary_Procedure_(OPCS)], [Source_of_Referral:_Out-patients_Desc]
             from rf_performance.dbo.rf_performance_opa_main 
           
             where Attendance_Date >= '01/04/2018' 
            " )
View(d2)


eventLog <- d2 %>%
  filter(Consultant_Code == 'C2499381') %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  
  eventlog(
    case_id = "Local_Patient_ID",
    activity_id = "Appointment_Type",
    timestamp = "Attendance_Date",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  )# %>% 
  #filter_trim(start_activities = c("Dermatology New", "Dermatology Target New" ))

simple_EventLog <- bupaR::simple_eventlog(eventlog = d2,
case_id = "Local_Patient_ID",
             activity_id = "Appointment_Type",
             timestamp = "Attendance_Date" )

p1 <- eventLog %>% 
 process_map(type=frequency("relative"))
             

p1
