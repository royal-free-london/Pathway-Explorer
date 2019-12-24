

select * into div_perf.dbo.CPG_Elective_EventLog24
from (

SELECT Case_ID, 'Referral Date' as [Detailed Activity], Resource, referral_request_received_date as timestamp, Specialty, Site, CPG_PrimaryDiagnosis
					FROM div_perf.dbo.CPG_Elective_EventLog_Lite_WIDE

UNION ALL

SELECT Case_ID, 'Decision to Admit' as [Detailed Activity], Consultant_At_Episode as Resource, Decided_to_Admit_Date as timestamp, Specialty, Site, CPG_PrimaryDiagnosis
					FROM
					div_perf.dbo.CPG_Elective_EventLog_Lite_WIDE
         
UNION ALL

SELECT Case_ID, 'Inpatient Spell' as [Detailed Activity], Consultant_At_Episode as Resource, [Admission_Date] as timestamp, Specialty, Site, CPG_PrimaryDiagnosis
				   FROM div_perf.dbo.CPG_Elective_EventLog_Lite_WIDE

UNION ALL

SELECT Case_ID, Appointment_Type AS [Detailed Activity], Appointment_Resource as Resource, attendance_date as timestamp, Specialty, Site, CPG_PrimaryDiagnosis
				   FROM div_perf.dbo.CPG_Elective_EventLog_Lite_WIDE
               
) G


select * from div_perf.dbo.CPG_Elective_EventLog23
select * from div_perf.dbo.CPG_Elective_EventLog24
select * FROM div_perf.dbo.CPG_Elective_EventLog_Lite_WIDE