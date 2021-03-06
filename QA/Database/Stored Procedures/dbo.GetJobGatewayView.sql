SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal        
-- Create date:               12/14/2019     
-- Description:               Get all Job Gateway
-- Execution:                 EXEC [dbo].[GetJobGatewayView]  
-- =============================================
CREATE PROCEDURE [dbo].[GetJobGatewayView] @userId BIGINT
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
	,@TotalCount INT OUTPUT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX)
		,@TCountQuery NVARCHAR(MAX)
		,@GatewayStatusArchive INT = 2234
		,@JobIDName VARCHAR(100)
		,@JobCompleted BIT

	SELECT @JobIDName = [JobSiteCode]
		,@JobCompleted = [JobCompleted]
	FROM JobDL000Master
	WHERE Id = @ParentId

	IF OBJECT_ID('tempdb..#CargoTemp') IS NOT NULL
		DROP TABLE #CargoTemp

	IF OBJECT_ID('tempdb..#GatewayTemp') IS NOT NULL
		DROP TABLE #GatewayTemp

	SELECT Id
		,CgoPartNumCode
	INTO #CargoTemp
	FROM dbo.[JOBDL010Cargo]
	WHERE JobId = @ParentId
		AND StatusId = 1

	CREATE TABLE #GatewayTemp (
		GatewayUnitId INT
		,GwyAddtionalComment NVARCHAR(Max)
		,GwyAttachments INT
		,GwyCargoId BIGINT
		,GwyCompleted BIT
		,GwyDateRefTypeId INT
		,GwyDDPCurrent DATETIME2
		,GwyDDPNew DATETIME2
		,GwyExceptionStatusId BIGINT
		,GwyExceptionTitleId BIGINT
		,GwyGatewayACD DATETIME2
		,GwyGatewayCode NVARCHAR(50)
		,GwyGatewayDuration DECIMAL(18, 2)
		,GwyGatewayPCD DATETIME2
		,GwyGatewaySortOrder INT
		,GwyGatewayTitle NVARCHAR(150)
		,GwyPreferredMethod INT
		,GwyShipApptmtReasonCode NVARCHAR(120)
		,GwyShipStatusReasonCode NVARCHAR(120)
		,Id BIGINT
		,Scanner BIT
		,StatusId INT
		,GwyClosedBy NVARCHAR(150)
		,GwyGatewayResponsible INT
		,GwyGatewayAnalyst INT
		,GatewayTypeId BIGINT
		,isActionAdded BIT
		,JobID BIGINT
		)

	INSERT INTO #GatewayTemp (
		GatewayUnitId
		,GwyAddtionalComment
		,GwyAttachments
		,GwyCargoId
		,GwyCompleted
		,GwyDateRefTypeId
		,GwyDDPCurrent
		,GwyDDPNew
		,GwyExceptionStatusId
		,GwyExceptionTitleId
		,GwyGatewayACD
		,GwyGatewayCode
		,GwyGatewayDuration
		,GwyGatewayPCD
		,GwyGatewaySortOrder
		,GwyGatewayTitle
		,GwyPreferredMethod
		,GwyShipApptmtReasonCode
		,GwyShipStatusReasonCode
		,Id
		,Scanner
		,StatusId
		,GwyClosedBy
		,GwyGatewayResponsible
		,GwyGatewayAnalyst
		,GatewayTypeId 
		,isActionAdded 
		,JobID
		)
	SELECT JobGateway.GatewayUnitId
		,JobGateway.GwyAddtionalComment
		,JobGateway.GwyAttachments
		,JobGateway.GwyCargoId
		,JobGateway.GwyCompleted
		,JobGateway.GwyDateRefTypeId
		,JobGateway.GwyDDPCurrent
		,JobGateway.GwyDDPNew
		,JobGateway.GwyExceptionStatusId
		,JobGateway.GwyExceptionTitleId
		,JobGateway.GwyGatewayACD
		,JobGateway.GwyGatewayCode
		,JobGateway.GwyGatewayDuration
		,JobGateway.GwyGatewayPCD
		,JobGateway.GwyGatewaySortOrder
		,JobGateway.GwyGatewayTitle
		,JobGateway.GwyPreferredMethod
		,JobGateway.GwyShipApptmtReasonCode
		,JobGateway.GwyShipStatusReasonCode
		,JobGateway.Id
		,JobGateway.Scanner
		,JobGateway.StatusId
		,JobGateway.GwyClosedBy
		,GwyGatewayResponsible
		,GwyGatewayAnalyst
		,JobGateway.GatewayTypeId 
		,JobGateway.isActionAdded 
		,JobGateway.JobId
	FROM [dbo].[JOBDL020Gateways] JobGateway
	WHERE JobId = @ParentId

	IF @parentId = 0
	BEGIN
		DECLARE @prgGatewayTable TABLE (
			[Id] BIGINT IDENTITY(1, 1) NOT NULL
			,[JobID] BIGINT NULL
			,[ProgramID] BIGINT NULL
			,[GwyGatewaySortOrder] INT NULL
			,[GwyGatewayCode] NVARCHAR(20) NULL
			,[GwyGatewayTitle] NVARCHAR(50) NULL
			,[GwyGatewayDuration] DECIMAL(18, 2) NULL
			,[GatewayUnitId] INT NULL
			,[GwyGatewayDefault] BIT NULL
			,[GatewayTypeId] INT NULL
			,[GwyDateRefTypeId] INT NULL
			,[StatusId] INT NULL
			)
	END
	ELSE
	BEGIN
		SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM #GatewayTemp  ' + @entity
		SET @TCountQuery = @TCountQuery + ' WHERE StatusId <> ' + CONVERT(NVARCHAR(20), @GatewayStatusArchive) + ISNULL(@where, '')

		EXEC sp_executesql @TCountQuery
			,N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT'
			,@parentId
			,@userId
			,@TotalCount OUTPUT;

		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
			SET @sqlCommand = @sqlCommand + ' ,' + '''' + ISNULL(@JobIDName,'') + '''' + ' JobIDName , CASE WHEN cont.Id > 0 OR ' + @entity + '.GwyClosedBy IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist, ' + 'CAST(' + CAST(@JobCompleted AS VARCHAR) + ' AS BIT) ' + ' JobCompleted'
			SET @sqlCommand = @sqlCommand + '  , respContact.[ConFullName] AS GwyGatewayResponsibleName ,  anaContact.[ConFullName] AS GwyGatewayAnalystName '
			SET @sqlCommand = @sqlCommand + '  , installstatusMaster.ExStatusDescription AS GwyExceptionStatusIdName, exceptionReason.JgeTitle AS GwyExceptionTitleIdName,jobCargo.CgoPartNumCode AS GwyCargoIdName '
		END
		ELSE
		BEGIN
			IF (
					(@isNext = 0)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '
			END
			ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
		END

		SET @sqlCommand = @sqlCommand + ' FROM #GatewayTemp ' + @entity
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN CONTC000Master cont ON ' + @entity + '.GwyClosedBy = cont.ConFullName AND cont.StatusId  =1 '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[GwyGatewayResponsible]=respContact.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[GwyGatewayAnalyst]=anaContact.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK) installstatusMaster ON ' + @entity + '.[GwyExceptionStatusId]=installstatusMaster.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL022GatewayExceptionReason] (NOLOCK) exceptionReason ON ' + @entity + '.[GwyExceptionTitleId]=exceptionReason.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN #CargoTemp jobCargo ON ' + @entity + '.[GwyCargoId]=jobCargo.[Id] '

		--Below to update order by clause if related to Ref_Options
		--IF (ISNULL(@orderBy, '') <> '')
		--BEGIN
		--	DECLARE @orderByJoinClause NVARCHAR(500);

		--	SELECT @orderBy = OrderClause
		--		,@orderByJoinClause = JoinClause
		--	FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);

		--	IF (ISNULL(@orderByJoinClause, '') <> '')
		--	BEGIN
		--		SET @sqlCommand = @sqlCommand + @orderByJoinClause
		--	END
		--END

		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.StatusId <> ' + CONVERT(NVARCHAR(20), @GatewayStatusArchive) + ISNULL(@where, '')

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
				IF (ISNULL(@orderBy, '') <> '')
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
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
				IF (ISNULL(@orderBy, '') <> '')
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id >= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + ISNULL(@orderBy, @entity + '.Id')

		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
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

		EXEC sp_executesql @sqlCommand
			,N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@JobIDName Varchar(100),@JobCompleted BIT'
			,@entity = @entity
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@orderBy = @orderBy
			,@where = @where
			,@parentId = @parentId
			,@userId = @userId
			,@JobIDName = @JobIDName
			,@JobCompleted = @JobCompleted
	END

	DROP TABLE #GatewayTemp

	DROP TABLE #CargoTemp
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
