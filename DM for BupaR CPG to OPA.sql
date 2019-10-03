
-----------

select top 20 * from 
					rf_performance.dbo.rf_performance_opa_main

select top 5 *  FROM
                   [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_backup] 
	--------------

	drop table ##op_link
drop table ##op_link1
drop table ##op_admitted

DECLARE @StartDate AS DATETIME ='01/04/2017'
DECLARE @EndDate AS DATETIME = '01/05/2019'


Select
* into ##op_link
from (
select
ROW_NUMBER() OVER(PARTITION BY Local_Patient_ID,referral_id  ORDER by referral_id DESC) AS N,
  Outcome_of_Attendance_desc,Local_Patient_ID,Attendance_Date,Referral_ID,Specialty_Desc  from rf_performance.dbo.rf_performance_opa_main opa
where 
--Attended_or_Did_Not_Attend in ('5','6','05','06')
--and 
Administrative_Category in ('1','01')
and attendance_date between @StartDate and @EndDate
)as op_ref
where n =1

-----------
DECLARE @StartDate AS DATETIME ='01/04/2017'
DECLARE @EndDate AS DATETIME = '01/05/2019'

select opl.Local_Patient_ID,opl.Attendance_Date as [DischargedFromOPAClinicDate],opl.Referral_ID, Attended_or_Did_Not_Attend, Appointment_Resource,Appointment_Type,
opl.specialty_Desc as Specialty_OP_Discharge,'-' as BlankColumn,opa.referral_request_received_date,opa.Attendance_Date,First_Attendance,Outcome_of_Attendance,
opa.Specialty_Desc as Specialty_OP_Attendance

into ##op_link1
 from  (select * from rf_performance.dbo.rf_performance_opa_main
  where
--((Appointment_Resource NOT LIKE '%POA%') And
--      (Appointment_Resource NOT LIKE '%Pre Admission%') And
--      (Appointment_Resource NOT LIKE '%PAC%') And
--      (Appointment_Resource NOT LIKE '%Pre-op%') And
--      (Appointment_Resource NOT like '%Pre-Assess%')And 
--      (Appointment_Slot_Type NOT like '%Pre-Assess%') And
--      (Appointment_Type NOT LIKE '%POA%') and
--      (Appointment_Type NOT LIKE '%PAC%'))
--	 and
--Attended_or_Did_Not_Attend in ('5','6','05','06')
--and 
Administrative_Category in ('1','01')
	  
	  )
   opa

left join (select * from ##op_link) as opl
on opl.Referral_ID = opa.Referral_ID
and opl.Local_Patient_ID = opa.Local_Patient_ID
and opl.referral_id is not null

 where 
opl.referral_id is not null
and
opa.attendance_date between @StartDate and @EndDate
order by 3,2,1,5,6 ASC


select * from ##op_link1
order by 3,2,1,5,6 ASC

--------
select
Consultant_At_Episode, Consultant_Code,
left(Consultant_Code,2)+right(left(Consultant_Code,8),3)+right(left(Consultant_Code,4),3) as Anon,
financialyear,
MonthYear,
DATEADD(month, DATEDIFF(month, 0, [Discharge Date]), 0) AS SortDate,
[Month],
MRN as LOCAL_PATIENT_ID,
Site,
Decided_to_Admit_Date,
[Spell No],
[Admission Date],
[Discharge Date],
CPG_PrimaryDiagnosis,
ProcedureCategory,
[Primary Diagnosis],
[Primary Procedure],
Spells,
case when [Primary Procedure] like '%J18%' then 'Cholecystectomy Subset' else 'Others' 
end as CholecystectomyPathway,
case
WHEN [Procedure Codes] LIKE '%J021%' AND [Procedure Codes] LIKE '%J024%' THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J022%' AND [Procedure Codes] LIKE '%J024%' THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J021%'  THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J022%' THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J026%' AND [Procedure Codes] LIKE '%J024%' THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J027%' AND [Procedure Codes] LIKE '%J024%' THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J024%'  THEN 'Liver'
WHEN [Procedure Codes] LIKE '%J023%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J031%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J032%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J033%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J034%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J035%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J038%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J039%' AND [Procedure Codes] LIKE '%J071%' AND [Procedure Codes] LIKE '%Y70[3]%' THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J021%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J022%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J023%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J024%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J025%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J026%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J027%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J028%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J029%'  THEN 'Liver'

WHEN [Procedure Codes] LIKE '%J551%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J552%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J558%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J559%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J561%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J562%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J563%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J564%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J568%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J569%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J571%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J572%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J573%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J574%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J575%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J578%' THEN 'Pancreas'
WHEN [Procedure Codes] LIKE '%J579%' THEN 'Pancreas'
else 'Other' end as HPBTumoursPathway,
case when ElectiveWaitInDays = 0 then  ''  else ElectiveWaitInDays end as ElectiveWaitInDays
into ##op_admitted
from
[DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics_Report] cpg
where 
[Elective/Non-Elective] = 'Elective'


select * from ##op_admitted


-------------- Join

DROP TABLE div_perf.dbo.CPG_Elective_EventLog

select Consultant_At_Episode, Consultant_Code, Anon,
financialyear, a.LOCAL_PATIENT_ID,
MonthYear,	
SortDate,
Month,	
Site,	
Decided_to_Admit_Date,
[Spell No],
[Admission Date] as Admission_Date,
[Discharge Date],
[CPG_PrimaryDiagnosis],
[ProcedureCategory],
[Primary Diagnosis],
[Primary Procedure],Spells,
CholecystectomyPathway,
HPBTumoursPathway,	
ElectiveWaitInDays,	'-' as BlankColumn,
op.Attendance_Date,
referral_id
,Attended_or_Did_Not_Attend, Appointment_Resource,Appointment_Type,
Specialty_OP_Discharge,
referral_request_received_date,
First_Attendance,
Outcome_of_Attendance



into div_perf.dbo.CPG_Elective_EventLog
 from ##op_admitted a
 
left join (select * from ##op_link1 ) as op 
on a.LOCAL_PATIENT_ID = op.local_patient_id













select * from div_perf.dbo.CPG_Elective_EventLog