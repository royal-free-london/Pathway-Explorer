
DROP TABLE div_perf.dbo.CPG_Elective_EventLog2


select * into div_perf.dbo.CPG_Elective_EventLog2
from (


SELECT distinct J.*, CPG_PrimaryDiagnosis, Site, Specialty_At_Discharge

                   FROM
                   div_perf.dbo.CPG_Elective_EventLog k
                   right join 
                   (select * from(
                   SELECT referral_id as Case_ID, 'Referral Date' as Activity, 'Referral Date' as [Detailed Activity], referral_request_received_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where referral_request_received_date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   
				    SELECT referral_id
        
                   as Case_ID, 'First Outpatient appointment' as Activity, Appointment_Type AS [Detailed Activity], attendance_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 1 and
				   attendance_date between '01/01/2018' and '01/04/2019'

                   UNION ALL
                   
				   SELECT referral_id
        
                   as Case_ID, 'Subsequent Outpatient appointment' as Activity, Appointment_Type AS [Detailed Activity], attendance_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 2 and Outcome_of_Attendance <> 1 and
				   attendance_date between '01/01/2018' and '01/04/2019'

                   UNION ALL

                   SELECT referral_id as Case_ID, 'Final Outpatient Appointment' as Activity, Appointment_Type as [Detailed Activity],
				   attendance_date as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where Outcome_of_Attendance = 1 and attendance_date between '01/01/2018' and '01/04/2019'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Decision to Admit' as Activity, 'Decision to Admit' as [Detailed Activity], Decided_to_Admit_Date as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where Decided_to_Admit_Date between '01/01/2018' and '01/04/2019'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Inpatient Spell' as Activity, 'Inpatient Spell' as [Detailed Activity], [Admission_Date] as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where [Admission_Date] between '01/01/2018' and '01/04/2019'
                   ) a) J
                   on k.referral_id = J.Case_ID
                
        ) a       



------
DROP TABLE div_perf.dbo.CPG_Elective_EventLog3


select * into div_perf.dbo.CPG_Elective_EventLog3
from (


SELECT distinct J.*, CPG_PrimaryDiagnosis, Site

                   FROM
                   div_perf.dbo.CPG_Elective_EventLog k
                   right join 
                   (select * from(
                   SELECT referral_id as Case_ID, 'Referral Date' as Activity, referral_request_received_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where referral_request_received_date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   
				    SELECT referral_id
        
                   as Case_ID, 'First Outpatient appointment' as Activity, attendance_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 1 and
				   attendance_date between '01/01/2018' and '01/04/2019'

                   UNION ALL
                   
				   SELECT referral_id
        
                   as Case_ID, 'Subsequent Outpatient appointment' as Activity, attendance_date as timestamp
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 2 and Outcome_of_Attendance <> 1 and
				   attendance_date between '01/01/2018' and '01/04/2019'

                   UNION ALL

                   SELECT referral_id as Case_ID, 'Final Outpatient Appointment' as Activity,
				   attendance_date as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where Outcome_of_Attendance = 1 and attendance_date between '01/01/2018' and '01/04/2019'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Decision to Admit' as Activity,  Decided_to_Admit_Date as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where Decided_to_Admit_Date between '01/01/2018' and '01/04/2019'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Inpatient Spell' as Activity, [Admission_Date] as timestamp 
				   FROM div_perf.dbo.CPG_Elective_EventLog
                   where [Admission_Date] between '01/01/2018' and '01/04/2019'
                   ) a) J
                   on k.referral_id = J.Case_ID
                
        ) a       




-------
Select * from    div_perf.dbo.CPG_Elective_EventLog
Select * from    div_perf.dbo.CPG_Elective_EventLog2
Select * from    div_perf.dbo.CPG_Elective_EventLog3
