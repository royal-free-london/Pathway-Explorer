
--drop table ##GA_Nautilus_WardStays_Link_IP1
--drop table ##For_COVID_AE_JOIN1
--DROP TABLE ##For_COVID_IP_JOIN1
--drop table ##COVID_Tests_Resulted_ALL_2
--drop table ##COVID_Tests_Resulted_ALL_SpellLevel_2
--drop table ##COVID_Tests_Resulted_Coded1
--drop table ##COVID_Tests_Resulted_OP1
--drop table ##COVID_Tests_AE_Inpatients_GA1
--drop table ##GA_Nautilus_WardStays_Link1 
--drop table ##SW_DeathsOnSpineDATA
--drop table ##GA_Nautilus_WardStays_Link1
--TEMP TABLE FOR WARD STAYS


--drop table ##GA_Nautilus_WardStays_Link1

select * into ##GA_Nautilus_WardStays_Link1 
from (select a.*, cons_ENCNTR_SLICE_ID  from  [RFLCFVM186-82].[TRANS_RFL835].[INP].[WARD_STAYS] a
left join [RFLCFVM186-82].[TRANS_RFL835].[INP].[WARDSTAYTOEPISODE] b on a.ENCNTR_SLICE_ID = ward_ENCNTR_SLICE_ID and a.encntr_id = b.encntr_id) data

--select * from ##GA_Nautilus_WardStays_Link1

------------------------------------------------------ICU TABLES

--drop table ##GA_Nautilus_WardStays_Link_IP1

SELECT * INTO  ##GA_Nautilus_WardStays_Link_IP1
FROM 
(select Spell_Number, hosp_prvdr_ident, LOCAL_PATIENT_Identifier,
 ENCOUNTER_ID, main_specialty_description, ward_Start_dt_tm ,ward_End_dt_tm 
,CASE 
----------- COVID ITU WARDS CHANGED ON THE 05-06-2020 TO THE LIST BELOW
	WHEN ward_name like '%RAL ICU 4 SOUTH%' THEN 1 
	WHEN ward_name like '%RAL ICU 4 WEST%' THEN 1
	WHEN ward_name like '%RAL ICU 4 EAST%' THEN 1 
	WHEN ward_name like '%RAL 3 NORTH A%' THEN 1 
	WHEN ward_name like '%RAL SHDU 3%' THEN 1 
	WHEN ward_name like '%RAL BH-CC North%' THEN 1
	WHEN ward_name like '%RAL BH-CC South%' THEN 1 
	ELSE 0 END AS [Updated WardStays ICU Flag]
	
----------- COVID ITU WARDS CHANGED FOR SECOND SURGE TO THE LIST BELOW	
,CASE
	WHEN ward_name like '%RAL ICU 4 SOUTH%' THEN 1 
	WHEN ward_name like '%RAL ICU 4 WEST%' THEN 1
	WHEN ward_name like '%RAL ICU 4 EAST%' THEN 1 
	WHEN ward_name like '%RAL 2 NORTH A%' THEN 1 
	WHEN ward_name like '%RAL 2 NORTH - PITU%' THEN 1 
	WHEN ward_name like '%RAL SHDU 3%' THEN 1 
	WHEN ward_name like '%RAL Main Recovery Ward%' THEN 1 
	WHEN ward_name like '%RAL Recovery 2 Ward%' THEN 1 
	WHEN ward_name like '%RAL BH-CC North%' THEN 1
	WHEN ward_name like '%RAL BH-CC South%' THEN 1 	
	WHEN ward_name like '%RAL BH-Beech%' THEN 1 	
	ELSE 0 END AS [2nd Surge ICU Flag]
	
,CASE 
	WHEN ward_name like '%ITU3%' THEN 1
	WHEN ward_name like '%ICU%' THEN 1
	WHEN ward_name like '%RAL Main Recovery Ward%' THEN 1 
	WHEN ward_name like '%RAL Recovery 2 Ward%' THEN 1 
	WHEN ward_name like '%RAL 11 West%' THEN 1
	WHEN ward_name like '%RAL 11 South%' THEN 1
	WHEN ward_name like '%RAL 12 East B%' THEN 1 
----------- COVID ITU WARDS CHANGED ON THE 05-06-2020 TO THE LIST BELOW
	--WHEN ward_name like '%RAL ICU 4 SOUTH%' THEN 1 
	--WHEN ward_name like '%RAL ICU 4 WEST%' THEN 1
	--WHEN ward_name like '%RAL ICU 4 EAST%' THEN 1 
	--WHEN ward_name like '%RAL 3 NORTH A%' THEN 1 
	--WHEN ward_name like '%RAL SHDU 3%' THEN 1 
	--WHEN ward_name like '%RAL BH-CC North%' THEN 1
	--WHEN ward_name like '%RAL BH-CC South%' THEN 1 
	--WHEN ward_name like '%RAL BH-Recover%' THEN 1 
	
----------- COVID ITU WARDS CHANGED FOR SECOND SURGE TO THE LIST BELOW	
	
	WHEN ward_name like '%RAL ICU 4 SOUTH%' THEN 1 
	WHEN ward_name like '%RAL ICU 4 WEST%' THEN 1
	WHEN ward_name like '%RAL ICU 4 EAST%' THEN 1 
	WHEN ward_name like '%RAL 2 NORTH A%' THEN 1 
	WHEN ward_name like '%RAL 2 NORTH - PITU%' THEN 1 
	WHEN ward_name like '%RAL SHDU 3%' THEN 1 
	WHEN ward_name like '%RAL Main Recovery Ward%' THEN 1 
	WHEN ward_name like '%RAL Recovery 2 Ward%' THEN 1 
	WHEN ward_name like '%RAL BH-CC North%' THEN 1
	WHEN ward_name like '%RAL BH-CC South%' THEN 1 	
	WHEN ward_name like '%RAL BH-Beech%' THEN 1 	
	
	
	
	ELSE 0 END AS [WardStays ICU Flag]
,Last_Episode_In_Spell_Indicator 
,ward_name
,datediff(dd,ward_Start_dt_tm,ward_End_dt_tm) as [LOS in ICU Ward]
,datediff(hour,ward_Start_dt_tm,ward_End_dt_tm) as [LOS (Hours) in ICU Ward]
,ROW_NUMBER()over(partition by Spell_Number order by ward_Start_dt_tm asc) as N_WardStays
from [RFLCFVM186-82].[TRANS_RFL835].[INP].[REPORTING_LAYER_LIVE] apc
left join  ##GA_Nautilus_WardStays_Link1 ws
on  WS.cons_ENCNTR_SLICE_ID = APC.Encounter_Slice_ID
where 
-------INCLUDING ORIGINAL LIST OF COVID ICU WARDS 
ward_name like '%ICU%' OR  ward_name like '%ITU3%'  

or ward_name like '%RAL Main Recovery Ward%'  
or ward_name like '%RAL Recovery 2 Ward%'  
or ward_name like '%RAL 11 West%' 
or ward_name like '%RAL 11 South%' 
or ward_name like '%RAL 12 East B%' OR
 ward_name like '%ICU2%' or


----------- COVID ITU WARDS CHANGED ON THE 05-06-2020 TO THE LIST BELOW


 ward_name like '%RAL ICU 4 SOUTH%' 
or ward_name like '%RAL ICU 4 WEST%' 
or ward_name like '%RAL ICU 4 EAST%' 
or ward_name like '%RAL 3 NORTH A%'
or ward_name like '%RAL SHDU 3%'
or ward_name like '%RAL BH-CC North%' 
or ward_name like '%RAL BH-CC South%' 
or ward_name like '%RAL BH-Recover%'


	
----------- COVID ITU WARDS CHANGED FOR SECOND SURGE TO THE LIST BELOW	
	

	OR ward_name like '%RAL 2 NORTH A%' 
	OR ward_name like '%RAL 2 NORTH - PITU%' 
	OR ward_name like '%RAL BH-Beech%' 	


) DATA
where Last_Episode_In_Spell_Indicator  = 1

--select *  from  ##GA_Nautilus_WardStays_Link_IP1 base


--SELECT DISTINCT WARD_NAME FROM ##GA_Nautilus_WardStays_Link1
--ORDER BY WARD_NAME

--------------- DEATHS FROM SPINE ---------------------------------------------------
----------------------------------------


--drop table ##SW_DeathsOnSpine 
                                                                                                              
 SELECT  NHSNUMBER,[MRN],min(DeceasedDate) as DeceasedDate, 1 as Died into ##SW_DeathsOnSpine 
 FROM (select [NHSNUMBER], [MRN], min(cast([Deceased_DT_TM] as date))  as DeceasedDate 
 FROM [RF_PIEDWOut].[CERNERRFL].[DeceasedPatients]
 where cast([Deceased_DT_TM] as date)  between '01/01/2020' and getdate()
 group by NHSNUMBER,[MRN]) as data
 group by NHSNUMBER,[MRN],DeceasedDate

--select * from ##SW_DeathsOnSpine 

---------------------------------------------------------------------------------------------------

-------------AE------------------------------------------------------------


--drop table ##For_COVID_AE_JOIN1


SELECT DISTINCT * INTO ##For_COVID_AE_JOIN1
FROM (
select distinct
DATEADD(DD, -(DATEPART(DW,Arrival_Date)-1),Arrival_Date) AS [Arrival_Week_Beginning],
convert(varchar(7),[Arrival_Date],121) as [AE Arrival Month Year],
DATEPART(month,[Arrival_Date_Time]) AS [AE Arrival Month],
clin.PRIMARY_DIAGNOSIS_DESCRIPTION as AE_PRIMARY_DIAGNOSIS_DESCRIPTION , 
admn.Presentation AS AE_Presentation,
perf.ENCOUNTER_ID as AE_ENCNTR_ID
,CASE
	WHEN DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time] )/365.25 BETWEEN 0 AND 17.99999 THEN '00-17'
	WHEN DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time])/365.25 BETWEEN 18 AND 64.99999 THEN '18-64'
	WHEN DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time] )/365.25 BETWEEN 65 AND 79.99999 THEN '65-79'	
	WHEN DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time])/365.25 >= 80 THEN '80+' 
	ELSE '' END AS 'AE Age_Band_Detailed'
