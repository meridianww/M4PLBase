ALTER PROCEDURE [dbo].[GetOSDReportView] @userId BIGINT
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
		,@GatewayTypeId INT = 0
		,@GatewayActionTypeId INT = 0
		,@GatewayStatus NVARCHAR(MAX) = NULL
		IF(@gatewayTitles IS NOT NULL AND @gatewayTitles <> '')
		BEGIN
		  SET @GatewayStatus = REPLACE(@gatewayTitles, ' GWY.GwyGatewayCode ', ' JobAdvanceReport.JobGatewayStatus ');
		END
	DECLARE @AdvanceFilter NVARCHAR(MAX) = ''
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
	-----------------------------------------Temporary Tables starts

SELECT JC.JobID
,JC.Id
,JC.CgoTitle
	,JC.CgoPartNumCode
	,JC.CgoQtyDamaged
	,JC.CgoQtyOver
	,JC.CgoQtyShortOver
	,JC.CgoCubes 
	,JC.CgoWeight 
	,JC.CgoPackagingTypeId
	,JC.StatusId
	INTO #CargoTemp
	FROM JOBDL010Cargo JC
	WHERE JC.StatusId = 1
		AND (
		JC.CgoQtyDamaged <> 0
		OR  JC.CgoQtyShortOver  <> 0
		OR  JC.CgoQtyOver  <> 0
		)

SELECT 
	JobAdvanceReport.Id
	,JobAdvanceReport.JobBOL
	,JobAdvanceReport.JobCarrierContract
	,JobAdvanceReport.JobCustomerPurchaseOrder
	,JobAdvanceReport.JobCustomerSalesOrder
	,JobAdvanceReport.JobDeliveryCity
	,JobAdvanceReport.JobDeliveryDateTimeActual
	,JobAdvanceReport.JobDeliveryDateTimePlanned
	,JobAdvanceReport.JobDeliveryPostalCode
	,JobAdvanceReport.JobDeliverySiteName
	,JobAdvanceReport.JobDeliverySitePOC
	,JobAdvanceReport.JobDeliverySitePOCEmail
	,JobAdvanceReport.JobDeliverySitePOCPhone
	,JobAdvanceReport.JobDeliverySitePOCPhone2
	,JobAdvanceReport.JobDeliveryState
	,JobAdvanceReport.JobDeliveryStreetAddress
	,JobAdvanceReport.JobDeliveryStreetAddress2
	,JobAdvanceReport.JobGatewayStatus
	,JobAdvanceReport.JobMileage
	,JobAdvanceReport.JobOrderedDate
	,JobAdvanceReport.JobOriginDateTimeActual
	,JobAdvanceReport.JobOriginDateTimePlanned
	,JobAdvanceReport.JobSellerSiteName
	,JobAdvanceReport.JobSellerSitePOCEmail
	,JobAdvanceReport.JobServiceMode
	,JobAdvanceReport.JobSiteCode
	,JobAdvanceReport.PlantIDCode
	,JobAdvanceReport.StatusId
	,JobAdvanceReport.JobProductType 
	,JobAdvanceReport.JobChannel 
	,JobAdvanceReport.DateEntered
	,ProgramID
	INTO #JobTemp
	FROM JOBDL000Master JobAdvanceReport
	WHERE JobAdvanceReport.JobSiteCode IS NOT NULL
	AND JobAdvanceReport.JobSiteCode <> ''


