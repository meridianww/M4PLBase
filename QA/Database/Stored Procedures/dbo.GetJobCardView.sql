SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prasanta Mahankuda         
-- Create date:               02/13/2020      
-- Description:               Get Job Card View
-- =============================================
ALTER PROCEDURE [dbo].[GetJobCardView] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@groupBy NVARCHAR(500)
	,@groupByWhere NVARCHAR(500)
	,@where NVARCHAR(MAX) = ''
	,@parentId BIGINT
	,@isNext BIT
	,@isEnd BIT
	,@recordId BIGINT
	,@IsExport BIT = 0
	,@orderType NVARCHAR(500) = ''
	,@dashCategoryRelationId BIGINT = 0
	,@ColorCode VARCHAR(50) = NULL
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;
	SET @entity = 'JOBDL000Master';

	DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@CustomQuery NVARCHAR(MAX)
		,@GatewayIsScheduleQuery NVARCHAR(MAX) = ''
		,@GatewayStatus NVARCHAR(500) = ' INNER JOIN  SYSTM000Ref_Options ON SYSTM000Ref_Options.Id = JOBDL020Gateways.StatusId AND SYSTM000Ref_Options.SysOptionName in (''Active'',''Completed'')'
		,@GatewayTypeId INT = 0
		,@GatewayActionTypeId INT = 0
		,@DashBoardCatagory NVARCHAR(50) = ''
		,@DashBoardSubCatagory NVARCHAR(50) = '';

	SELECT @DashBoardSubCatagory = DSC.DashboardSubCategoryName
		,@DashBoardCatagory = DC.DashboardCategoryName
	FROM DashboardCategoryRelation DCR
	INNER JOIN DashboardCategory DC ON DCR.DashboardCategoryId = DC.DashboardCategoryId
	INNER JOIN DashboardSubCategory DSC ON DCR.DashboardSubCategory = DSC.DashboardSubCategoryId
	WHERE DCR.DashboardCategoryRelationId = @dashCategoryRelationId

	IF (@DashBoardCatagory = 'NotScheduled')
	BEGIN
		SET @OrderBy = CASE 
				WHEN ISNULL(@OrderBy, '') = ''
					THEN ' JOBDL000Master.JobOriginDateTimePlanned ASC '
				ELSE @OrderBy
				END
	END
	ELSE IF (
			@DashBoardCatagory = 'SchedulePastDue'
			OR @DashBoardCatagory = 'ScheduledForToday'
			)
	BEGIN
		SET @OrderBy = CASE 
				WHEN ISNULL(@OrderBy, '') = ''
					THEN ' JOBDL000Master.JobDeliveryDateTimePlanned ASC '
				ELSE @OrderBy
				END
	END

	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @GatewayActionTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	--------------------- Security ----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
	END

	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Job' --@entity

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM JOBDL000Master (NOLOCK) ' + @entity

	SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdTemp
	WHERE ISNULL(EntityId, 0) = - 1

	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END

	SET @dashCategoryRelationId = ISNULL(@dashCategoryRelationId, 0);
	SET @where = CASE 
			WHEN ISNULL(@where, '') = ''
				THEN ' AND JOBDL000Master.StatusId = 1 '
			ELSE ' AND JOBDL000Master.StatusId = 1 ' + @where
			END;

	DECLARE @Daterange NVARCHAR(500)

	IF (@dashCategoryRelationId > 0)
	BEGIN
		SELECT TOP 1 @CustomQuery = DCR.CustomQuery
		FROM DashboardCategoryRelation DCR
		INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
		INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
		INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory
		WHERE DCR.DashboardCategoryRelationId = @dashCategoryRelationId

		IF (
				@DashBoardCatagory = 'NotScheduled'
				AND (@DashBoardSubCatagory <> 'Returns')
				)
		BEGIN
			SET @GatewayIsScheduleQuery = ' INNER JOIN LatestNotSceduleGatewayIds on LatestNotSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
		END
		ELSE IF (
				(
					@DashBoardCatagory = 'SchedulePastDue'
					OR @DashBoardCatagory = 'ScheduledForToday'
					)
				AND (@DashBoardSubCatagory <> 'Returns')
				)
		BEGIN
			SET @GatewayIsScheduleQuery = ' INNER JOIN LatestSceduleGatewayIds  on LatestSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
		END
	END

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(DISTINCT JOBDL000Master.Id) FROM JOBDL000Master (NOLOCK) INNER JOIN PRGRM000Master (NOLOCK) ON PRGRM000Master.[Id]=JOBDL000Master.[ProgramID] ' + ' INNER JOIN CUST000Master (NOLOCK) ON CUST000Master.[Id]=PRGRM000Master.[PrgCustID]   '

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
	END

	--------------------------end-----------------------------------------------------
	--SET @where = @where + ' AND Gateway.StatusId IN (select Id from SYSTM000Ref_Options (NOLOCK) where SysOptionName in (''Active'',''Completed''))  '
	IF (ISNULL(@CustomQuery, '') <> '')
	BEGIN
		SET @where = @where + @CustomQuery;
	END

	SET @TCountQuery = @TCountQuery + ' INNER JOIN vwJobGateways JOBDL020Gateways (NOLOCK)  ON JOBDL020Gateways.JobID=JOBDL000Master.[Id] ' + @GatewayIsScheduleQuery + @GatewayStatus + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @where;

	EXEC sp_executesql @TCountQuery
		,N'@userId BIGINT, @TotalCount INT OUTPUT'
		,@userId
		,@TotalCount OUTPUT;

	IF (
			(ISNULL(@groupBy, '') = '')
			OR (@recordId > 0)
			)
	BEGIN
		IF (@recordId = 0)
		BEGIN
			DECLARE @QueryData VARCHAR(Max)

			SELECT @QueryData = 
				'JOBDL000Master.Id, JOBDL000Master.JobCarrierContract, JOBDL000Master.JobCustomerPurchaseOrder, JOBDL000Master.JobCustomerSalesOrder, 
