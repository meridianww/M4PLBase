/****** Object:  StoredProcedure [dbo].[GetVocReportData]    Script Date: 11/11/2019 12:55:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC [dbo].[GetVocReportData] 0,NULL,NULL,NULL,1
-- =============================================
ALTER PROCEDURE [dbo].[GetVocReportData] 
@CompanyId BIGINT, 
@LocationCode NVARCHAR(50) = NULL,
@StartDate DATETIME2 = NULL,
@EndDate DATETIME2 = NULL,
@IsPBSReport bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Query NVARCHAR(MAX);;
	DECLARE @HavingString NVARCHAR(4000) = '';

	DECLARE @PropertiesSet NVARCHAR(4000) = '';
	DECLARE @FilterCondition NVARCHAR(4000) = '';

	 IF (@StartDate IS NOT NULL AND @EndDate IS NOT NULL)
	 BEGIN
		SELECT @HavingString = ' HAVING (svyusr.DateEntered >= ''' + CONVERT(nvarchar, @StartDate) + ''' And svyusr.DateEntered <= ''' + CONVERT(nvarchar, @EndDate) + ''')';
	 END	

	CREATE TABLE #Customer(JobId NVARCHAR(100),CustCode NVARCHAR(100),JobSiteCode NVARCHAR(100));

	IF((@IsPBSReport = 0 AND @CompanyId <> 0 AND  @CompanyId IS NOT NULL AND @CompanyId > 0) 
	   AND  (@LocationCode IS NULL OR @LocationCode = '' OR @LocationCode = 'All'))
	BEGIN
			INSERT INTO #Customer 
			SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
			INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
			INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
			WHERE  PRG.PrgCustID = @CompanyId AND JB.JobSiteCode IS NOT NULL 
			 AND JB.JobSiteCode <> '' AND JB.StatusId IN (1,2) AND CUST.StatusId = 1
	END	
	ELSE IF(@IsPBSReport = 0 AND @CompanyId <> 0 AND @CompanyId IS NOT NULL AND @CompanyId>0 AND @LocationCode IS NOT NULL AND @LocationCode <> '' AND @LocationCode <> 'All')
	BEGIN
		INSERT INTO #Customer 
		SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
		INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
		INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
		WHERE PRG.PrgCustID = @CompanyId AND JB.JobSiteCode = @LocationCode AND  JB.JobSiteCode IS NOT NULL 
			AND JB.JobSiteCode <> '' AND JB.StatusId IN (1,2) AND CUST.StatusId = 1
	END
	ELSE IF(@IsPBSReport = 0 AND @CompanyId = 0 AND (@LocationCode IS NULL OR @LocationCode = '' OR @LocationCode = 'All'))
	BEGIN	
			INSERT INTO #Customer 
			SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
			INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
			INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
			WHERE JB.JobSiteCode IS NOT NULL  AND JB.JobSiteCode <> '' AND JB.StatusId IN (1,2) AND CUST.StatusId = 1
	END	
	ELSE IF(@IsPBSReport = 1)
	BEGIN	
			INSERT INTO #Customer 
			SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
			INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
			INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
			WHERE JB.JobSiteCode IS NOT NULL  AND JB.JobSiteCode <> '' 
	END	
	 IF(@IsPBSReport = 0 )
	 BEGIN
	    SELECT @PropertiesSet = ' cust.CustCode as CustCode, cust.JobSiteCode AS LocationCode ';
	    SELECT @FilterCondition = ' INNER JOIN #Customer cust ON  svyusr.EntityTypeId = cust.JobId GROUP BY cust.CustCode, cust.JobSiteCode, ';
	 END
	 ELSE
	 BEGIN
	    SELECT @PropertiesSet = '  CASE WHEN (svyusr.CustName IS NULL) THEN ''Not Specified'' ELSE svyusr.CustName END  AS CustCode,  CASE WHEN (svyusr.LocationCode IS NULL) THEN ''Unknown'' ELSE svyusr.LocationCode END  AS LocationCode ';
	    SELECT @FilterCondition = ' WHERE ((((svyusr.CustName) IS NOT NULL) OR ((svyusr.LocationCode) IS NOT NULL)) OR ((svyusr.DriverId) IS NOT NULL) OR ((svyusr.ContractNumber) IS NOT NULL) ) GROUP BY svyusr.CustName, svyusr.LocationCode,  ';
	 END
	   SELECT @Query = 'SELECT ' +@PropertiesSet+ '
		,svyusr.ContractNumber AS ContractNumber
		,Max(svyusr.DriverId) AS DriverId 
		,Sum(IIf([mvoqns].[QueTitle] = ''Delivery Satisfaction'', [SelectedAnswer] * 4, 0)) AS [DeliverySatisfaction]
		,Sum(IIf([mvoqns].[QueTitle] = ''CSR Professionalism'', [SelectedAnswer] * 4, 0)) AS [CSRProfessionalism]
		,Sum(IIf([mvoqns].[QueTitle] = ''Advance Delivery Time'', [SelectedAnswer] * 4, 0)) AS [AdvanceDeliveryTime]
		,Sum(IIf([mvoqns].[QueTitle] = ''Driver Professionalism'', [SelectedAnswer] * 4, 0)) AS [DriverProfessionalism]
		,Sum(IIf([mvoqns].[QueTitle] = ''Delivery Team Helpfulness'', [SelectedAnswer] * 4, 0)) AS [DeliveryTeamHelpfulness]
		,Sum(IIf([mvoqns].[QueTitle] = ''Delivery Satisfaction'', [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = ''CSR Professionalism''
		, [SelectedAnswer] * 4, 0)) + Sum(IIf([mvoqns].[QueTitle] = ''Advance Delivery Time'', [SelectedAnswer] * 4, 0)) 
		+ Sum(IIf([mvoqns].[QueTitle] = ''Driver Professionalism'', [SelectedAnswer] * 4, 0)) 
		+ Sum(IIf([mvoqns].[QueTitle] = ''Delivery Team Helpfulness'', [SelectedAnswer] * 4, 0)) AS [OverallScore]
		,Max(svyusr.DateEntered) as DateEntered
		FROM MVOC000Program prgm
		INNER JOIN SVYUSER000Master svyusr ON prgm.Id = svyusr.SurveyId
		INNER JOIN SVYANS000Master svyans ON svyans.SurveyUserId = svyusr.Id
		INNER JOIN MVOC010Ref_Questions mvoqns ON svyans.QuestionId = mvoqns.Id	
		' +@FilterCondition+ ' svyusr.ContractNumber, svyusr.DateEntered ' +@HavingString
   
    EXEC SP_EXECUTESQL @Query
	DROP TABLE #Customer;

END