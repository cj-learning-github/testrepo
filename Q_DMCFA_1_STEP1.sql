/* -------------------------------------------------------- */
/* Q_DMCFA_1 SECTION1			STEP 1						*/
/* -------------------------------------------------------- */
--SET SHOWPLAN_XML OFF;
--SET SHOWPLAN_XML ON;
--SET STATISTICS PROFILE ON;

USE MOSTRAIN2 

-- -----------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'SSAFA_REPORTS.TEMP_100_Section1_ALL')			IS NOT NULL	DROP TABLE SSAFA_REPORTS.TEMP_100_Section1_ALL		
-- -----------------------------------------------------------------------------------------------------------------------
DECLARE @DYS_BACK INTEGER			= 1;
DECLARE @THIS_DAY DATE				= GETDATE()

DECLARE @SD_FULL as DATE			= DATEADD(DAY, -@DYS_BACK, @THIS_DAY)
DECLARE @TXTX as varchar(100)		= ' '
DECLARE @QRY_START_DATE DATETIME	= CAST(@SD_FULL as DATE) 
DECLARE @QRY_END_DATE DATE			=  @THIS_DAY /*  date range end for query			 */
-- ----------------------------------------------------------------------------------------

SELECT 
	ROW_NUMBER() OVER(ORDER BY DMWFS.SUBGROUP_ID ASC) AS ROW_NR,
	SGS.PERSON_ID, 
	DMWFS.WORKFLOW_STEP_ID,
	WFSTYP.WORKFLOW_STEP_TYPE_ID,
	DMWFS.STARTED_ON,
--	DMWFS.INCOMING_ON, 
	CONVERT(varchar(255),
	(CASE
		WHEN TEXT_ANSWER	is not null THEN TEXT_ANSWER
		WHEN DATE_ANSWER	is not null THEN CONVERT(nvarchar, DATE_ANSWER, 105)
		WHEN NUMBER_ANSWER	is not null THEN CONVERT(nvarchar, CAST(NUMBER_ANSWER as numeric(10,2)))
	 ELSE
		'-'
	 END)) as QUC_ANSWER, 

	DMCFA.DISPLAY_SEQUENCE,
	DMCFA.QUESTION_USER_CODE--,
--	@TXTX as SECTION1_SUMMARY

INTO 
	SSAFA_REPORTS.TEMP_100_Section1_ALL
FROM 
	DM_CACHED_FORM_ANS DMCFA					WITH	(INDEX(xif3dm_cached_form_ans))
	LEFT JOIN DM_WORKFLOW_STEPS DMWFS			ON		DMWFS.WORKFLOW_STEP_ID = DMCFA.WORKFLOW_STEP_ID
	INNER JOIN DM_SUBGROUP_PERSONS SGS			ON		SGS.SUBGROUP_ID = DMCFA.SUBGROUP_ID
	INNER JOIN DM_WORKFLOW_STEP_TYPES WFSTYP	ON		WFSTYP.WORKFLOW_STEP_TYPE_ID	= DMWFS.WORKFLOW_STEP_TYPE_ID 
WHERE 
	QUESTION_USER_CODE in
		(
'cobseoFLDForenames',
'cobseoFLDSurname',
'cobseoFLDAddress',
'cobseoCOLSpousePersonDetailsFPFLDDOB',
'cobseoCOLSpousePartnersRSFLDReasonForSeparateAddress',
'cobseoCOLSpousePartnersRSFLDReligion',
'cobseoCOLSpousePartnersRSFPFLDAddress',
'cobseoCOLSpousePartnersRSFPFLDDOB',
'cobseoCOLSpousePartnersRSFPFLDEmail',
'cobseoCOLSpousePartnersRSFPFLDForenames',
'cobseoCOLSpousePartnersRSFPFLDNI',
'cobseoCOLSpousePartnersRSFPFLDPlaceOfBirth',
'cobseoCOLSpousePartnersRSFPFLDSurname',
'cobseoCOLSpousePartnersRSFPFLDTelephone',
'cobseoFLDAccomodationType',
'cobseoFLDAnySpouse',
'cobseoFLDDateOfDivorceSeparation',
'cobseoFLDDateOfMarriage',
'cobseoFLDDateSpouseDied',
'cobseoFLDDOB',
'cobseoFLDEmailAddress', 
'cobseoFLDGender',
'cobseoFLDHousingStatus',
'cobseoFLDMaritalStatus',
'cobseoFLDMonthsAtAddress',
'cobseoFLDNINumber',
'cobseoFLDPlaceOfBirth',
'cobseoFLDPreviousAddress',
'cobseoFLDRelationshipToEligiblePerson',
'cobseoFLDRelationshipToEligiblePersonOther',
'cobseoFLDReligionDropdown',
'cobseoFLDTelephone',
'cobseoFLDYearsAtAddress'  
		)
		
ORDER BY 
	SGS.PERSON_ID 