,(DATEDIFF(DD,Date_of_Birth,[Arrival_Date])/365.25)  AS AE_Age
,CASE 
	WHEN  (DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time])/365.25) <18 THEN 'Paeds'
	WHEN  (DATEDIFF(DD,Date_of_Birth,[Arrival_Date_Time])/365.25) <66 THEN 'Adult'
	ELSE 'Elderly'  END AS 'AE Age Band',
perf.* 
,Case when (Concat(clin.PRIMARY_DIAGNOSIS_DESCRIPTION,admn.Presentation) Like '%COVID%' 
   or Concat(clin.PRIMARY_DIAGNOSIS_DESCRIPTION,admn.Presentation) Like '%SARS%' 
   or Concat(clin.PRIMARY_DIAGNOSIS_DESCRIPTION,admn.Presentation) Like '%CORONAVIRUS%'  
   or Concat(clin.PRIMARY_DIAGNOSIS_DESCRIPTION,admn.Presentation) Like '%COVID 2%' 
   or Concat(clin.PRIMARY_DIAGNOSIS_DESCRIPTION,admn.Presentation) Like '%COVID19%') 
   Then 1 Else 0 End as AE_Flag_COVID
,1 as AE_Attendance 

FROM [RFLCFVM186-82].[TRANS_RFL835].[ED].[REPORTING_LAYER_LIVE] perf
LEFT JOIN (
select ENCNTR_ID AS clin_ENCNTR_ID, PRIMARY_DIAGNOSIS_DESCRIPTION from
[RFLCFVM186-82].[TRANS_RFL835].[ED].[CLINICAL]) clin
ON perf.ENCOUNTER_ID = clin.clin_ENCNTR_ID
LEFT JOIN (
select ENCNTR_ID as admn_ENCNTR_ID, Presentation from [RFLCFVM186-82].[TRANS_RFL835].[ED].[ADMIN]) admn
ON perf.ENCOUNTER_ID = admn.admn_ENCNTR_ID
where [Arrival_Date_Time] >= '2020-01-01'
) DATA



---- IP TEMP TABLE------------------------------------

--DROP TABLE ##For_COVID_IP_JOIN1


SELECT * INTO ##For_COVID_IP_JOIN1
FROM(
SELECT DISTINCT
T.[Local_Patient_Identifier] AS IP_Local_Patient_Identifier
,DATEADD(DD, -(DATEPART(DW,Admission_Date)-1),Admission_Date) AS [Admission_Week_Beginning]
,Admission_Date 
,Admission_Date_Time 
,Discharge_Date 
,Discharge_Date_Time 
,datediff(dd,Admission_Date ,Discharge_Date) as LoS,
datediff(hour,Admission_Date_Time ,Discharge_Date_Time) as LoS_hrs
,CASE 
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time ) <3 THEN 1
	WHEN DATEDIFF(DD,Admission_Date_Time ,Discharge_Date_Time ) >2 THEN 0
	end as AmbulatoryRateNumerator
,1 as AmbulatoryRateDenomumerator
,CASE 
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <1 THEN '0'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <2 THEN '1'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <3 THEN '2'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <4 THEN '3'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <5 THEN '4'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <6 THEN '5'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <7 THEN '6'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <8 THEN '7'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <9 THEN '8'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <10 THEN '9'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <11 THEN '10'
	WHEN DATEDIFF(DD,Admission_Date_Time,Discharge_Date_Time) <12 THEN '11'
	ELSE '11+'   END AS 'LOS Band'
,gender_code as IP_Gender_Code
,gender_Description as IP_gender_Description
,Ethnic_Category_Code as IP_Ethnic_Category_Code
,Ethnic_Category_Description AS IP_Ethnic_Category_Description
,AGE_ON_ARRIVAL
,CASE
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 0 AND 17.99999 THEN '00-17'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 18 AND 64.99999 THEN '18-64'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 65 AND 79.99999 THEN '65-79'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 >= 80 THEN '80+' 
	ELSE '' END AS 'IP Age_Band_Detailed'
	
,CASE
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 0 AND 9.99999 THEN '0-9'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 10 AND 19.99999 THEN '10-19'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 20 AND 29.99999 THEN '20-29'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 30 AND 39.99999 THEN '30-39'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 40 AND 49.99999 THEN '40-49'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 50 AND 59.99999 THEN '50-59'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 60 AND 69.99999 THEN '60-69'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 70 AND 79.99999 THEN '70-79'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 80 AND 89.99999 THEN '80-89'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 >= 90 THEN '90+'
	ELSE '' END AS 'Age_Band_10yr'	

,CASE
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 0 AND 4.99999 THEN '0-4'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 5 AND 9.99999 THEN '5-9'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 10 AND 14.99999 THEN '10-14'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 15 AND 19.99999 THEN '15-19'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 20 AND 24.99999 THEN '20-25'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 25 AND 29.99999 THEN '25-29'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 30 AND 34.99999 THEN '30-34'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 35 AND 39.99999 THEN '35-39'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 40 AND 44.99999 THEN '40-44'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 45 AND 49.99999 THEN '45-49'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 50 AND 54.99999 THEN '50-54'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 55 AND 59.99999 THEN '55-59'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 60 AND 64.99999 THEN '60-64'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 65 AND 69.99999 THEN '65-69'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 70 AND 74.99999 THEN '70-74'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 75 AND 79.99999 THEN '75-79'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 80 AND 84.99999 THEN '80-84'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 85 AND 89.99999 THEN '85-89'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 >= 90 THEN '90+'
	ELSE '' END AS 'Age_Band_5yr'
	
,CASE
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 0 AND 4.99999 THEN '0'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 5 AND 9.99999 THEN '5'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 10 AND 14.99999 THEN '10'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 15 AND 19.99999 THEN '15'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 20 AND 24.99999 THEN '20'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 25 AND 29.99999 THEN '25'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 30 AND 34.99999 THEN '30'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 35 AND 39.99999 THEN '35'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 40 AND 44.99999 THEN '40'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 45 AND 49.99999 THEN '45'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 50 AND 54.99999 THEN '50'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 55 AND 59.99999 THEN '55'	
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 60 AND 64.99999 THEN '60'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 BETWEEN 65 AND 69.99999 THEN '65'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 70 AND 74.99999 THEN '70'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 75 AND 79.99999 THEN '75'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 80 AND 84.99999 THEN '80'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time )/365.25 BETWEEN 85 AND 89.99999 THEN '85'
	WHEN DATEDIFF(DD,Date_of_Birth,Admission_Date_Time)/365.25 >= 90 THEN '90'
	ELSE '' END AS 'Age_Band_5yr_Numeric'
,convert(varchar(7),Admission_Date_Time,121) as [Start Date Month Year]
,DATEPART(month,Admission_Date_Time) AS [Start Date Month],
Main_Specialty_Description,
treatment_function_code, treatment_function_description,
L.Code,
L. [Description] Primary_DiagnosisDescription,
Primary_Diagnosis_Code as Primary_Diagnosis,
case 
	when Primary_Diagnosis_Code in ('U071 ','U072') then 'Primary'
	when Secondary_Diagnosis_01 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_02 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_03 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_04 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_05 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_06 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_07 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_08 in ('U071 ','U072') then 'Secondary'
	when Secondary_Diagnosis_09 in ('U071 ','U072') then 'Secondary'
	when Primary_Diagnosis_Code NOT IN ('U071 ','U072') then 'Not COVID-19'
	when Primary_Diagnosis_Code IS NULL then NULL
	when Secondary_Diagnosis_01 IS NULL then NULL
	when Secondary_Diagnosis_02 IS NULL then NULL
	when Secondary_Diagnosis_03 IS NULL then NULL
	when Secondary_Diagnosis_04 IS NULL then NULL
	when Secondary_Diagnosis_05 IS NULL then NULL
	when Secondary_Diagnosis_06 IS NULL then NULL
	when Secondary_Diagnosis_07 IS NULL then NULL
	when Secondary_Diagnosis_08 IS NULL then NULL
	when Secondary_Diagnosis_09 IS NULL then NULL
	else 'Not COVID-19' end as COVID_Coding,
case 
	when Primary_Diagnosis_Code in ('U071 ','U072') then 1
	when Secondary_Diagnosis_01 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_02 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_03 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_04 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_05 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_06 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_07 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_08 in ('U071 ','U072') then 1
	when Secondary_Diagnosis_09 in ('U071 ','U072') then 1
	else 0 end as COVID_Coding_Flag,
