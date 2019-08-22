#.libPaths("Z:/Team/GENESIS working files/R/Rpackages")
#.libPaths()

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
source("//NETSHARE-DS3/Performance/Team/R/RFLStyle.r")


con <- dbConnect(
  odbc(),
  Driver = "SQL Server",
  Server = "rfh-information",
  Database = "DIV_Perf",  
  Trusted_Connection = "True"
)


cpg1 <- dbGetQuery(con, "
SELECT distinct J.*, mrn, CPG_PrimaryDiagnosis, [Admission Date],  Decided_to_Admit_Date,
CASE WHEN [Admission Date] is null then 'Not Admitted'
                   when Decided_to_Admit_Date is null then 'Not Admitted'
                   else 'Admitted' end as Inpatient_Flag
                   FROM
                   [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics] k
                   right join 
                   ( select * from(
                   SELECT local_patient_id
                   --COALESCE(local_patient_id,
                   --convert(varchar, referral_request_received_date, 112))
                   as Case_ID, 'Referral Date' as Activity, referral_request_received_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
                   where referral_request_received_date between '01/01/2018' and '31/01/2018'
                   UNION ALL
                   
                   SELECT local_patient_id
                   -- COALESCE(local_patient_id,referral_request_received_date)
                   as Case_ID, 'Outpatient appointment' as Activity, attendance_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
                   where attendance_date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   
                   SELECT local_patient_id as Case_ID, 'Final Outpatient Appointment' as Activity, attendance_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
                   where Outcome_of_Attendance = 1 and attendance_date between '01/01/2018' and '31/03/2019'
                   UNION ALL
                   
                   SELECT mrn as Case_ID, 'Decision to Admit' as Activity, Decided_to_Admit_Date as timestamp FROM [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Report] 
                   where Decided_to_Admit_Date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   SELECT mrn as Case_ID, 'Inpatient Spell' as Activity, [Admission Date] as timestamp FROM [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Report] 
                   where [Admission Date] between '01/01/2018' and '31/12/2018'
                   ) a) J
                   on k.mrn = J.Case_ID
                   WHERE  
                   ([Admission Date]  between '01/01/2018' and '31/12/2018' OR ([Admission Date] is null))
                   AND
                   (Decided_to_Admit_Date between '01/01/2018' and '31/12/2018' OR (Decided_to_Admit_Date is null)) 
                   AND  (decided_to_admit_Date < [Admission Date] OR ([Admission Date] is null) or Decided_to_Admit_Date is null)
                   
")
View(cpg1)



eventLog11 <- cpg1 %>%
  filter(CPG_PrimaryDiagnosis == 'Cataracts') %>%
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
  filter_trim(start_activities = ("Referral Date"), end_activities =  c("Final Outpatient Appointment"))

p11 <- eventLog11 %>% 
   #filter_activity_frequency(percentage = 0.70) %>%
 #process_map(type=frequency("relative")) # %>%
  process_map(type=performance(mean, "days"))

p11

p12 <- eventLog11 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p12





############CPG ELECTIVE WITH BACKUP TABLE

cpg2 <- dbGetQuery(con, "
SELECT distinct J.*, mrn, CPG_PrimaryDiagnosis, [Admission Date],  Decided_to_Admit_Date, [Elective/Non-Elective],
CASE WHEN [Admission Date] is null then 'Not Admitted'
when Decided_to_Admit_Date is null then 'Not Admitted'
else 'Admitted' end as Inpatient_Flag
FROM
[DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Backup] k
right join 
( select * from(
  SELECT local_patient_id
  --COALESCE(local_patient_id,
             --convert(varchar, referral_request_received_date, 112))
  as Case_ID, 'Referral Date' as Activity, referral_request_received_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
  where referral_request_received_date between '01/01/2018' and '31/01/2018'
  UNION ALL
  
  SELECT local_patient_id
  -- COALESCE(local_patient_id,referral_request_received_date)
  as Case_ID, 'Outpatient appointment' as Activity, attendance_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
  where attendance_date between '01/01/2018' and '31/12/2018'
  UNION ALL
  
  
  SELECT local_patient_id as Case_ID, 'Final Outpatient Appointment' as Activity, attendance_date as timestamp FROM rf_performance.dbo.rf_performance_opa_main
  where Outcome_of_Attendance = 1 and attendance_date between '01/01/2018' and '31/03/2019'
  UNION ALL
  
  SELECT mrn as Case_ID, 'Decision to Admit' as Activity, Decided_to_Admit_Date as timestamp FROM [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Report_Backup] 
  where Decided_to_Admit_Date between '01/01/2018' and '31/12/2018'
  UNION ALL
  
  SELECT mrn as Case_ID, 'Inpatient Spell' as Activity, [Admission Date] as timestamp FROM [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Report_backup] 
  where [Admission Date] between '01/01/2018' and '31/12/2018'
) a) J
on k.mrn = J.Case_ID
WHERE  
([Admission Date]  between '01/01/2018' and '31/12/2018' OR ([Admission Date] is null))
AND
(Decided_to_Admit_Date between '01/01/2018' and '31/12/2018' OR (Decided_to_Admit_Date is null)) 
AND  (decided_to_admit_Date < [Admission Date] OR ([Admission Date] is null) or Decided_to_Admit_Date is null)
")

View(cpg2)

cpg2 <- drop_na(cpg2)


eventLog12 <- cpg2 %>%
  mutate(
    activity_instance = 1:nrow(.),
    resource = NA,
    status = "complete"
  ) %>%
  filter("Elective/Non-Elective" == 'Elective') %>% 
  eventlog(
    case_id = "Case_ID",
    activity_id = "Activity",
    timestamp = "timestamp",
    activity_instance_id = "activity_instance",
    lifecycle_id = "status",
    resource_id = "resource"
  ) %>%
  filter_trim(start_activities = ("Referral Date"), end_activities =  c("Final Outpatient Appointment"))

p13 <- eventLog12 %>% 
  #filter_activity_frequency(percentage = 0.70) %>%
  process_map(type=frequency("relative")) %>%
  #process_map(type=performance(mean, "days"))

p13

p14 <- eventLog12 %>%
  process_map(type_nodes = frequency("relative"),
              type_edges = performance(mean, "days"))
p14




