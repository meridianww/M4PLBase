/****** Object:  StoredProcedure [dbo].[GetCardTileData]    Script Date: 02/17/2019 12:55:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

ALTER PROCEDURE [dbo].[GetCardTileData] 
@CompanyId BIGINT = 0
AS
BEGIN
    DECLARE @where NVARCHAR(500)
	Declare @JobStatusId bigint;	     
    SELECT @JobStatusId = Id from SYSTM000Ref_Options where SysLookupCode = 'Status' AND SysOptionName = 'Active' AND Id IS NOT NULL
	SET @where = ' AND JobCard.StatusId = '+ CONVERT(nvarchar,@JobStatusId) +' ';	

       SET @CompanyId = ISNULL(@CompanyId, 0);
		DECLARE @GatewayActionType INT
		,@TempRecordCount INT
		,@TempRecordCounter INT = 1
		,@CurrentDashboardCategoryRelationId BIGINT
		,@CurrentCustomQuery VARCHAR(5000)
		,@CountQuery NVARCHAR(Max)
		,@RecordCount INT = 0

	SELECT @GatewayActionType = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	IF OBJECT_ID('tempdb..#TempCount') IS NOT NULL
	BEGIN
		DROP TABLE #TempCount
	END

	CREATE TABLE #TempCount (
		ID INT IDENTITY(1, 1)
		,DashboardCategoryRelationId BIGINT
		,CustomQuery VARCHAR(5000)
		,DashboardName VARCHAR(150)
		,DashboardCategoryDisplayName VARCHAR(150)
		,DashboardSubCategoryDisplayName VARCHAR(150)
		,RecordCount INT
		)

	INSERT INTO #TempCount (
		DashboardCategoryRelationId
		,DashboardName
		,DashboardCategoryDisplayName
		,DashboardSubCategoryDisplayName
		,CustomQuery
		)
	SELECT DCR.DashboardCategoryRelationId
		,D.DashboardName
		,DC.DashboardCategoryDisplayName
		,DSC.DashboardSubCategoryDisplayName
		,DCR.CustomQuery
	FROM DashboardCategoryRelation DCR
	INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
	INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
	INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory

	SELECT @TempRecordCount = Count(ISNULL(Id, 0))
	FROM #TempCount
	
	IF (@TempRecordCount > 0)
	BEGIN
		WHILE (@TempRecordCount > 0)
		BEGIN
			SET @RecordCount = 0
			SET @CountQuery = ''

			SELECT @CurrentDashboardCategoryRelationId = DashboardCategoryRelationId
				,@CurrentCustomQuery = CustomQuery
			FROM #TempCount
			WHERE Id = @TempRecordCounter

			IF (ISNULL(@CurrentCustomQuery, '') <> '')
			BEGIN
			    IF (@CompanyId >0)
				BEGIN
					SET @CountQuery = 'Select @RecordCount = Count(DISTINCT JobId) From JOBDL020Gateways Gateway
					INNER JOIN JOBDL000Master Job ON Job.Id = Gateway.JobId
					INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
					INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID
					Where  Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  AND ' + @CurrentCustomQuery + '  AND Program.PrgCustID =  ' + + CONVERT(nvarchar,@CompanyId)
					
				END
				ELSE
				BEGIN
					SET @CountQuery = 'Select @RecordCount = COUNT(DISTINCT JobCard.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) JobCard INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobCard.[ProgramID]
					INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  INNER JOIN JOBDL020Gateways Gateway ON Gateway.JobId =  JobCard.Id
					Where Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  '+@where + ' AND '+ @CurrentCustomQuery
				END

				EXEC sp_executesql @CountQuery
					,N'@GatewayActionType INT,@RecordCount int OUTPUT'
					,@GatewayActionType = @GatewayActionType
					,@RecordCount = @RecordCount OUTPUT
			END

			UPDATE #TempCount
			SET RecordCount = @RecordCount
			WHERE Id = @TempRecordCounter

			SET @TempRecordCounter = @TempRecordCounter + 1
			SET @TempRecordCount = @TempRecordCount - 1
		END
	END

	SELECT *
	FROM #TempCount

	DROP TABLE #TempCount
END