case 
	when Primary_Diagnosis_Code in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Primary DKA'
	when Secondary_Diagnosis_01 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_02 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_03 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_04 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_05 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_06 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_07 in ('E101' ,'E111' , 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_08 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	when Secondary_Diagnosis_09 in ('E101' , 'E111', 'E121', 'E131', 'E141') then 'Secondary DKA'
	else 'Not DKA' end as DKA_Coding,
case
	when left(Primary_Diagnosis_Code,4) in ('E101','E111', 'E121', 'E131', 'E141') then 1 else 0 end as [Primary DKA],
CASE
	when Secondary_Diagnosis_01 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_02 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_03 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_04 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_05 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_06 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_07 in ('E101' ,'E111' , 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_08 in ('E101' ,'E111', 'E121', 'E131', 'E141') then 1
	when Secondary_Diagnosis_09 in ('E101' , 'E111', 'E121', 'E131', 'E141') then 1
	else '0' end as [Secondary DKA]
,case
	when left(Primary_Diagnosis_Code,4) = 'E101' then 'Type 1 diabetes mellitus' 
	when left(Primary_Diagnosis_Code,4) = 'E111' then 'Type 2 diabetes mellitus' 
	when left(Primary_Diagnosis_Code,4) = 'E121' then 'Malnutrition-related diabetes mellitus' 
	when left(Primary_Diagnosis_Code,4) = 'E131' then 'Other specified diabetes mellitus'
	when left(Primary_Diagnosis_Code,4) = 'E141' then 'Unspecified diabetes mellitus' ELSE NULL END AS [Primary-ICD Desc DKA],
Secondary_Diagnosis_01,
Secondary_Diagnosis_02,
Secondary_Diagnosis_03,
Secondary_Diagnosis_04,
Secondary_Diagnosis_05,
Secondary_Diagnosis_06,
Secondary_Diagnosis_07,
Secondary_Diagnosis_08,
Secondary_Diagnosis_09,
[Secondary_Diagnosis_10],
[Secondary_Diagnosis_11],
[Secondary_Diagnosis_12],
Primary_Procedure_Code,
Secondary_Procedure_01,
Secondary_Procedure_02,
Secondary_Procedure_03,
Secondary_Procedure_04,
Secondary_Procedure_05,
Secondary_Procedure_06,
Secondary_Procedure_07,
Secondary_Procedure_08,
Secondary_Procedure_09,
case
	when left(Primary_Procedure_Code,4) = 'E851' then 1 ELSE 0 END AS [Primary Invasive Ventilation]
,case
	when left(Secondary_Procedure_01,4) = 'E851' then 1 
	when left(Secondary_Procedure_02,4) = 'E851' then 1 
	when left(Secondary_Procedure_03,4) = 'E851' then 1 
	when left(Secondary_Procedure_04,4) = 'E851' then 1 
	when left(Secondary_Procedure_05,4) = 'E851' then 1 
	when left(Secondary_Procedure_06,4) = 'E851' then 1 
	when left(Secondary_Procedure_07,4) = 'E851' then 1 
	when left(Secondary_Procedure_08,4) = 'E851' then 1 
	when left(Secondary_Procedure_09,4) = 'E851' then 1 
	else 0 end as [Secondary_Invasive_Ventilation]
,case
	when left(Primary_Procedure_Code,4) = 'E852' then 1 ELSE 0 END AS [Primary CPAP]
,case
	when left(Secondary_Procedure_01,4) = 'E852' then 1 
	when left(Secondary_Procedure_02,4) = 'E852' then 1 
	when left(Secondary_Procedure_03,4) = 'E852' then 1 
	when left(Secondary_Procedure_04,4) = 'E852' then 1 
	when left(Secondary_Procedure_05,4) = 'E852' then 1 
	when left(Secondary_Procedure_06,4) = 'E852' then 1 
	when left(Secondary_Procedure_07,4) = 'E852' then 1 
	when left(Secondary_Procedure_08,4) = 'E852' then 1 
	when left(Secondary_Procedure_09,4) = 'E852' then 1 
	else 0 end as [Secondary_CPAP]
,case
	when left(Primary_Procedure_Code,4) = 'E851' then 'Invasive ventilation' 
	when left(Primary_Procedure_Code,4) = 'E852' then 'Non-invasive ventilation (CPAP)' 
	when left(Primary_Procedure_Code,4) = 'E853' then 'Improving efficiency of ventilation' 
	when left(Primary_Procedure_Code,4) = 'E854' then 'Bag valve mask ventilation'
	when left(Primary_Procedure_Code,4) = 'E855' then 'Nebuliser ventilation'
	when left(Primary_Procedure_Code,4) = 'E856' then 'Continuous positive airway pressure'
	when left(Primary_Procedure_Code,4) = 'E858' then 'Other specified'
	when left(Primary_Procedure_Code,4) = 'E859' then 'Unspecified'
	ELSE NULL END AS [Primary-OPCS Ventilation Desc]

	--start looking at 1st secondary code (deliberately excludes main diagnosis when viewing co-morbidities)
,case
	when LEFT([Secondary_Diagnosis_01],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_01],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_01],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_01],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_01],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_01],3) ='I50' then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_01],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_01],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_01],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_01],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_01],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_01],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_01],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_01],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_01],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_01],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_01],3) >= 'J40' and LEFT([Secondary_Diagnosis_01],3) <= 'J47') or
	(LEFT([Secondary_Diagnosis_01],3) >= 'J60' and LEFT([Secondary_Diagnosis_01],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_01],3) >= 'C00' and LEFT([Secondary_Diagnosis_01],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_01],3) >= 'C80' and LEFT([Secondary_Diagnosis_01],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_01],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_01],4) in ('G041', 'G820', 'G821', 'G822') or  LEFT([Secondary_Diagnosis_01],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_01],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_01],4) >= 'N052' and LEFT([Secondary_Diagnosis_01],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_01],4) >= 'N072' and LEFT([Secondary_Diagnosis_01],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_01],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_01],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_01],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	
	--start looking at 2nd secondary code
	when LEFT([Secondary_Diagnosis_02],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_02],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_02],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_02],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_02],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_02],3) ='I50' then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_02],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_02],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_02],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_02],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_02],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_02],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_02],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_02],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_02],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_02],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_02],3) >= 'J40' and LEFT([Secondary_Diagnosis_02],3) <= 'J47') or
	(LEFT([Secondary_Diagnosis_02],3) >= 'J60' and LEFT([Secondary_Diagnosis_02],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_02],3) >= 'C00' and LEFT([Secondary_Diagnosis_02],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_02],3) >= 'C80' and LEFT([Secondary_Diagnosis_02],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_02],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_02],4) in ('G041', 'G820', 'G821', 'G822') or  LEFT([Secondary_Diagnosis_02],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_02],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_02],4) >= 'N052' and LEFT([Secondary_Diagnosis_02],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_02],4) >= 'N072' and LEFT([Secondary_Diagnosis_02],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_02],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_02],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_02],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 3rd secondary code
	when LEFT([Secondary_Diagnosis_03],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_03],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_03],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_03],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_03],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_03],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_03],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_03],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_03],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_03],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_03],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_03],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_03],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_03],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_03],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_03],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_03],3) >= 'J40' and LEFT([Secondary_Diagnosis_03],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_03],3) >= 'J60' and LEFT([Secondary_Diagnosis_03],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_03],3) >= 'C00' and LEFT([Secondary_Diagnosis_03],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_03],3) >= 'C80' and LEFT([Secondary_Diagnosis_03],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_03],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_03],4) in ('G041', 'G820', 'G821', 'G822') or  LEFT([Secondary_Diagnosis_03],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_03],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_03],4) >= 'N052' and LEFT([Secondary_Diagnosis_03],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_03],4) >= 'N072' and LEFT([Secondary_Diagnosis_03],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_03],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_03],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_03],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 4th secondary code
	when LEFT([Secondary_Diagnosis_04],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_04],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_04],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_04],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_04],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_04],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_04],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_04],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_04],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_04],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_04],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_04],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_04],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_04],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_04],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_04],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_04],3) >= 'J40' and LEFT([Secondary_Diagnosis_04],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_04],3) >= 'J60' and LEFT([Secondary_Diagnosis_04],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_04],3) >= 'C00' and LEFT([Secondary_Diagnosis_04],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_04],3) >= 'C80' and LEFT([Secondary_Diagnosis_04],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_04],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_04],4) in ('G041', 'G820', 'G821', 'G822') or  LEFT([Secondary_Diagnosis_04],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_04],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_04],4) >= 'N052' and LEFT([Secondary_Diagnosis_04],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_04],4) >= 'N072' and LEFT([Secondary_Diagnosis_04],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_04],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_04],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_04],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 5h secondary code
	when LEFT([Secondary_Diagnosis_05],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_05],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_05],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_05],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_05],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_05],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_05],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_05],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_05],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_05],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_05],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_05],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_05],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_05],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_05],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_05],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_05],3) >= 'J40' and LEFT([Secondary_Diagnosis_05],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_05],3) >= 'J60' and LEFT([Secondary_Diagnosis_05],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_05],3) >= 'C00' and LEFT([Secondary_Diagnosis_05],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_05],3) >= 'C80' and LEFT([Secondary_Diagnosis_05],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_05],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_05],4) in ('G041', 'G820', 'G821', 'G822') or  LEFT([Secondary_Diagnosis_05],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_05],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_05],4) >= 'N052' and LEFT([Secondary_Diagnosis_05],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_05],4) >= 'N072' and LEFT([Secondary_Diagnosis_05],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_05],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_05],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_05],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 6th secondary code
	when LEFT([Secondary_Diagnosis_06],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_06],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_06],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_06],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_06],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_06],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_06],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_06],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_06],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_06],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_06],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_06],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_06],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_06],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_06],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_06],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_06],3) >= 'J40' and LEFT([Secondary_Diagnosis_06],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_06],3) >= 'J60' and LEFT([Secondary_Diagnosis_06],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_06],3) >= 'C00' and LEFT([Secondary_Diagnosis_06],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_06],3) >= 'C80' and LEFT([Secondary_Diagnosis_06],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_06],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_06],4) in ('G041', 'G820', 'G821', 'G822') or  LEFt([Secondary_Diagnosis_06],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_06],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_06],4) >= 'N052' and LEFT([Secondary_Diagnosis_06],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_06],4) >= 'N072' and LEFT([Secondary_Diagnosis_06],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_06],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_06],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_06],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

		--start looking at 7th secondary code
	when LEFT([Secondary_Diagnosis_07],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_07],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_07],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_07],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_07],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_07],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_07],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_07],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_07],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_07],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_07],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_07],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_07],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_07],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_07],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_07],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_07],3) >= 'J40' and LEFT([Secondary_Diagnosis_07],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_07],3) >= 'J60' and LEFT([Secondary_Diagnosis_07],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_07],3) >= 'C00' and LEFT([Secondary_Diagnosis_07],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_07],3) >= 'C80' and LEFT([Secondary_Diagnosis_07],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_07],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_07],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_07],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_07],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_07],4) >= 'N052' and LEFT([Secondary_Diagnosis_07],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_07],4) >= 'N072' and LEFT([Secondary_Diagnosis_07],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_07],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_07],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_07],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'



	--start looking at 8th secondary code
	when LEFT([Secondary_Diagnosis_08],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_08],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_08],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_08],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_08],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_08],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_08],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_08],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_08],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_08],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_08],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_08],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_08],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_08],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_08],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_08],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_08],3) >= 'J40' and LEFT([Secondary_Diagnosis_08],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_08],3) >= 'J60' and LEFT([Secondary_Diagnosis_08],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_08],3) >= 'C00' and LEFT([Secondary_Diagnosis_08],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_08],3) >= 'C80' and LEFT([Secondary_Diagnosis_08],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_08],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_08],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_08],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_08],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_08],4) >= 'N052' and LEFT([Secondary_Diagnosis_08],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_08],4) >= 'N072' and LEFT([Secondary_Diagnosis_08],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_08],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_08],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_08],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 9th secondary code

	when LEFT([Secondary_Diagnosis_09],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_09],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_09],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_09],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_09],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_09],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_09],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_09],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_09],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_09],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_09],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_09],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_09],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_09],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_09],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_09],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_09],3) >= 'J40' and LEFT([Secondary_Diagnosis_09],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_09],3) >= 'J60' and LEFT([Secondary_Diagnosis_09],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_09],3) >= 'C00' and LEFT([Secondary_Diagnosis_09],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_09],3) >= 'C80' and LEFT([Secondary_Diagnosis_09],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_09],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_09],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_09],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_09],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_09],4) >= 'N052' and LEFT([Secondary_Diagnosis_09],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_09],4) >= 'N072' and LEFT([Secondary_Diagnosis_09],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_09],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_09],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_09],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

		--start looking at 10th secondary code

	when LEFT([Secondary_Diagnosis_10],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_10],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_10],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_10],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_10],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_10],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_10],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_10],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_10],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_10],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_10],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_10],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_10],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_10],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_10],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_10],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_10],3) >= 'J40' and LEFT([Secondary_Diagnosis_10],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_10],3) >= 'J60' and LEFT([Secondary_Diagnosis_10],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_10],3) >= 'C00' and LEFT([Secondary_Diagnosis_10],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_10],3) >= 'C80' and LEFT([Secondary_Diagnosis_10],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_10],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_10],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_10],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_10],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_10],4) >= 'N052' and LEFT([Secondary_Diagnosis_10],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_10],4) >= 'N072' and LEFT([Secondary_Diagnosis_10],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_10],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_10],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_10],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 11th secondary code

	when LEFT([Secondary_Diagnosis_11],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_11],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_11],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_11],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_11],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_11],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_11],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_11],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_11],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_11],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_11],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_11],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_11],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_11],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_11],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_11],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_11],3) >= 'J40' and LEFT([Secondary_Diagnosis_11],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_11],3) >= 'J60' and LEFT([Secondary_Diagnosis_11],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_11],3) >= 'C00' and LEFT([Secondary_Diagnosis_11],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_11],3) >= 'C80' and LEFT([Secondary_Diagnosis_11],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_11],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_11],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_11],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_11],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_11],4) >= 'N052' and LEFT([Secondary_Diagnosis_11],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_11],4) >= 'N072' and LEFT([Secondary_Diagnosis_11],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_11],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_11],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_11],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	--start looking at 12th secondary code

	when LEFT([Secondary_Diagnosis_12],3) in ('I21', 'I22', 'I23') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_12],4) in ('I252', 'I258') then 'Acute myocardial infarction'
	when LEFT([Secondary_Diagnosis_12],4) in ('G450', 'G451', 'G452', 'G454', 'G458', 'G459') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_12],3) in ('G46') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_12],3) in ('I60','I61','I62','I63','I64','I65','I66','I67','I68','I69') then 'Cerebral vascular accident'
	when LEFT([Secondary_Diagnosis_12],3) in ('I50') then 'Congestive heart failure'
	when LEFT([Secondary_Diagnosis_12],3) in ('M05', 'M32', 'M34') then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_12],4) in ('M060', 'M063', 'M069', 'M332','M353')then 'Connective tissue disorder'
	when LEFT([Secondary_Diagnosis_12],3) in  ('F00', 'F01', 'F02', 'F03') then 'Dementia'
	when LEFT([Secondary_Diagnosis_12],4) IN ('F051') then 'Dementia'
	when LEFT([Secondary_Diagnosis_12],4) in ('E101', 'E105', 'E106', 'E108', 'E109', 'E111', 'E115', 'E116', 'E118', 'E119', 'E131', 'E131', 'E136', 'E138', 'E139', 'E141','E145', 'E146', 'E148','E149') then 'Diabetes'
	when LEFT([Secondary_Diagnosis_12],4) in ('K702', 'K703', 'K717') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_12],3) in ('K73', 'K74') then 'Liver disease'
	when LEFT([Secondary_Diagnosis_12],3) in  ('K25', 'K26', 'K27', 'K28') then 'Peptic ulcer'
	when LEFT([Secondary_Diagnosis_12],3) in ('I71', 'R02') then 'Peripheral vascular disease'
	when LEFT([Secondary_Diagnosis_12],4) in ('I739', 'I790', 'Z958', 'Z959') then 'Peripheral vascular disease'
	when (LEFT([Secondary_Diagnosis_12],3) >= 'J40' and LEFT([Secondary_Diagnosis_12],3) <= 'J47')or
	(LEFT([Secondary_Diagnosis_12],3) >= 'J60' and LEFT([Secondary_Diagnosis_12],3) <= 'J67') then 'Pulmonary disease'
	when (LEFT([Secondary_Diagnosis_12],3) >= 'C00' and LEFT([Secondary_Diagnosis_12],3) <= 'C76')or
	(LEFT([Secondary_Diagnosis_12],3) >= 'C80' and LEFT([Secondary_Diagnosis_12],3) <= 'C97') then 'Cancer'

	when LEFT([Secondary_Diagnosis_12],4) in ('E102', 'E103', 'E104', 'E107', 'E112', 'E113', 'E114', 'E117','E132', 'E133', 'E134', 'E137', 'E142', 'E143', 'E144', 'E147') then 'Diabetes complications'
	when LEFT([Secondary_Diagnosis_12],4) in ('G041', 'G820', 'G821', 'G822') or LEFT([Secondary_Diagnosis_12],3) in ('G81') then 'Paraplegia'
	when LEFT([Secondary_Diagnosis_12],3) in ('I12', 'I13', 'N01', 'N03', 'N18','N19','N25') then 'Renal disease'

	when (LEFT([Secondary_Diagnosis_12],4) >= 'N052' and LEFT([Secondary_Diagnosis_12],3) <='N056') then 'Renal disease'
	when (LEFT([Secondary_Diagnosis_12],4) >= 'N072' and LEFT([Secondary_Diagnosis_12],3) <='N074') then 'Renal disease'
	when LEFT([Secondary_Diagnosis_12],3) in ('C77', 'C78', 'C79') then 'Metastatic cancer'
	when LEFT([Secondary_Diagnosis_12],4) in  ('K721', 'K729', 'K766', 'K767') then 'Severe liver disease'
	when LEFT([Secondary_Diagnosis_12],3) in ('B20', 'B21', 'B22', 'B23', 'B24') then 'HIV'

	else '** No Charlson Comorbidity casemix **'
	end as CharlsonCC_Ind

