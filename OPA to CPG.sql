select *,
             case 
             when (DATEDIFF(dd,[Discharge Date], op.Attendance_Date)) between 0 and 14 then 'OPA within 14 Days of Discharge'
             when (DATEDIFF(dd,[Discharge Date], op.Attendance_Date)) between 0 and 30 then 'OPA within 30 Days of Discharge'
             when (DATEDIFF(dd,[Discharge Date], op.Attendance_Date)) between 0 and 90  then 'OPA within 90 Days of Discharge'
             else '' end as OPA_Post_Discharge_Flag, (DATEDIFF(dd,[Discharge Date], op.Attendance_Date)) as Days_Between_Discharge_to_OPA,
             1 as Attendance
             from [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics] A
             left join
             (select Local_Patient_ID, Attendance_Date, Referral_ID, Attended_or_Did_Not_Attend , Consultant_Code, Main_Specialty_Code, Service_Line_Desc, [Primary_Diagnosis_(ICD)], First_Attendance_Desc, Outcome_of_Attendance_Desc, 
             Appointment_Location, Appointment_Resource, Appointment_Type, 
             specialty_Desc,  referral_request_received_date, [Primary_Procedure_(OPCS)], [Source_of_Referral:_Out-patients_Desc]
             from rf_performance.dbo.rf_performance_opa_main opa) op
             on a.mrn = op.local_patient_id
             where  op.Attendance_Date >= a.[Discharge Date]
              and [Discharge Date] between  '01/04/2017' AND '31/03/2019' 
             and (DATEDIFF(dd,[Discharge Date], op.Attendance_Date)) between 0 and 90