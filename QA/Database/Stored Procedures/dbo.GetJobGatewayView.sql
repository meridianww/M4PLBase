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
ALTER PROCEDURE [dbo].[GetJobGatewayView] @userId BIGINT
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
		,@GatewayStatusArchive INT = 0;

	SET @GatewayStatusArchive = (
			SELECT Id
			FROM SYSTM000Ref_Options
			WHERE SysLookupCode = 'GatewayStatus'
				AND SysOptionName = 'Archive'
			)

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
		SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL020Gateways] (NOLOCK) ' + @entity		
		SET @TCountQuery = @TCountQuery + ' WHERE StatusId <> ' + CONVERT(NVARCHAR(20), @GatewayStatusArchive) + ' AND [JobID] = @parentId AND PROGRAMID IS NOT NULL ' + ISNULL(@where, '')		
		EXEC sp_executesql @TCountQuery
			,N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT'
			,@parentId
			,@userId
			,@TotalCount OUTPUT;

		IF (@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
			SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName, prg.[PrgProgramTitle] AS ProgramIDName , CASE WHEN cont.Id > 0 OR ' + @entity + '.GwyClosedBy IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist, job.[JobCompleted] AS JobCompleted'
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

		SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM000Master] (NOLOCK) prg '
		--Below to get BIGINT reference key name by Id if NOT NULL
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON job.[ProgramID]=prg.[Id] '
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL020Gateways] (NOLOCK) ' + @entity + ' ON ' + @entity + '.[ProgramID]=prg.[Id] AND ' + @entity + '.[ProgramID]=job.[ProgramID] AND ' + @entity + '.[JobId]=job.[Id]';
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN CONTC000Master cont ON ' + @entity + '.GwyClosedBy = cont.ConFullName AND cont.StatusId  =1 '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[GwyGatewayResponsible]=respContact.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[GwyGatewayAnalyst]=anaContact.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL023GatewayInstallStatusMaster] (NOLOCK) installstatusMaster ON ' + @entity + '.[GwyExceptionStatusId]=installstatusMaster.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL022GatewayExceptionReason] (NOLOCK) exceptionReason ON ' + @entity + '.[GwyExceptionTitleId]=exceptionReason.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL010Cargo] (NOLOCK) jobCargo ON ' + @entity + '.[GwyCargoId]=jobCargo.[Id] '
		--Below to update order by clause if related to Ref_Options
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

		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.StatusId <> ' + CONVERT(NVARCHAR(20), @GatewayStatusArchive) + ' AND ' + @entity + '.[JobID]=@parentId ' + ISNULL(@where, '')

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
			,N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT'
			,@entity = @entity
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@orderBy = @orderBy
			,@where = @where
			,@parentId = @parentId
			,@userId = @userId
	END
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