,Hospital_Site_Description as [Hospital Site]
,ward_code_at_episode_start
,ward_code_at_episode_end
,Patient_Classification_Code
,Patient_Classification_Description
,Case when Patient_Classification_Code is not null and Patient_Classification_Code = 1 then 1 else 0 end as Ordinary_Admission_Flag
,Case when Patient_Classification_Code is not null and Patient_Classification_Code <> 2 then 1 else 0 end as Admission_Flag
,Admission_Method_Code 
,Admission_Method_Description 
,Discharge_Method_Code as Discharge_Method
,Discharge_Method_Description
,discharge_Destination_code
,discharge_destination_Description 
,case when Discharge_Method_Code in ('4','5') then 'Died' else 'Alive'end as DischargeInformation
,case when discharge_Destination_code = '79' then 'Died' else 'Alive' end as DischargeInformation2
,Last_Episode_In_Spell_Indicator as Last_Epispde_In_Spell_Indicator
,T.Spell_Number 
,ENCOUNTER_ID AS IP_ENCOUNTER_ID
,NHS_Number as [NHS NUMBER]
,episode_number
,replace(postcode,' ','')  as IP_postcodeFIXED
,postcode AS IP_postcode
,LSOA.PCD7
,Pcd7fixed
,[lsoa11cd]
,[Index of Multiple Deprivation (IMD) Score]
,[Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)]
,[Health Deprivation and Disability Decile (where 1 is most deprived 10% of LSOAs)]
,[Education, Skills and Training Decile (where 1 is most deprived 10% of LSOAs)]
,[Employment Decile (where 1 is most deprived 10% of LSOAs)]
,[Income Decile (where 1 is most deprived 10% of LSOAs)]
,[Income Deprivation Affecting Older People (IDAOPI) Decile (where  1 is most deprived 10% of LSOAs)]
,[Income Deprivation Affecting Children Index (IDACI) Decile (where 1 is most deprived 10% of LSOAs)]
,[Outdoors Sub-domain Decile (where 1 is most deprived 10% of LSOA)]
,[Indoors Sub-domain Decile (where 1 is most deprived 10% of LSOAs)]
,[Wider barriers Sub-domain Decile (where 1 is most deprived 10% of LSOAs)]
,[Geographical barriers Sub-domain Decile (where 1 is most deprived 10% of LSOAs)]
,[Adult Skills Sub-domain Decile (where 1 is most deprived 10% of LSOAs)]
,[Children and Young People Sub-domain Decile (where 1 is most deprived 10% of LSOAs)]
,[Barriers to Housing and Services Decile (where 1 is most deprived 10% of LSOAs)]
,[Living Environment Decile (where 1 is most deprived 10% of LSOAs)]
,[Crime Decile (where 1 is most deprived 10% of LSOAs)]

             ,case
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '1' then 1
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '2' then 1
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '3' then 2
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '4' then 2
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '5' then 3
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '6' then 3
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '7' then 4
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '8' then 4
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '9' then 5
             when [Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)] = '10' then 5
             end as IMDQuintile
           ,case
             when Ethnic_Category_Description IN ('White - British', 'White - Any Other White Background', 'White - Irish') THEN 'All White Ethnicity Categories'
             when Ethnic_Category_Description IN ('Asian - Any Other Asian Background', 'Asian or Asian British - Bangladeshi', 'Asian or Asian British - Indian', 'Asian or Asian British - Pakistani', 'Mixed - White and Asian') THEN 'All South Asian Ethnicity Categories'
             when Ethnic_Category_Description IN ('Black or Black British - African', 'Black or Black British - Caribbean', 'Black - Any Other Black Background', 'Mixed - White and Black Caribbean', 'Mixed - White and Black African') THEN 'All Black Ethnicity Categories'
             when Ethnic_Category_Description IN ('Other - Not Stated', 'Other - Not Known') THEN 'Ethnicity not recorded'
             when Ethnic_Category_Description IN ('Other - Any Other Ethnic Group', 'Other - Chinese', 'Mixed - Any Other Mixed Background') THEN 'All Other Ethnic Categories'
             end as EthnicCategory