JOBDL000Master.JobDeliveryCity, JOBDL000Master.JobDeliveryDateTimeActual, JOBDL000Master.JobDeliveryDateTimePlanned, JOBDL000Master.JobDeliveryPostalCode,
 JOBDL000Master.JobDeliverySiteName, JOBDL000Master.JobDeliverySitePOC, JOBDL000Master.JobDeliverySitePOCEmail, JOBDL000Master.JobDeliverySitePOCPhone, 
 JOBDL000Master.JobDeliverySitePOCPhone2, JOBDL000Master.JobDeliveryState, JOBDL000Master.JobDeliveryStreetAddress, JOBDL000Master.JobDeliveryStreetAddress2, 
 JOBDL000Master.JobGatewayStatus, JOBDL000Master.JobMITJobID, JOBDL000Master.JobOrderedDate, JOBDL000Master.JobOriginDateTimeActual, JOBDL000Master.JobOriginDateTimePlanned, 
 JOBDL000Master.JobPartsActual, JOBDL000Master.JobQtyActual, JOBDL000Master.JobSellerSiteName, JOBDL000Master.JobServiceMode, JOBDL000Master.JobSiteCode, JOBDL000Master.JobTotalCubes,
  JOBDL000Master.PlantIDCode, JOBDL000Master.StatusId ' 
				--[dbo].[fnGetGridBaseQueryByUserId](@entity, @userId)

			SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobPartsActual', 'CASE WHEN ISNULL(JOBDL000Master.JobPartsActual, 0) > 0 THEN CAST(JOBDL000Master.JobPartsActual AS INT)  ELSE NULL END JobPartsActual');

			SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobQtyActual', 'CASE WHEN ISNULL(JOBDL000Master.JobQtyActual, 0) > 0 THEN CAST(JOBDL000Master.JobQtyActual AS INT) ELSE NULL END JobQtyActual');

			SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobPartsOrdered', 'CAST(JOBDL000Master.JobPartsOrdered AS INT) JobPartsOrdered');

			SELECT @QueryData = @QueryData + CASE 
					WHEN ISNULL(@ColorCode, '') <> ''
						THEN CONCAT (
								' ,'''
								,@ColorCode + ''' AS JobColorCode '
								)
					WHEN ISNULL(@ColorCode, '') = 'NA'
						THEN ' ,NULL AS JobColorCode '
					ELSE ', CASE WHEN ISNULL(JOBDL000Master.JobOriginDateTimePlanned , '''') = '''' 
			        THEN NULL WHEN  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) <= CONVERT(date, GETUTCDATE() + 2) THEN ''#FF0000''
			                  WHEN  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) > CONVERT(date, GETUTCDATE() + 2) 
									AND  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) <= CONVERT(date, GETUTCDATE() + 5) THEN ''#FFFF00''
							  WHEN CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) > CONVERT(date, GETUTCDATE() + 5) THEN ''#008000'' 
							  ELSE NULL END AS JobColorCode'
					END

			SET @sqlCommand = 'SELECT DISTINCT ' + @QueryData
		END
		ELSE
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id') + '), 0) AS Id '
			END
			ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
		END

		SET @sqlCommand = @sqlCommand + ' ,CUST000Master.CustTitle FROM JOBDL000Master (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' INNER JOIN PRGRM000Master (NOLOCK) ON PRGRM000Master.[Id] = ' + @entity + '.[ProgramID] '
		SET @sqlCommand = @sqlCommand + ' INNER JOIN CUST000Master (NOLOCK) ON CUST000Master.[Id]=PRGRM000Master.[PrgCustID] ' + ' INNER JOIN vwJobGateways JOBDL020Gateways ON JOBDL020Gateways.JobID=' + @entity + '.[Id] ' + @GatewayIsScheduleQuery + @GatewayStatus

		------------------------------------
		IF (ISNULL(@IsJobAdmin, 0) = 0)
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
		END

		------------------------------
		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			DECLARE @orderByJoinClause NVARCHAR(500);

			SELECT @orderBy = OrderClause
				,@orderByJoinClause = JoinClause
			FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);

			IF (ISNULL(@orderByJoinClause, '') <> '')
			BEGIN
				SET @sqlCommand = @sqlCommand + @orderByJoinClause
			END
		END

		IF (ISNULL(@where, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> '''' ' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		END

		IF (
				(@recordId > 0)
				AND (
					(
						(@isNext = 0)
						AND (@isEnd = 0)
						)
					OR (
						(@isNext = 1)
						AND (@isEnd = 0)
						)
					)
				)
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				IF (
						(ISNULL(@orderBy, '') <> '')
						AND (CHARINDEX(',', @orderBy) = 0)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id <= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				IF (
						(ISNULL(@orderBy, '') <> '')
						AND (CHARINDEX(',', @orderBy) = 0)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) AND ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> '''' ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id >= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + ISNULL(@orderBy, '' + @entity + '.Id')

		IF (
				@recordId = 0
				AND @IsExport = 0
				)
		BEGIN
			IF (ISNULL(@groupByWhere, '') <> '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
			END
			ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
			END
		END
		ELSE
		BEGIN
			IF (@orderBy IS NULL)
			BEGIN
				IF (
						(
							(@isNext = 1)
							AND (@isEnd = 1)
							)
						OR (
							(@isNext = 0)
							AND (@isEnd = 0)
							)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
			ELSE
			BEGIN
				IF (
						(
							(@isNext = 1)
							AND (@isEnd = 1)
							)
						OR (
							(@isNext = 0)
							AND (@isEnd = 0)
							)
						)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''
		' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END
	
	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)'
		,@entity = @entity
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@orderBy = @orderBy
		,@where = @where
		,@orgId = @orgId
		,@userId = @userId
		,@groupBy = @groupBy
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH