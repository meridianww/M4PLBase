SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kamal
-- Create date: 19/03/2019
-- Description:	GetVocReportData
-- EXEC [dbo].[GetVocReportData] 20043,20037,1,10007,NULL,NULL,NULL,1
-- =============================================
CREATE PROCEDURE [dbo].[GetVocReportData]
	 @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT 
	,@CompanyId BIGINT 
	,@LocationCode NVARCHAR(MAX) = NULL
	,@StartDate DATETIME2 = NULL
	,@EndDate DATETIME2 = NULL
	,@IsPBSReport bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Query NVARCHAR(MAX);;
	DECLARE @HavingString NVARCHAR(MAX) = '';

	DECLARE @PropertiesSet NVARCHAR(MAX) = '';
	DECLARE @FilterCondition NVARCHAR(MAX) = '';

	------security start------
	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END
	CREATE TABLE #EntityIdTemp(EntityId BIGINT)
	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId, @orgId, 'Program',0,1

	------security end------

	 IF (@StartDate IS NOT NULL AND @EndDate IS NOT NULL)
	 BEGIN
		SELECT @HavingString = ' HAVING (CAST(svyusr.DateEntered AS DATE) >= ''' + CONVERT(NVARCHAR, CAST(@StartDate AS DATE)) 
		+ ''' And CAST(svyusr.DateEntered AS DATE) <= ''' + CONVERT(NVARCHAR, CAST(@EndDate AS DATE)) + ''')';
	 END	
	 print @HavingString
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
	ELSE IF(@IsPBSReport = 0 AND @CompanyId <> 0 AND @CompanyId IS NOT NULL AND @CompanyId>0 AND @LocationCode IS NOT NULL 
	AND @LocationCode <> '' AND @LocationCode <> 'All' AND LEN(@LocationCode) > 0)
	BEGIN 
		INSERT INTO #Customer 
		SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
		INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
		INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
		WHERE PRG.PrgCustID = @CompanyId AND  JB.JobSiteCode IS NOT NULL 
			AND JB.JobSiteCode <> '' AND JB.StatusId IN (1,2) AND CUST.StatusId = 1
			AND JB.JobSiteCode IN (
				SELECT *
				FROM fnSplitString(@LocationCode, ',')
				)
	END
	ELSE IF(@IsPBSReport = 0 AND @CompanyId = 0 AND @CompanyId IS NOT NULL AND @LocationCode IS NOT NULL AND @LocationCode <> '' AND @LocationCode <> 'All')
	BEGIN	 
		INSERT INTO #Customer 
		SELECT DISTINCT JB.Id,CUST.CustCode,JB.JobSiteCode FROM JOBDL000Master JB
		INNER JOIN  PRGRM000Master PRG ON JB.ProgramID = PRG.Id
		INNER JOIN CUST000Master  CUST ON 	PRG.PrgCustID = CUST.Id
		WHERE JB.JobSiteCode IS NOT NULL 
			AND JB.JobSiteCode <> '' AND JB.StatusId IN (1,2) AND CUST.StatusId = 1
			AND JB.JobSiteCode IN (
				SELECT *
				FROM fnSplitString(@LocationCode, ',')
				) 
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
	   SET @Query = 'SELECT ' +@PropertiesSet+ '
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
		,svyusr.Feedback AS Feedback
		FROM MVOC000Program prgm
		INNER JOIN SVYUSER000Master svyusr ON prgm.Id = svyusr.SurveyId '
		IF NOT EXISTS (SELECT 1 FROM #EntityIdTemp WHERE ISNULL(EntityId, 0) = -1)
		BEGIN
			SET @Query = @Query+ ' INNER JOIN #EntityIdTemp program ON program.EntityId = prgm.VocProgramID '
		END
		SET @Query = @Query+ ' INNER JOIN SVYANS000Master svyans ON svyans.SurveyUserId = svyusr.Id
		INNER JOIN MVOC010Ref_Questions mvoqns ON svyans.QuestionId = mvoqns.Id	
		' +@FilterCondition+ ' svyusr.ContractNumber, svyusr.DateEntered,svyusr.Feedback ' +@HavingString
     print @Query
    EXEC SP_EXECUTESQL @Query
	DROP TABLE #Customer;

END

GO
