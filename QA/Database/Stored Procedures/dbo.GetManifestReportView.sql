SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               08/18/2020      
-- Description:               Get Manifest Report Data  
-- =============================================
ALTER PROCEDURE [dbo].[GetManifestReportView] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@groupBy NVARCHAR(500)
	,@groupByWhere NVARCHAR(500)
	,@where NVARCHAR(MAX)
	,@parentId BIGINT
	,@isNext BIT
	,@isEnd BIT
	,@recordId BIGINT
	,@IsExport BIT = 0
	,@scheduled NVARCHAR(500) = ''
	,@orderType NVARCHAR(500) = ''
	,@DateType NVARCHAR(500) = ''
	,@JobStatus NVARCHAR(100) = NULL
	,@SearchText NVARCHAR(300) = ''
	,@gatewayTitles NVARCHAR(800) = ''
	,@PackagingCode NVARCHAR(50) = ''
	,@CargoId BIGINT = NULL
	,@reportTypeId INT = NULL
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX)
		   ,@TCountQuery NVARCHAR(MAX)
		   ,@TablesQuery NVARCHAR(MAX)
		   ,@AdvanceFilter NVARCHAR(MAX) = ''
		   ,@JobStatusId INT = 0;

	IF (@JobStatus = 'Active')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Active'
				);
	END
	ELSE IF (@JobStatus = 'Inactive')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Inactive'
				);
	END
	ELSE IF (@JobStatus = 'Archive')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Archive'
				);
	END
	ELSE IF (@JobStatus = 'Canceled')
	BEGIN
		SET @JobStatusId = (
				SELECT Id
				FROM SYSTM000Ref_Options
				WHERE SysLookupCode = 'Status'
					AND SysOptionName = 'Canceled'
				);
	END
	
	SET @TablesQuery = ' FROM CUST000Master CUST ' + ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id AND CUST.StatusId = 1 AND PRG.StatusId = 1 ' 
	+ ' INNER JOIN JOBDL000Master ' + @entity + ' ON ' + @entity + '.ProgramID = PRG.Id '
	IF(@JobStatusId >0 )
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR(10), @JobStatusId)
	END
	IF ((ISNULL(@orderType, '') <> '' AND ISNULL(@orderType, '') <> 'ALL'))
	BEGIN
	   SET @TablesQuery += ' AND JobAdvanceReport.JobType = ''' + @orderType +''''
	END		
	IF (ISNULL(@scheduled, '') = 'Not Scheduled')
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.JobIsSchedule = 0'  
	END
	ELSE IF (ISNULL(@scheduled, '') = 'Scheduled')
	BEGIN
		SET @TablesQuery += ' AND JobAdvanceReport.JobIsSchedule = 1'  
	END
	IF(ISNULL(@gatewayTitles, '') <> '' AND ISNULL(@gatewayTitles, '') <> 'ALL')
	BEGIN 
	  DECLARE @Titles NVARCHAR(500) = '';
	  CREATE TABLE #TEMP (TypeId INT);
	  SET @Titles += 'INSERT INTO #TEMP(TypeId) SELECT DISTINCT GatewayTypeId FROM JOBDL020Gateways
	  WHERE StatusId IN (194,195) AND GwyGatewayCode IN '
	  + @gatewayTitles + ' OR GwyGatewayTitle IN ' + @gatewayTitles +'';
	  EXEC sp_executesql @Titles;  
	  IF (((SELECT COUNT(TypeId) FROM #TEMP) = 1) AND ((SELECT COUNT(TypeId) FROM #TEMP WHERE TypeId =85) = 1))
	  BEGIN
	     SET @TablesQuery += 'AND  JobAdvanceReport.JobGatewayStatus IN ' + @gatewayTitles +''
	  END
	  ELSE IF (((SELECT COUNT(TypeId) FROM #TEMP) = 1) AND ((SELECT COUNT(TypeId) FROM #TEMP WHERE TypeId =86) = 1))
	  BEGIN
		    SET @TablesQuery = @TablesQuery + ' INNER JOIN [vwJobGateways] gateway ON  gateway.JobId = ' + @entity +
			'.[Id] AND gateway.StatusId IN (194,195) AND gateway.GatewayTypeId = 86 AND gateway.GwyGatewayTitle IN ' 
			+ @gatewayTitles +''	     
	  END
	  ELSE
	  BEGIN
	       SET @TablesQuery = @TablesQuery + ' INNER JOIN vwJobGateways gateway ON  gateway.JobId = '+ @entity + '.[Id] 
		   AND gateway.StatusId IN (194,195) AND (gateway.GwyGatewayTitle IN ' + @gatewayTitles +' OR gateway.GwyGatewayCode 
		   IN '+ @gatewayTitles +') AND ' + @entity + '.JobGatewayStatus =''
		   (SELECT TOP 1 GwyGatewayCode FROM JOBDL020Gateways WHERE GatewayTypeId=85 ORDER BY ID DESC) '''
	  END	   
	  DROP TABLE #TEMP
	END
	
	--------------------- Security Start----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
	    DROP INDEX [IDX_#EntityIdTemp_EntityId] ON #EntityIdTemp
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)
	CREATE NONCLUSTERED INDEX [IDX_#EntityIdTemp_EntityId]
	ON #EntityIdTemp (EntityId)

	INSERT INTO #EntityIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Job'

	IF EXISTS (
			SELECT 1
			FROM #EntityIdTemp
			WHERE ISNULL(EntityId, 0) = - 1
			)
	BEGIN
		SET @IsJobAdmin = 1
	END
	ELSE
	BEGIN
		SET @TablesQuery = @TablesQuery + ' INNER JOIN #EntityIdTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
	END

	------------------------------- Security End---------------------------------------
	SET @TablesQuery = @TablesQuery + ' INNER JOIN JOBDL010Cargo JC ON JC.JobID = ' + @entity + '.Id AND JC.StatusId = 1'
	SET @TablesQuery = @TablesQuery + ' LEFT JOIN SYSTM000Ref_Options SO ON JC.CgoPackagingTypeId = SO.Id '
	 
	IF (
			ISNULL(@PackagingCode, '') <> ''
			AND ISNULL(@PackagingCode, '') <> 'ALL'
			)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' INNER JOIN SYSTM000Ref_Options SOC ON JC.CgoPackagingTypeId = SOC.Id '
		SET @TablesQuery = @TablesQuery + ' AND SOC.SysOptionName = ''' + @PackagingCode + '''';
	END
	ELSE IF (ISNULL(@CargoId, 0) > 0)
	BEGIN
		SET @TablesQuery = @TablesQuery + ' AND JC.Id = ' + CONVERT(NVARCHAR(10), @CargoId)
	END
	
	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) ' + @TablesQuery

	IF (ISNULL(@where, '') <> '')
	BEGIN
		SET @where = REPLACE(@where, 'JobAdvanceReport.CargoTitle', 'JC.CgoTitle');
		SET @where = REPLACE(@where, 'JobAdvanceReport.CgoPartCode', 'JC.CgoPartNumCode');
		SET @where = REPLACE(@where, 'JobAdvanceReport.PackagingCode', 'SO.ID');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobTotalWeight', 'JC.CgoWeight');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobTotalCubes', 'JC.CgoCubes');
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobServiceActual', 'CASE WHEN SO.SysOptionName = ''Service'' THEN 1 ELSE 0 END')
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobPartsActual', 'CASE WHEN SO.SysOptionName = ''Accessory'' THEN 1 ELSE 0 END')
		SET @where = REPLACE(@where, 'JobAdvanceReport.JobQtyActual', 'CASE WHEN SO.SysOptionName = ''Appliance'' THEN 1 ELSE 0 END')
		SET @TCountQuery = @TCountQuery + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @where
	END
	
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
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
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

		----------------   
		-------------------------
		
		SET @sqlCommand = @sqlCommand + ' ,' + @entity + '.JobPartsActual TotalParts, ' + @entity + '.JobQtyActual TotalQuantity, ' + @entity + '.JobProductType ProductType, ' + @entity + '.JobChannel Channel,' + @entity + '.JobTotalWeight '
		SET @sqlCommand = @sqlCommand + ' ,JobAdvanceReport.DateEntered,prg.PrgCustID CustomerId '
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CargoTitle', 'JC.CgoTitle CargoTitle');
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CgoPartCode', 'JC.CgoPartNumCode CgoPartCode');
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.PackagingCode', 'SO.ID PackagingCode');
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobTotalCubes', 'JC.CgoCubes JobTotalCubes')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobTotalWeight', 'JC.CgoWeight JobTotalWeight')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobServiceActual', 'CASE WHEN SO.SysOptionName = ''Service'' THEN 1 ELSE 0 END JobServiceActual')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobPartsActual TotalParts', 'CASE WHEN SO.SysOptionName = ''Accessory'' THEN 1 ELSE 0 END TotalParts')
		SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.JobQtyActual TotalQuantity', 'CASE WHEN SO.SysOptionName = ''Appliance'' THEN 1 ELSE 0 END TotalQuantity')
		SET @sqlCommand = @sqlCommand + ', CAST(1 AS BIT) IsIdentityVisible ';
		SET @sqlCommand += @TablesQuery

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
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
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
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
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
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) AND  ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> ''''' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy

		IF (ISNULL(@orderBy, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @orderBy
		END
	END

	
	SET @sqlCommand = REPLACE(@sqlCommand, 'JobAdvanceReport.CustTitle', 'Cust.CustTitle');
	SET @where = REPLACE(@where, 'JobAdvanceReport.CustTitle', 'Cust.CustTitle');

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