-----------------------------------------Temporary Tables ends
	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

	SELECT @GatewayActionTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

	SET @TablesQuery = ' FROM CUST000Master CUST ' + ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id AND CUST.StatusId = 1 AND PRG.StatusId = 1 ' 
	+ ' INNER JOIN #JobTemp ' + @entity + ' ON ' + @entity + '.ProgramID = PRG.Id '
	IF(@JobStatusId >0 )
	BEGIN
		SET @TablesQuery += 'AND JobAdvanceReport.StatusId = ' + CONVERT(NVARCHAR(10), @JobStatusId)
	END
	--------------------- Security Start----------------------------------------------------------
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityIdTemp
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

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
	SET @TablesQuery = @TablesQuery + ' INNER JOIN #CargoTemp JC ON JC.JobID = ' + @entity + '.Id AND JC.StatusId = 1'-- AND (ISNULL(JC.CgoQtyDamaged,0)>0 OR ISNULL(JC.CgoQtyShortOver,0)>0 OR ISNULL(JC.CgoQtyOver,0)>0)'
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

	IF (
			(
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
			OR (
				ISNULL(@DateType, '') <> ''
				AND ISNULL(@DateType, '') <> 'ALL'
				)
			OR (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
			OR (
				ISNULL(@scheduled, '') <> ''
				AND ISNULL(@scheduled, '') <> 'ALL'
				)
			)
	BEGIN
		DECLARE @condition NVARCHAR(500) = '';
		DECLARE @GatewayCommand NVARCHAR(500);

		SET @GatewayCommand = 'SELECT DISTINCT GWY.JobID from  JOBDL020Gateways GWY  (NOLOCK) WHERE (1=1) ' + ' AND GWY.Id IN (SELECT MAX(Id) LatestGatewayId FROM JOBDL020Gateways WHERE GwyCompleted = 1 '

		IF (
				(
					ISNULL(@gatewayTitles, '') <> ''
					AND ISNULL(@gatewayTitles, '') <> 'ALL'
					)
				OR (
					ISNULL(@orderType, '') <> ''
					AND ISNULL(@orderType, '') <> 'ALL'
					)
				)
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND GatewayTypeId = ' + CONVERT(VARCHAR, @GatewayTypeId)
		END

		IF (ISNULL(@scheduled, '') = 'Not Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId NOT IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + CONVERT(VARCHAR, @GatewayActionTypeId) + ')  AND JobId IS NOT NULL '
		END
		ELSE IF (ISNULL(@scheduled, '') = 'Scheduled')
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND JobId IN (SELECT DISTINCT JobId FROM JOBDL020Gateways WHERE GatewayTypeId= ' + CONVERT(VARCHAR, @GatewayActionTypeId) + ')  AND JobId IS NOT NULL'
		END

		SET @GatewayCommand = @GatewayCommand + ' GROUP BY JobID ) AND GWY.GwyCompleted = 1 '

		IF (ISNULL(@DateType, '') <> '')
		BEGIN
			SET @GatewayCommand = 'SELECT DISTINCT GWY.JobID from  JOBDL020Gateways GWY  (NOLOCK) WHERE (1=1) '
			SET @GatewayCommand += @DateType
		END

		IF (
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
		BEGIN
			SET @GatewayCommand = @GatewayCommand + ' AND GWY.GwyOrderType = ''' + @orderType + ''''
		END

		IF (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
		BEGIN
			SET @condition = ' ' + @gatewayTitles
		END

		SET @GatewayCommand = @GatewayCommand + @condition

		IF OBJECT_ID('tempdb..#JOBDLGateways') IS NOT NULL
		BEGIN
			DROP TABLE #JOBDLGateways
		END

		CREATE TABLE #JOBDLGateways (JobID BIGINT)

		INSERT INTO #JOBDLGateways
		EXEC sp_executesql @GatewayCommand

		CREATE NONCLUSTERED INDEX ix_tempJobIndexAft ON #JOBDLGateways ([JobID]);

		SET @TablesQuery = @TablesQuery + ' INNER JOIN #JOBDLGateways GWY ON GWY.JobID=JobAdvanceReport.[Id] '
	END

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) ' + @TablesQuery
	SET @where=@where+' AND (ISNULL(JC.CgoQtyDamaged,0)<>0 OR ISNULL(JC.CgoQtyShortOver,0)<>0 OR ISNULL(JC.CgoQtyOver,0)<>0)'
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
	--EXEC sp_executesql @TCountQuery
	--	,N'@userId BIGINT, @TotalCount INT OUTPUT'
	--	,@userId
	--	,@TotalCount OUTPUT;

	IF (
			(ISNULL(@groupBy, '') = '')
			OR (@recordId > 0)
			)
	BEGIN
		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetJobReportBaseQuery](@entity, @userId, @reportTypeId)
			SET @sqlCommand=REPLACE(@sqlCommand, 'JobAdvanceReport.CgoQtyDamaged', 'ISNULL(JC.CgoQtyDamaged,0) CgoQtyDamaged');
			SET @sqlCommand=REPLACE(@sqlCommand, 'JobAdvanceReport.CgoQtyOver', 'ISNULL(JC.CgoQtyOver,0) CgoQtyOver');
			SET @sqlCommand=REPLACE(@sqlCommand, 'JobAdvanceReport.CgoQtyShortOver', 'ISNULL(JC.CgoQtyShortOver,0) CgoQtyShortOver');
			SET @sqlCommand=@sqlCommand+' ,TotalRows = COUNT(*) OVER()'
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
		IF(ISNULL(@GatewayStatus, '') <> '')
		BEGIN 
		   SET @sqlCommand += @GatewayStatus
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
	PRINT @sqlCommand
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
		--select @sqlCommand
	IF (
			(
				ISNULL(@orderType, '') <> ''
				AND ISNULL(@orderType, '') <> 'ALL'
				)
			OR (
				ISNULL(@DateType, '') <> ''
				AND ISNULL(@DateType, '') <> 'ALL'
				)
			OR (
				ISNULL(@gatewayTitles, '') <> ''
				AND ISNULL(@gatewayTitles, '') <> 'ALL'
				)
			OR (
				ISNULL(@scheduled, '') <> ''
				AND ISNULL(@scheduled, '') <> 'ALL'
				)
			)
	BEGIN
		DROP TABLE #JOBDLGateways
	END
	DROP TABLE #CargoTemp
	DROP TABLE #JobTemp
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


