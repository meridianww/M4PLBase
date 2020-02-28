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
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
,@CompanyId BIGINT = 0
AS
BEGIN
DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @TCountQuery NVARCHAR(MAX);
--------------------- Security ----------------------------------------------------------
	 DECLARE @JobCount BIGINT,@IsJobAdmin BIT = 0
IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
BEGIN
DROP TABLE #EntityIdTemp
END

 CREATE TABLE #EntityIdTemp
(
EntityId BIGINT
)
IF(ISNULL(@IsJobAdmin, 0) = 0)
BEGIN
SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END  

	INSERT INTO #EntityIdTemp
EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Job'--@entity
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity    

SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = 99999999999


	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END 
	
	SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobAdvanceReport.[ProgramID] INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  '   
    IF(ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
	SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END 
	print @TCountQuery
	--------------------------end-----------------------------------------------------
    DECLARE @where NVARCHAR(500)
	Declare @JobStatusId bigint;	     
	SET @where = ' AND JobCard.StatusId = 1 ';	

       SET @CompanyId = ISNULL(@CompanyId, 0);
		DECLARE 
		@TempRecordCount INT
		,@TempRecordCounter INT = 1
		,@CurrentDashboardCategoryRelationId BIGINT
		,@CurrentCustomQuery VARCHAR(5000)
		,@CountQuery NVARCHAR(Max)
		,@RecordCount INT = 0


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
		,BackGroundColor nvarchar(100) 
		,FontColor nvarchar(100)
		,RecordCount INT
		)

	INSERT INTO #TempCount (
		DashboardCategoryRelationId
		,DashboardName
		,DashboardCategoryDisplayName
		,DashboardSubCategoryDisplayName
		,BackGroundColor
		,FontColor
		,CustomQuery
		)
	SELECT DCR.DashboardCategoryRelationId
		,D.DashboardName
		,DC.DashboardCategoryDisplayName
		,DSC.DashboardSubCategoryDisplayName
		,DCR.BackGroundColor
		,DCR.FontColor
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
					INNER JOIN JOBDL000Master JobCard ON JobCard.Id = Gateway.JobId
					INNER JOIN dbo.PRGRM000Master Program ON Program.Id = JobCard.ProgramID
					INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID'
	------------------------------------
		IF(ISNULL(@IsJobAdmin, 0) = 0)
BEGIN
SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END 
		------------------------------				
					
					SET @CountQuery = @CountQuery+' Where  Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  ' + @where +  @CurrentCustomQuery + '  AND Program.PrgCustID =  ' + + CONVERT(nvarchar,@CompanyId)
					
				END
				ELSE
				BEGIN
					SET @CountQuery = 'Select @RecordCount = COUNT(DISTINCT JobCard.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) JobCard INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobCard.[ProgramID]
					INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  INNER JOIN JOBDL020Gateways Gateway ON Gateway.JobId =  JobCard.Id'
						------------------------------------
		IF(ISNULL(@IsJobAdmin, 0) = 0)
BEGIN
SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
END 
		------------------------------
					SET @CountQuery = @CountQuery+' Where Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  '+@where +  @CurrentCustomQuery
				END

				EXEC sp_executesql @CountQuery
					,N'@RecordCount int OUTPUT'
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