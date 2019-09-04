SELECT distinct J.*, LOCAL_PATIENT_ID, referral_id, CPG_PrimaryDiagnosis, [Admission_Date],  Decided_to_Admit_Date, 
CASE WHEN [Admission_Date] is null then 'Not Admitted'
                   when Decided_to_Admit_Date is null then 'Not Admitted'
                   else 'Admitted' end as Inpatient_Flag
                   FROM
                   div_perf.dbo.CPG_Elective_EventLog k
                   right join 
                   ( select * from(
                   SELECT referral_id
              
                   as Case_ID, 'Referral Date' as Activity, referral_request_received_date as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where referral_request_received_date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   
				    SELECT referral_id
        
                   as Case_ID, 'First Outpatient appointment' as Activity, attendance_date as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 1 and
				    attendance_date between '01/01/2018' and '31/12/2018'

                   UNION ALL
                   
				   SELECT referral_id
        
                   as Case_ID, 'Subsequent Outpatient appointment' as Activity, attendance_date as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where First_Attendance = 2 and Outcome_of_Attendance <> 1 and
				    attendance_date between '01/01/2018' and '31/12/2018'

                   UNION ALL


                   SELECT referral_id as Case_ID, 'Final Outpatient Appointment' as Activity, attendance_date as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where Outcome_of_Attendance = 1 and attendance_date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Decision to Admit' as Activity, Decided_to_Admit_Date as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where Decided_to_Admit_Date between '01/01/2018' and '31/12/2018'
                   UNION ALL
                   
                   SELECT referral_id as Case_ID, 'Inpatient Spell' as Activity, [Admission_Date] as timestamp FROM div_perf.dbo.CPG_Elective_EventLog
                   where [Admission_Date] between '01/01/2018' and '31/12/2018'
                   ) a) J
                   on k.referral_id = J.Case_ID
                   WHERE  
                   ([Admission_Date]  between '01/01/2018' and '31/12/2018' OR ([Admission_Date] is null))
                   AND
                   (Decided_to_Admit_Date between '01/01/2018' and '31/12/2018' OR (Decided_to_Admit_Date is null)) 
                   AND  (decided_to_admit_Date < [Admission_Date] OR ([Admission_Date] is null) or Decided_to_Admit_Date is null)
                     