FROM [RFLCFVM186-82].[TRANS_RFL835].[INP].[REPORTING_LAYER_LIVE] t 

--left join[Ardentia_Healthware_64_Reference]. [dbo].[ICD10_L4] L on  LEFT(Primary_Diagnosis_Code	,4)=L.[Code]
left join  [RF_Reference].[ICD10].[ICD10_L4] L on  LEFT(Primary_Diagnosis_Code	,4)=L.[Code]

 LEFT JOIN (SELECT replace(pcd7,' ','') as Pcd7fixed,  replace(pcd8,' ','') as Pcd8fixed, replace(pcds,' ','') as PcdSfixed,* FROM [DIV_Perf].[dbo].[Postcode_to_LSOA]) LSOA
ON LSOA.Pcd7fixed = replace(postcode,' ','')
Left Join RF_Geo_reference.[dbo].[IMD2019] geo
on LSOA.[lsoa11cd] = geo.[LSOA code (2011)]
) DATA
WHERE
Admission_Date >= '2020-01-01' and  (Last_Epispde_In_Spell_Indicator  = 1 or Last_Epispde_In_Spell_Indicator = 9)




------------------SWAB DATA EXCLUDING ANTIBODY TESTS ---------------------------------------




--drop table ##COVID_Tests_Resulted_ALL_2

SELECT distinct *  INTO 
##COVID_Tests_Resulted_All_2
from (
select distinct * 
,ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID] ORDER BY ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) as LOGIC_ORDER
,CASE
	 WHEN (status = 'Positive') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) ELSE null END as Positive_Seq
,CASE
	 WHEN (status = 'Negative') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) ELSE null end as Negative_Seq
,CASE
	 WHEN (status = 'Positive') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) ASC) ELSE null END as Positive_Seq_ASC
,CASE
	 WHEN (status = 'Negative') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) ASC) ELSE null end as Negative_Seq_ASC
,CASE
	 WHEN status = 'Positive' then  [EVENT_START_DT_TM] else null end as Positive_Result_DT
,CASE
	 WHEN status = 'Negative' then  [EVENT_START_DT_TM] else null end as Negative_Result_DT
,case
	 when (status = 'Negative') and ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) >= 2 then 1 else 0 end as [Consecutive Negatives Flag]
,CASE 
	WHEN status = 'Positive' THEN 1 ELSE 0 END as Positive_Flag
,CASE 
	WHEN status = 'Negative' THEN 1 ELSE 0 end as Negative_Flag
FROM [RFLCFVM186-82].[TRANS_RFG835].[cvd].[TEST_ORDERS_RESULTS]
WHERE [EVENT_DISPLAY] not like '%gCoV%'

  UNION

select distinct * 
,ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID] ORDER BY ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) as LOGIC_ORDER
,CASE 
	WHEN (status = 'Positive') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) ELSE null END as Positive_Seq
,CASE 
	WHEN (status = 'Negative') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) ELSE null end as Negative_Seq
,CASE 
	WHEN (status = 'Positive') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) ASC) ELSE null END as Positive_Seq_ASC
,CASE 
	WHEN (status = 'Negative') THEN ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], Status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) ASC) ELSE null end as Negative_Seq_ASC
,CASE 
	WHEN status = 'Positive' then  [EVENT_START_DT_TM] else null end as Positive_Result_DT
,CASE 
	WHEN status = 'Negative' then  [EVENT_START_DT_TM] else null end as Negative_Result_DT
,case 
	when (status = 'Negative') and ROW_NUMBER() OVER (PARTITION BY [ENCNTR_ID], status ORDER BY status, ISNULL([ORIG_ORDER_DT_TM],[EVENT_START_DT_TM]) DESC) >= 2 then 1 else 0 end as [Consecutive Negatives Flag]
,CASE 
	WHEN status = 'Positive' THEN 1 ELSE 0 END as Positive_Flag
,CASE 
	WHEN status = 'Negative' THEN 1 ELSE 0 end as Negative_Flag
FROM [RFLCFVM186-82].[TRANS_RFL835].[cvd].[TEST_ORDERS_RESULTS]
WHERE [EVENT_DISPLAY] not like '%gCoV%' 


  ) data


--select * from  ##COVID_Tests_Resulted_ALL_2




--------------STEP 2 SUMMARIZE TO SPELL LEVEL WITH AGREED LOGIC FOR PATIENT STATUS
---------- SWAB SUMMARY TABLE WITH LOGIC-------------------------


--drop table ##COVID_Tests_Resulted_ALL_SpellLevel_2


SELECT *
,case 
	when Positive_Count >= 1 then 'Positive Patient'
	when Positive_Count < 1 and Consecutive_Negatives >= 1  then 'Negative Patient'
	when Positive_Count < 1 and Consecutive_Negatives < 1 
	then 'Suspected' 
	else '' end as [Result Logic COVID Status]
,case 
	when Positive_Count >= 1 then 1 else 0 end as [Positive Logic]
,case 
	when Positive_Count < 1 and Consecutive_Negatives > 1 then 1 else 0 end as [Negative Logic]
,case 
	when Positive_Count < 1 and Consecutive_Negatives < 1
	then 1 else 0 end as [Suspected Logic]
INTO ##COVID_Tests_Resulted_ALL_SpellLevel_2
from
(select DISTINCT 
[FIN], [LOCAL_PATIENT_IDENT]
,SUM(Positive_Flag) AS Positive_Count
,sum(Negative_Flag) as Negative_Count
,sum([Consecutive Negatives Flag]) as Consecutive_Negatives
,count([LOGIC_ORDER]) as All_Tests_Count
,MIN([ORIG_ORDER_DT_TM]) as First_Order_Time
,MIN([EVENT_START_DT_TM]) as First_Event_Time
,Max([ORIG_ORDER_DT_TM]) as Latest_Order_Time
,max([EVENT_START_DT_TM]) as Latest_Event_Time
,MIN(Positive_Result_DT) AS First_Positive_Result
,MIN(Negative_Result_DT) AS First_Negative_Result
,MAX(Positive_Result_DT) AS Latest_Positive_Result
,MAX(Negative_Result_DT) AS Latest_Negative_Result
from ##COVID_Tests_Resulted_ALL_2
GROUP BY  [FIN] , [LOCAL_PATIENT_IDENT]) data



  ------------JOINING TEST DATA TO ICD10 CODED DATA
--drop table ##COVID_Tests_Resulted_Coded1


SELECT * INTO ##COVID_Tests_Resulted_Coded1
from (
SELECT DISTINCT * FROM ##COVID_Tests_Resulted_ALL_SpellLevel_2 
full outer join (
SELECT DISTINCT 
spell_number as ICD_SpellNumber
,IP_Local_Patient_Identifier AS ICD_Local_Patient_Identifier
,COVID_Coding as ICD_COVID_Coding
,case
	when left(Primary_Diagnosis,4) = 'U071' then 1 else 0 end as [ICD Primary Confirmed COVID],
case
	when left(Primary_Diagnosis,4) = 'U072' then 1 else 0 end as [ICD Primary Suspected COVID], 
case
	when left(Secondary_Diagnosis_01,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_02,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_03,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_04,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_05,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_06,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_07,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_08,4) = 'U071' then 1 
	when left(Secondary_Diagnosis_09,4) = 'U071' then 1 
	else 0 end as [ICD Secondary_Confirmed_COVID],
case
	when left(Secondary_Diagnosis_01,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_02,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_03,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_04,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_05,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_06,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_07,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_08,4) = 'U072' then 1 
	when left(Secondary_Diagnosis_09,4) = 'U072' then 1 
	else 0 end as [ICD Secondary_Suspected_COVID]

from ##For_COVID_IP_JOIN1
where COVID_Coding not like '%Not COVID-19%'
) ICD ON FIN = ICD_SpellNumber
and ICD_Local_Patient_Identifier = Local_Patient_Ident
) data




----------------------------------------------------------------------WARD STAYS LINK TO INPATIENTS

drop table [DIV_Perf].dbo.COVID_GA_Nautilus_WardStays_Link_IP_Summary1

