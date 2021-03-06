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
	,@PacifficTime DATETIME = NULL
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;
	SET @entity = 'JOBDL000Master';
	SET @orderBy = REPLACE(@orderBy, 'JobCard', 'JOBDL000Master')
	SET @where = REPLACE(@where, 'JobCard', 'JOBDL000Master')
	SET @where = REPLACE(@where,'CUST000Master.[Id]','JOBDL000Master.PrgCustId')
	DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@CustomQuery NVARCHAR(MAX)
		,@GatewayIsScheduleQuery NVARCHAR(MAX) = ''
		,@DashBoardCatagory NVARCHAR(50) = ''
		,@DashBoardSubCatagory NVARCHAR(50) = ''
		,@xCblQuery NVARCHAR(MAX) = '';

	SELECT @DashBoardSubCatagory = DSC.DashboardSubCategoryName
		,@DashBoardCatagory = DC.DashboardCategoryName
		,@CustomQuery = DCR.CustomQuery
	FROM DashboardCategoryRelation DCR
	INNER JOIN DashboardCategory DC ON DCR.DashboardCategoryId = DC.DashboardCategoryId
	INNER JOIN DashboardSubCategory DSC ON DCR.DashboardSubCategory = DSC.DashboardSubCategoryId
	WHERE DCR.DashboardCategoryRelationId = @dashCategoryRelationId

	--------------------- Security ----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

	CREATE NONCLUSTERED INDEX IX_EntityIdTemp_EntityId ON #EntityIdTemp (EntityId)

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
	END

	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Job' --@entity

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
		--SELECT TOP 1 @CustomQuery = DCR.CustomQuery
		--FROM DashboardCategoryRelation DCR
		--INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
		--INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
		--INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory
		--WHERE DCR.DashboardCategoryRelationId = @dashCategoryRelationId

		IF (
				@DashBoardCatagory = 'NotScheduled'
				AND (@DashBoardSubCatagory <> 'Returns')
				)
		BEGIN
			SET @GatewayIsScheduleQuery = @GatewayIsScheduleQuery + ' AND ( ' + @entity + '.JobIsSchedule = 0 OR ' + @entity + '.JobIsSchedule IS NULL) '
		END
		ELSE IF (
				(
					@DashBoardCatagory = 'SchedulePastDue'
					OR @DashBoardCatagory = 'ScheduledForToday'
					)
				AND (@DashBoardSubCatagory <> 'Returns')
				)
		BEGIN
			SET @GatewayIsScheduleQuery = @GatewayIsScheduleQuery + ' AND ' + @entity + '.JobIsSchedule = 1 '
		END
		ELSE IF (@DashBoardCatagory = 'xCBL')
		BEGIN
			SET @xCblQuery = ' INNER JOIN JOBDL020Gateways ON JOBDL020Gateways.JOBID =JOBDL000Master.ID 
		  AND ISNULL(JOBDL020Gateways.ProgramId,0) = JOBDL000Master.ProgramId
		  AND JOBDL000Master.StatusId=1 AND JOBDL020Gateways.GatewayTypeId = 86
		  AND JOBDL020Gateways.GwyGatewayCode like ''XCBL%''
		  INNER JOIN  SYSTM000Ref_Options ON SYSTM000Ref_Options.Id = JOBDL020Gateways.StatusId 
		  AND SYSTM000Ref_Options.SysOptionName in (''Active'',''Completed'') '
		END
	END

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(DISTINCT JOBDL000Master.Id) FROM vwJobMasterData (NOEXPAND)  JOBDL000Master '

	IF (ISNULL(@IsJobAdmin, 0) = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
	END

	--------------------------end-----------------------------------------------------
	IF (ISNULL(@CustomQuery, '') <> '')
	BEGIN
		SET @where = @where + @CustomQuery;
	END

	IF (
			ISNULL(@xCblQuery, '') <> ''
			AND @DashBoardCatagory = 'xCBL'
			)
	BEGIN
		SET @TCountQuery = @TCountQuery + @xCblQuery
	END

	SET @TCountQuery = @TCountQuery + ' WHERE (1=1) AND ISNULL(' + @entity + '.JobSiteCode,'''') <> ''''' + @GatewayIsScheduleQuery + @where
	--Print @TCountQuery
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
				 JOBDL000Master.JobDeliverySitePOCPhone2, JOBDL000Master.JobDeliveryState, JOBDL000Master.JobDeliveryStreetAddress, JOBDL000Master.JobDeliveryStreetAddress2, 
				 JOBDL000Master.JobGatewayStatus, JOBDL000Master.JobMITJobID, JOBDL000Master.JobOrderedDate, JOBDL000Master.JobOriginDateTimeActual, JOBDL000Master.JobOriginDateTimePlanned, 
				 JOBDL000Master.JobDeliverySiteName, JOBDL000Master.JobDeliverySitePOC, JOBDL000Master.JobDeliverySitePOCEmail, JOBDL000Master.JobDeliverySitePOCPhone, 
				 JOBDL000Master.JobPartsActual, JOBDL000Master.JobQtyActual, JOBDL000Master.JobSellerSiteName, JOBDL000Master.JobServiceMode, JOBDL000Master.JobSiteCode, JOBDL000Master.JobTotalCubes,
				 JOBDL000Master.PlantIDCode, JOBDL000Master.StatusId, JOBDL000Master.ShipmentType ,JOBDL000Master.JobType, JOBDL000Master.JobIsSchedule'

			--SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobPartsActual', 'CASE WHEN ISNULL(JOBDL000Master.JobPartsActual, 0) > 0 THEN CAST(JOBDL000Master.JobPartsActual AS INT)  ELSE NULL END JobPartsActual');
			--SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobQtyActual', 'CASE WHEN ISNULL(JOBDL000Master.JobQtyActual, 0) > 0 THEN CAST(JOBDL000Master.JobQtyActual AS INT) ELSE NULL END JobQtyActual');
			--SELECT @QueryData = REPLACE(@QueryData, 'JOBDL000Master.JobPartsOrdered', 'CAST(JOBDL000Master.JobPartsOrdered AS INT) JobPartsOrdered');
			SELECT @QueryData = @QueryData + CASE 
					WHEN ISNULL(@ColorCode, '') <> ''
						THEN CONCAT (
								' ,'''
								,@ColorCode + ''' AS JobColorCode '
								)
					WHEN ISNULL(@ColorCode, '') = 'NA'
						THEN ' ,NULL AS JobColorCode '
					ELSE ', CASE WHEN ISNULL(JOBDL000Master.JobOriginDateTimePlanned , '''') = ''''
			        THEN NULL WHEN  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) <= CONVERT(date, DATEADD(DAY, 2, ''' + CAST(@PacifficTime AS VARCHAR) + ''')) THEN ''#FF0000''
			                  WHEN  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) > CONVERT(date,DATEADD(DAY, 2, ''' + CAST(@PacifficTime AS VARCHAR) + ''')) 
									AND  CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) <= CONVERT(date, DATEADD(DAY, 5, ''' + CAST(@PacifficTime AS VARCHAR) + ''')) THEN ''#FFFF00''
							  WHEN CONVERT(date, JOBDL000Master.JobOriginDateTimePlanned) > CONVERT(date, DATEADD(DAY,5, ''' + CAST(@PacifficTime AS VARCHAR) + ''')) THEN ''#008000'' 
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

		SET @sqlCommand = @sqlCommand + ' ,JOBDL000Master.CustomerTitle '
		--SET @sqlCommand = @sqlCommand + ' INNER JOIN PRGRM000Master (NOLOCK) ON  PRGRM000Master.[PrgCustID] = CUST000Master.[Id]'
		SET @sqlCommand = @sqlCommand + ' From vwJobMasterData (NOEXPAND) ' + @entity 

		------------------------------------
		IF (ISNULL(@IsJobAdmin, 0) = 0)
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdTemp ON ' + @entity + '.[Id] = #EntityIdTemp.[EntityId] '
		END

		IF (
				ISNULL(@xCblQuery, '') <> ''
				AND @DashBoardCatagory = 'xCBL'
				)
		BEGIN
			SET @sqlCommand = @sqlCommand + @xCblQuery
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
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND ISNULL(' + @entity + '.JobSiteCode,'''') <> ''''' + @GatewayIsScheduleQuery + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
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
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) AND ISNULL(' + @entity + '.JobSiteCode,'''') <> '''' AND ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
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
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(DISTINCT ' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND ISNULL(' + @entity + '.JobSiteCode,'''') <> ''''' + @GatewayIsScheduleQuery + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END

	--Print @sqlCommand
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
GO