select distinct CV.*, [Total ICU LOS], [Total ICU LOS (Hrs)], [ICU WardStays Count],
[Updated ICU WardStays Count]
,[2nd Surge ICU WardStays Count]
,Spell_Number  into
[DIV_Perf].dbo.COVID_GA_Nautilus_WardStays_Link_IP_Summary1
from
(select base.*, [Total ICU LOS], [Total ICU LOS (Hrs)], [ICU WardStays Count]
,[Updated ICU WardStays Count], [2nd Surge ICU WardStays Count]
  from  ##GA_Nautilus_WardStays_Link_IP1 base

left join
(SELECT
 Spell_Number, local_patient_identifier
,SUM([LOS (Hours) in ICU Ward]) AS [Total ICU LOS (Hrs)]
,SUM([LOS in ICU Ward]) AS [Total ICU LOS]
,SUM( [WardStays ICU Flag]) AS [ICU WardStays Count]
,SUM( [Updated WardStays ICU Flag]) AS [Updated ICU WardStays Count]
,SUM( [2nd Surge ICU Flag]) AS [2nd Surge ICU WardStays Count]
 FROM ##GA_Nautilus_WardStays_Link_IP1
GROUP BY
Spell_Number, local_patient_identifier
) l 
on l.spell_number = base.spell_number
and l.local_patient_identifier = base.local_patient_identifier
) l 
right join 
(select distinct *  from ##COVID_Tests_Resulted_Coded1) cv on (fin = l.spell_number
and local_patient_identifier = local_patient_ident) or (l.spell_number = ICD_SPELLNUMBER AND local_patient_identifier = ICD_local_patient_identifier)





--------------op join-------------------------------

--drop table ##COVID_Tests_Resulted_OP1

SELECT distinct * INTO 
##COVID_Tests_Resulted_OP1
FROM
(select * from ##COVID_Tests_Resulted_Coded1 F
  left join 
(select DISTINCT
Local_Patient_ID AS OP_mrn
,Attendance_Date  as OP_Attendance_Date
,Appointment_Type,
Specialty_Desc
,Outcome_of_Attendance_Desc
,[Site_Code_(of_Treatment)_Desc] as [OP_Site_Code_(of_Treatment)_Desc]
,Referral_ID
,case
when Appointment_Slot_Type LIKE ('%AEC%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%DVT%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%ae cellu%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%ral01 ae%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%RAL01 AE Ureteric Colic New 30%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%ambulatory pe%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%RVL01 COE TIA NEW 30%') then 'AEC Appointment'
when Appointment_Slot_Type LIKE ('%RVL01 Neurology RACP New 10%') then 'AEC Appointment'  else 'Other' end as [AEC Appointment Flag]
from RF_Performance.dbo.RF_Performance_OPA_Main where attended_or_did_not_attend in ('5', '6') and  cast(Attendance_Date as date)  >= '2020-01-01'  
 ) as op on 
  (f.fin = op.Referral_ID and cast(op.OP_Attendance_Date as date) = cast(First_Order_Time as date))
) data



--drop table   ##COVID_Tests_AE_Inpatients_GA1

SELECT distinct
 * INTO 
 ##COVID_Tests_AE_Inpatients_GA1
 FROM
 (select f.*
			,CASE 
			WHEN [Negative Logic] = 1 THEN 'Negative Result' 
			when [Positive Logic] = 1 then 'Positive Result' 
			WHEN [Suspected Logic] = 1 then 'Suspected' else '' end as [COVID Tests Results]
			,case when ([ICD Primary Suspected COVID] = 1 or [ICD Secondary_Suspected_COVID] = 1) then 'Suspected U072'
			when ([ICD Primary Confirmed COVID] = 1 or  [ICD Secondary_Confirmed_COVID] = 1) then 'Confirmed U071'
			ELSE 'Not COVID-19' end as ICD_COVID_Suspect_Confirm
			,case when [ICD Primary Suspected COVID] = 1 then 'Primary Suspected U072'
			when [ICD Primary Confirmed COVID] = 1 then 'Primary Confirmed U071'
			when [ICD Secondary_Confirmed_COVID] = 1 then 'Secondary Confirmed U071'
			when [ICD Secondary_Suspected_COVID] = 1 then 'Secondary Suspected U072'
			ELSE 'Not COVID-19' end as [All COVID Coding]
			,case 
			when  ([Positive Logic] = 0 or [Positive Logic] is NULL) and [ICD Primary Confirmed COVID] = 1 then 'Primary Confirmed No Positive Swab'
			when  ([Positive Logic] = 0 or [Positive Logic] is NULL) and [ICD Secondary_Confirmed_COVID] = 1 then 'Secondary Confirmed No Positive Swab'
			when  [Positive Logic] = 1 and [ICD Primary Confirmed COVID] = 1 then 'Primary Confirmed Positive Swab'
			when  [Positive Logic] = 1 and [ICD Secondary_Confirmed_COVID] = 1 then 'Secondary Confirmed Positive Swab'
			ELSE '' end as [All Confirmed COVID U071]
,AE.*
,IP.*
, [Total ICU LOS], [Total ICU LOS (Hrs)], [ICU WardStays Count], 
[Updated ICU WardStays Count], 
[2nd Surge ICU WardStays Count]
 from ##COVID_Tests_Resulted_OP1 F
LEFT JOIN 
(select distinct * from ##For_COVID_AE_JOIN1
) AE
ON AE.[Attendance_Number] = F.[FIN]

 LEFT JOIN
(select distinct * from ##For_COVID_IP_JOIN1) IP
on (F.[FIN] = IP.[Spell_Number]
or f.ICD_SpellNumber = IP.[Spell_Number])
and F.local_patient_ident = IP.IP_Local_Patient_Identifier
LEFT JOIN (  
select distinct [Total ICU LOS], [Total ICU LOS (Hrs)], [ICU WardStays Count], [Updated ICU WardStays Count], [2nd Surge ICU WardStays Count], Spell_Number  from
[DIV_Perf].dbo.COVID_GA_Nautilus_WardStays_Link_IP_Summary1
) L ON (f.FIN = l.spell_number or  f.ICD_SpellNumber = l.spell_number) 
and Last_Epispde_In_Spell_Indicator  = 1

) data

--SELECT * FROM ##COVID_Tests_AE_Inpatients_GA1



---------------------------------------------------------------------



DROP TABLE [DIV_Perf].dbo.COVID_ALL_AE_Inpatients_GA

SELECT distinct
	data.* 
	,[CTPA Flag]
	,case when rad.EventDate BETWEEN [Arrival_Date_Time] AND [Departure_Date_Time] then 1 else 0 end as [CTPA in AE]
	,case WHEN rad.EventDate BETWEEN Admission_Date_Time AND [Discharge_Date_Time] THEN 1 else 0 end as [CTPA as Inpatient]
	,report as [CTPA Report]
	,EventDate as [CTPA Event Date]
	,[D-dimer Flag]
	,case when pat.EVENT_DATE BETWEEN [Arrival_Date_Time] AND [Departure_Date_Time] then 1 else 0 end as [D-dimer in AE]
	,case WHEN pat.EVENT_DATE BETWEEN Admission_Date_Time AND [Discharge_Date_Time] then 1 else 0 end as [D-dimer as Inpatient]
	,EVENT_DATE as [D-dimer Event Date]
	,[ResultValue] as [D-dimer ResultValue]
	,powerform_Date_time as Rockwood_Date_Time 
	,powerform_name as Rockwood_Powerform_Name
	,Encounter_Type as Rockwood_Encounter_Type 
	,Score as Rockwood_Score

 INTO 
 [DIV_Perf].dbo.COVID_ALL_AE_Inpatients_GA
FROM (
SELECT * from ##COVID_Tests_AE_Inpatients_GA1
 ) DATA
left join
(--D-dimers
	select distinct
	ROW_NUMBER() OVER(PARTITION BY  PatientNumber order by EVENT_DATE ) ddimer_seq
	,G.[RFPATJoinKey]
	,[Event_Date],[PatientNumber]
	,[OBRExamCodeID]
	,case when OBRExamCodeID like ('%DD%') then 1 else 0 end as [D-dimer Flag]
	,[OBRExamCodeText]
	,[RequestDate] 
	,[ObservationDate]
	,[ReportedDate]
	,[ResultValue]
     FROM [Ardentia_Healthware_64_Release].[dbo].[RFPAT_General] G
   left join [Ardentia_Healthware_64_Release].[dbo].[RFPAT_Results]  R on G.[RFPATJoinKey]= R.[RFPATJoinKey]
   where OBRExamCodeID like ('%DD%')
) as pat on [PatientNumber] = [Local_Patient_Identifier]
and( EVENT_DATE BETWEEN [Arrival_Date_Time] AND [Departure_Date_Time]
or EVENT_DATE BETWEEN Admission_Date_Time AND Discharge_Date_Time)
and ddimer_seq = 1
left join
( select DISTINCT
PatientNumber
,report
,G.EventKey,G.[ExamName],G.EventDate,G.Examination
    ,G.[ReferringLocation]
    ,G.[ReferrerName]
    ,G.[PatientTypeDesc]
    ,G.[KornerBand]
    ,G.[Specialty],
    G.[RoomName]
    ,G.[RequestDate]
	,case when G.Examination like '%CAPUG%' then 1 else 0 end as [CTPA Flag]
    ,case when G.[Site]='RAL01' Then 'Royal Free'
      when G.Site='RAL26' then 'Barnet' else 'Other'end Site
                ,G.[latestStatusCde]
                ,DateReported
                ,ReportedbyName
                ,ROW_NUMBER() OVER(PARTITION BY  PatientNumber order by EventDate ) seq
                ,Clinicalhistory
                from [Ardentia_Healthware_64_Release].[dbo].[RFRAD_General] AS G
                  left join [Ardentia_Healthware_64_Reference].[dbo].[RF_Dates] D on D.DATE=g.EventDate
                LEFT JOIN [Ardentia_Healthware_64_Release].[dbo].[RFRAD_Locals] L
                ON G.[RFRADJoinKey]=L.[RFRADJoinKey]         
                WHERE  
                G.[latestStatusCde] = 'ATP' 
                and cast(G.EventDate as date) >=  '01-March-2020'
                and G.Examination like '%CAPUG%'
) rad on rad.PatientNumber = [Local_Patient_Identifier]
and ( EventDate BETWEEN [Arrival_Date_Time] AND [Departure_Date_Time]
or EventDate BETWEEN Admission_Date_Time AND Discharge_Date_Time)
and seq = 1 
left join 
(SELECT ROW_NUMBER() OVER(PARTITION BY  encntr_id order by powerform_Date_time DESC ) Frailty_seq, 
ENCNTR_ID, Encounter_Type, powerform_Date_time, powerform_name, mrn, Score FROM [RFLCFVM186-82].[TRANS_RFL835].[PF].[ROCKWOOD_FRAILTY_SCORES])  PF
on  (IP_ENCOUNTER_ID = PF.ENCNTR_ID
or AE_ENCNTR_ID = PF.ENCNTR_ID)
AND Frailty_seq = 1









  -------- LEFT JOIN FOR AVG CHARLESTON 

drop table   [DIV_Perf].dbo.COVID_ALL_AE_Inpatients_GA_Final


 SELECT 
 getdate() as Run_Time,
 case 
	 when local_patient_ident IS NOT NULL THEN  ROW_NUMBER() OVER (PARTITION BY local_patient_ident ORDER BY ISNULL(first_ORDER_TIME,first_Event_TIME)) 
	 ELSE NULL END as Unique_Patients,
  *
,RIGHT(CONVERT(VARCHAR(1000), HASHBYTES('SHA1',[LOCAL_PATIENT_IDENT]), 1),10) as Scrambled_MRN
,RIGHT(CONVERT(VARCHAR(1000), HASHBYTES('SHA1',[Local_Patient_Identifier]), 1),10) as Scrambled_MRN_AE	 
,RIGHT(CONVERT(VARCHAR(1000), HASHBYTES('SHA1',[IP_Local_Patient_Identifier]), 1),10) as Scrambled_MRN_Inpatient
,CASE 
	WHEN All_Tests_Count > 0 AND OP_Attendance_Date IS not NULL AND ([Arrival_Date_Time] IS NULL AND [Admission_Date_Time] IS NULL) THEN 'TEST, OP'
	WHEN All_Tests_Count > 0 AND [Arrival_Date_Time] IS NULL AND [Admission_Date_Time] IS NULL THEN 'TEST ONLY (no spell)'
	WHEN All_Tests_Count > 0 AND [Arrival_Date_Time] IS NOT NULL AND [Admission_Date_Time] IS NULL THEN 'TEST, ED'
	WHEN All_Tests_Count > 0 AND [Arrival_Date_Time] IS NULL AND [Admission_Date_Time] IS NOT NULL THEN 'TEST, IP'
	WHEN All_Tests_Count > 0 AND [Arrival_Date_Time] IS NOT NULL AND [Admission_Date_Time] IS NOT NULL THEN 'TEST, ED, IP' 
	WHEN All_Tests_Count IS NULL AND OP_Attendance_Date IS not NULL AND ([Arrival_Date_Time] IS NULL AND [Admission_Date_Time] IS NULL) THEN 'NO TEST, OP'
	WHEN All_Tests_Count IS NULL AND [Arrival_Date_Time] IS NOT NULL AND [Admission_Date_Time] IS NULL THEN 'NO TEST, ED'
	WHEN All_Tests_Count IS NULL AND [Arrival_Date_Time] IS NULL AND [Admission_Date_Time] IS NOT NULL THEN 'NO TEST, IP'
	WHEN All_Tests_Count IS NULL AND [Arrival_Date_Time] IS NOT NULL AND [Admission_Date_Time] IS NOT NULL THEN 'NO TEST, ED, IP' 
	END AS Coverage
 ,CASE 
	WHEN [Admission_Date_Time] IS NOT NULL AND DISCHARGE_dATE IS NOT NULL THEN 'DISCHARGED INPATIENT'
	WHEN [Admission_Date_Time] IS NOT NULL AND DISCHARGE_dATE IS NULL THEN 'CURRENT INPATIENT'
	ELSE '' END AS [Current IP Flag]
,CASE 
	WHEN [Admission_Date_Time] IS NOT NULL THEN 1 ELSE 0 END AS [ALL IP Flag]
,CASE 
	WHEN (COVID_Coding not like '%Not COVID-19%' or [Positive Logic] = 1) and [Admission_Date_Time] IS NOT NULL THEN 1 ELSE 0 END AS [COVID IP Flag]
,CASE 
	WHEN ([Suspected Logic] = 1) and [Admission_Date_Time] IS NOT NULL THEN 1 ELSE 0 END AS [SUSPECTED Result IP Flag]
,CASE 
	WHEN ([Negative Logic] = 1) and [Admission_Date_Time] IS NOT NULL THEN 1 ELSE 0 END AS [NEGATIVE Result IP Flag]
,CASE 
	WHEN (COVID_Coding not like '%Not COVID-19%' or [Positive Logic] = 1) and [Arrival_Date_Time]  IS NOT NULL THEN 1 ELSE 0 END AS [COVID AE Flag]
,CASE 
	WHEN (COVID_Coding not like '%Not COVID-19%' or [Positive Logic] = 1) and [Arrival_Date_Time] IS NOT NULL AND [Admission_Date_Time] IS NOT NULL THEN 1 ELSE 0 END AS [COVID AE Admission Flag]
,CASE 
	WHEN All_Tests_Count IS NULL THEN 1 ELSE 0 END AS [NO Test-COVID Coded] 
--,CASE 		
--	---- CHANGED FROM JUNE 2020
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 SOUTH%' THEN 'ICU'
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 WEST%' THEN 'ICU'
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 EAST%' THEN 'ICU'
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 3 NORTH A%' THEN 'ICU'
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL SHDU 3%' THEN 'ICU' 
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC North%' THEN 'ICU'
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC South%' THEN 'ICU'  
--	ELSE 'Other' END AS [Ward Group]
--,CASE 
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 SOUTH%' THEN ward_code_at_episode_end
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 WEST%' THEN ward_code_at_episode_end
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 EAST%' THEN ward_code_at_episode_end
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 3 NORTH A%' THEN ward_code_at_episode_end
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL SHDU 3%' THEN ward_code_at_episode_end 
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC North%' THEN ward_code_at_episode_end
--	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC South%' THEN ward_code_at_episode_end 
--	ELSE 'Other' END AS [Current ICU Ward]
	
	

,CASE 		
	---- CHANGED FOR SECOND SURGE
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 SOUTH%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 WEST%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 EAST%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 3 NORTH A%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 2 NORTH - PITU%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL SHDU 3%' THEN 'ICU' 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL Main Recovery Ward%'  THEN 'ICU' 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL Recovery 2 Ward%'  THEN 'ICU' 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC North%' THEN 'ICU'
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC South%' THEN 'ICU'  
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-Beech%'  THEN 'ICU'  
	ELSE 'Other' END AS [Ward Group]
,CASE 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 SOUTH%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 WEST%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL ICU 4 EAST%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 3 NORTH A%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL 2 NORTH - PITU%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL SHDU 3%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL Main Recovery Ward%'  THEN ward_code_at_episode_end 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL Recovery 2 Ward%'  THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC North%' THEN ward_code_at_episode_end
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-CC South%' THEN ward_code_at_episode_end 
	WHEN Last_Epispde_In_Spell_Indicator = 9 and ward_code_at_episode_end like '%RAL BH-Beech%'  THEN ward_code_at_episode_end  
	ELSE 'Other' END AS [Current ICU Ward]


	
,case 
	WHEN [ICU WardStays Count] >= 1 AND [Admission_Date] < '01-06-2020'THEN  [ICU WardStays Count] 
	when [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020'  and  [Admission_Date] < '01-11-2020' then [Updated ICU WardStays Count] 
	when [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' then [2nd Surge ICU WardStays Count]
	else null end AS [COVID ICU Count]

,CASE 
	WHEN [ICU WardStays Count] >= 1 AND [Admission_Date] < '01-06-2020' THEN [Total ICU LOS]
	WHEN [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then [Total ICU LOS]  
	when [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' then [Total ICU LOS]
	else null  END AS [COVID ICU LOS]

,CASE 
	WHEN [ICU WardStays Count] >= 1  AND [Admission_Date] < '01-06-2020' THEN [Total ICU LOS (Hrs)]
	WHEN [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then [Total ICU LOS (Hrs)]
	when [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' then [Total ICU LOS (Hrs)]
	else null END AS [COVID ICU LOS (Hrs)] 
	
,case 
	when [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then [Updated ICU WardStays Count] 
	else null end AS [Updated COVID ICU Count]
,case 
	when [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then [Total ICU LOS (Hrs)] 
	else null end AS [Updated COVID ICU LOS (Hrs)]
,case
	when [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then [Total ICU LOS]  
	else null end AS [Updated COVID ICU LOS]
	
,CASE 
	WHEN [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' THEN  [2nd Surge ICU WardStays Count] ELSE NULL
	END AS  [2nd Surge ICU Ward Count]
,CASE 
	WHEN [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' THEN  [Total ICU LOS (Hrs)]  ELSE NULL
	END AS  [2nd Surge ICU LOS (Hrs)]	
,CASE 
	WHEN [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' THEN  [Total ICU LOS] ELSE NULL
	END AS  [2nd Surge ICU LOS]		
	
,CASE 
	WHEN [ICU WardStays Count] >= 1 AND [Admission_Date] < '01-06-2020' THEN 'ICU'
	WHEN [Updated ICU WardStays Count] >= 1 and  [Admission_Date] >= '01-06-2020' and  [Admission_Date] < '01-11-2020' then 'ICU'
	when [2nd Surge ICU WardStays Count] >= 1 and [Admission_Date] >= '01-11-2020' then 'ICU'
	else 'Non-ICU' END AS ICU_Stay
,case 
	when [NHS Number] IS NOT NULL THEN  ROW_NUMBER() OVER (PARTITION BY [NHS Number] ORDER BY ISNULL([Admission_Date],[Discharge_Date]) DESC) 
	ELSE NULL END as Unique_NHS_Number
,Case
	when dischargeinformation = 'Died' then 'Died In Hospital'
	when DeceasedDate is not NULL then 'Died after discharge'
	else 'Survived' end as OutcomeAtDischarge,
case
	when DeceasedDate is null then null
	when datediff(dd,[Discharge_Date],DeceasedDate) < 0 then 0
	else datediff(dd,[Discharge_Date],DeceasedDate) end as Diff_DischargeDate_To_DateOfDeath,
case
	when dischargeinformation = 'Died' then 0
	when datediff(dd,[Discharge_Date],DeceasedDate) <=30  then 1 else 0 
	end as [Volume Died Out of Hospital <= 30 days]
	
,case
	when DeceasedDate is null then null
	when datediff(dd,First_Positive_Result,DeceasedDate) < 0 then 0
	else datediff(dd,First_Positive_Result,DeceasedDate) end as Positive_Swab_To_DateOfDeath


,case
	when datediff(dd,First_Positive_Result,DeceasedDate) <= 28  then 1 else 0 
	end as [Died 28 days of Positive Swab]

,case
	when First_Positive_Result >= Admission_Date_Time 
	then datediff(dd,Admission_Date_Time,First_Positive_Result)  else null
	end as [Admission to 1st Positive]
	,case
	when First_Positive_Result >= Admission_Date_Time 
	then datediff(hh,Admission_Date_Time,First_Positive_Result)  else null
	end as [Admission to 1st Positive HH]
	,case
	when First_Positive_Result < Admission_Date_Time
	then datediff(dd,First_Positive_Result,Admission_Date_Time)  else null
	end as [1st Positive to Admission]
	,case
	when First_Positive_Result < Admission_Date_Time
	then datediff(HH,First_Positive_Result,Admission_Date_Time)  else null
	end as [1st Positive to Admission HH]

,case when ISNULL(First_Order_Time, First_Event_Time) between '2020-03-10' and '2020-06-30' then 'First Wave'
when  ISNULL(First_Order_Time, First_Event_Time)  between '2020-10-01' and '2021-05-31' then 'Second Surge' else NULL END AS [Second Surge Flag]

,case when ISNULL(First_Order_Time, First_Event_Time) between '2020-03-10' and '2020-09-30' then 'First Wave'
when  ISNULL(First_Order_Time, First_Event_Time)  between '2020-10-01' and '2021-05-31' then 'Second Surge' else NULL END AS [Second Surge Inclusive]


,case when ISNULL(First_Order_Time, First_Event_Time) between '2020-04-01' and '2020-05-31' then 'Apr May'
when  ISNULL(First_Order_Time, First_Event_Time) Between '2020-12-01' and '2021-01-31' then 'Dec Jan' else NULL END AS [2m_Second_Surge]
 
,case
when First_Positive_Result < Admission_Date_Time then 1
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) <= 2)  then 1 else 0 
end as [Community Acquired Flag]	
	
,case
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) BETWEEN 3 AND 7)  then 1 else 0 
end as [Intermediate Onset Flag]	

,case
when First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) >= 8  then 1 else 0 
end as [Hospital Acquired Flag]	

,case
when First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) >= 15  then 1 else 0 
end as [Hospital Acquired Flag 15d]	

,case
when (First_Positive_Result < Admission_Date_Time) then 'Community' 
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) <= 2  ) then 'Community' 
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) BETWEEN 3 AND 7) THEN 'Intermediate onset'
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) > 7) THEN 'Hospital Acquired'
else null end as [Community/Hospital Acquired]	

,case
when (First_Positive_Result < Admission_Date_Time) then 'Community' 
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) BETWEEN 0 AND 7  ) then 'Community' 
when (First_Positive_Result >= Admission_Date_Time and datediff(dd,Admission_Date_Time,First_Positive_Result) > 7) THEN 'Hospital Acquired'
else null end as [Community/Hospital Acquired2]	


	--,[COVID IP Flag] as [Hospital Acquired Denominator]
  INTO 
   [DIV_Perf].dbo.COVID_ALL_AE_Inpatients_GA_Final
  from
  (
    select DISTINCT CVD.* 
    ,CPG3.[Avg Charlson]
    ,[CC - Myocardial Infarction],
	[CC - Cerebral vascular accident],
	[CC - Congestive Heart Failure],
	[CC - Connective Tissue Disorder],
	[CC - Dementia],
	[CC - Diabetes],
	[CC - Liver Disease],
	[CC - Peptic Ulcer],
	[CC - Peripheral Vascular Disease],
	[CC - Pulmonary Disease],
	[CC - Cancer],
	[CC - Diabetes complications],
	[CC - Paraplegia],
	[CC - Renal Disease],
	[CC - Metastic Cancer],
	[CC - Severe Liver Disease],
	[CC - HIV],
	[NumberOfCharlsonComorbidities]
	,[Comorbidities_String Ordered by Score]
	,cpg.[Discharge Date] AS [Previous Discharge Date] 
	,CPG2.[Avg Charlson] AS [Previous Avg Charlson]
	,OutOfHospitalDeaths.MRN,
	OutOfHospitalDeaths.NHSNUMBER,
	 OutOfHospitalDeaths.DeceasedDate

			,CC_AdvancedRespiratorySupport
			,CC_BasicRespiratorySupport
			,CC_AdvanceCardioSupport,
			CC_BasicCardioSupport,
			CC_RenalSupport,
			CC_NeuroSupport,
			CC_GISupport,
			CC_DermatologicalSupport,
			CC_LiverSupport,
			CC_Level2Days,
			CC_Level3Days,
			CC_Days,
			MaximumOrganSupport


	 from [DIV_Perf].dbo.COVID_ALL_AE_Inpatients_GA CVD

	LEFT JOIN (
  	select DISTINCT
	[MRN],
	max([Discharge Date]) as [Discharge Date]
	from [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics] 
	WHERE [Avg Charlson] IS NOT NULL
		AND [Avg Charlson] <> 0 
		and [Last_Episode_in_Spell_Indicator] = 1
	GROUP BY
	[MRN]

) CPG
	ON LOCAL_PATIENT_IDENTIFIER = CPG.MRN
	AND CPG.[Discharge Date] < [Admission_Date]
	AND CPG.[Discharge Date] < [Arrival_Date_Time]

	LEFT JOIN (
  	select DISTINCT
	[MRN],
	[Avg Charlson],
	max([Discharge Date]) as [Discharge Date]
	from [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics] 
	WHERE [Avg Charlson] IS NOT NULL
		AND [Avg Charlson] <> 0 
		and [Last_Episode_in_Spell_Indicator] = 1
	GROUP BY
	[MRN],
	[Avg Charlson]
) CPG2
	ON CPG2.MRN = CPG.MRN
	AND CPG.[Discharge Date] = CPG2.[Discharge Date]

	LEFT JOIN (
  	select DISTINCT
	[MRN],[Spell No],
	[Avg Charlson],
	[CC - Myocardial Infarction],
	[CC - Cerebral vascular accident],
	[CC - Congestive Heart Failure],
	[CC - Connective Tissue Disorder],
	[CC - Dementia],
	[CC - Diabetes],
	[CC - Liver Disease],
	[CC - Peptic Ulcer],
	[CC - Peripheral Vascular Disease],
	[CC - Pulmonary Disease],
	[CC - Cancer],
	[CC - Diabetes complications],
	[CC - Paraplegia],
	[CC - Renal Disease],
	[CC - Metastic Cancer],
	[CC - Severe Liver Disease],
	[CC - HIV],
	[NumberOfCharlsonComorbidities]
	,[Comorbidities_String Ordered by Score]
	from [DIV_Perf].dbo.[CPG_Pathway_Analytics_Metrics] 
	WHERE [Avg Charlson] IS NOT NULL
		AND [Avg Charlson] <> 0 
		and [Last_Episode_in_Spell_Indicator] = 1
) CPG3
	ON CPG3.[Spell No] = [Spell_Number]
	AND CPG3.MRN = IP_Local_Patient_Identifier
	LEFT JOIN
(SELECT Distinct MRN, NHSNUMBER, DeceasedDate from ##SW_DeathsOnSpine
) As OutOfHospitalDeaths on OutOfHospitalDeaths.NHSNUMBER = [NHS NUMBER]

left join 
(
select 
distinct
HospitalNum,
APC_G.spellnumber,
sum(AdvancedRespiratorySupport*1) as CC_AdvancedRespiratorySupport,
sum(BasicRespiratorySupport*1) as CC_BasicRespiratorySupport,
sum(AdvanceCardioSupport*1) as CC_AdvanceCardioSupport,
sum(BasicCardioSupport*1) as CC_BasicCardioSupport,
sum(RenalSupport*1) as CC_RenalSupport,
sum(NeuroSupport*1) as CC_NeuroSupport,
sum(GISupport*1) as CC_GISupport,
sum(DermatologicalSupport*1) as CC_DermatologicalSupport,
sum(LiverSupport*1) as CC_LiverSupport,
sum(Level2*1) as CC_Level2Days,
sum(Level3*1) as CC_Level3Days,
sum(Level2*1)+sum(Level3*1) as CC_Days,
max(MaximumOrganSupport*1) as MaximumOrganSupport
from  Ardentia_Healthware_64_Release.dbo.[RFCCALL_General] G
inner join Ardentia_Healthware_64_Release.dbo.[RFCCALL_Locals] L on ( G.RFCCALLJoinKey = l.RFCCALLJoinKey)
inner join Ardentia_Healthware_64_Release.dbo.apc_general  APC_G  on (l.Link_CDSID = APC_G.episodeserialnumber )
where startdate >= '01/02/2015 00:00:00'
group by 
HospitalNum,APC_G.spellnumber
) as   d 
on d.spellnumber = [Spell_Number]



) DATA

order by fin asc







