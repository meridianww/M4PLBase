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
ALTER PROCEDURE [dbo].[GetJobCardView]
	@userId BIGINT
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
	,@TotalCount INT OUTPUT	
AS
BEGIN TRY 
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @TCountQuery NVARCHAR(MAX);
	DECLARE @CustomQuery NVARCHAR(500);

	SET @dashCategoryRelationId = ISNULL(@dashCategoryRelationId, 0);
	SET @where =  ISNULL(@where, '') ;
	DECLARE @Daterange NVARCHAR(500)

	DECLARE @GatewayActionType INT
	SELECT @GatewayActionType = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType' AND SysOptionName = 'Action'

	Declare @JobStatusId bigint;	     
    SELECT @JobStatusId = Id from SYSTM000Ref_Options where SysLookupCode = 'Status' AND SysOptionName = 'Active' AND Id IS NOT NULL
	SET @where = ' AND JobCard.StatusId = '+ CONVERT(nvarchar,@JobStatusId) +' ';		

	IF (@dashCategoryRelationId >0)
	BEGIN
		  SELECT TOP 1 @CustomQuery = DCR.CustomQuery
		FROM DashboardCategoryRelation DCR
		INNER JOIN dbo.Dashboard D ON D.DashboardId = DCR.DashboardId
		INNER JOIN dbo.DashboardCategory DC ON DC.DashboardCategoryId = DCR.DashboardCategoryId
		INNER JOIN dbo.DashboardSubCategory DSC ON DSC.DashboardSubCategoryId = DCR.DashboardSubCategory WHERE DCR.DashboardCategoryRelationId = @dashCategoryRelationId
	END

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(DISTINCT JobCard.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) JobCard INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]=JobCard.[ProgramID] '
	+' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]   '
	
	IF OBJECT_ID('tempdb..#JOBDLGateways') IS NOT NULL 
	BEGIN 
		DROP TABLE #JOBDLGateways 
	END		
	CREATE TABLE #JOBGateways (JobID BIGINT)
	CREATE NONCLUSTERED INDEX ix_tempJobIdJOBGateways ON #JOBGateways ([JobID]);
	Declare @GatewayCommand NVARCHAR(800);
	Declare @condition NVARCHAR(500);
	SET @GatewayCommand = 'SELECT DISTINCT Gateway.JobID from  vwJobGateways Gateway  WHERE Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  AND '
	

	IF (ISNULL(@CustomQuery, '') <> '') 
	BEGIN	
		SET @CustomQuery =  REPLACE(@CustomQuery, '@GatewayActionType', @GatewayActionType);
		PRINT @CustomQuery
		SET @GatewayCommand = @GatewayCommand + @CustomQuery;		
		print @GatewayCommand
		INSERT INTO #JOBGateways		
		EXEC sp_executesql @GatewayCommand
		SET @TCountQuery  =  @TCountQuery + ' INNER JOIN #JOBGateways JWY ON JWY.JobID=JobCard.[Id] '	
		
	END

    IF(ISNULL(@where, '') <> '')
	BEGIN
		SET @TCountQuery = @TCountQuery + ' '+@where
		print @TCountQuery
	END	
	
	EXEC sp_executesql @TCountQuery
		,N'@userId BIGINT, @TotalCount INT OUTPUT'
		,@userId
		,@TotalCount OUTPUT;

	IF ((ISNULL(@groupBy, '') = '')OR (@recordId > 0))
	BEGIN
		IF (@recordId = 0)
		BEGIN
			Declare @QueryData Varchar(Max)
			Select @QueryData = [dbo].[fnGetGridBaseQueryByUserId](@entity, @userId)
			SELECT @QueryData = REPLACE(@QueryData, 'JobCard.JobPartsActual', 'CASE WHEN ISNULL(JobCard.JobPartsActual, 0) > 0 THEN CAST(JobCard.JobPartsActual AS INT)  ELSE NULL END JobPartsActual');
            SELECT @QueryData =  REPLACE(@QueryData, 'JobCard.JobQtyActual', 'CASE WHEN ISNULL(JobCard.JobQtyActual, 0) > 0 THEN CAST(JobCard.JobQtyActual AS INT) ELSE NULL END JobQtyActual');
            SELECT @QueryData =  REPLACE(@QueryData, 'JobCard.JobPartsOrdered', 'CAST(JobCard.JobPartsOrdered AS INT) JobPartsOrdered');  

			SET @sqlCommand = 'SELECT DISTINCT ' + @QueryData      

		END
		ELSE
		BEGIN
			IF ((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, ''+ @entity+'.Id') + '), 0) AS Id '
			END
			ELSE IF (
					(@isNext = 1)
					AND (@isEnd = 0)
					)
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, ''+ @entity+'.Id') + '), 0) AS Id '
			END
			ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 '+ @entity+'.Id '
			END
		END

		SET @sqlCommand = @sqlCommand + ' ,cust.CustTitle FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON prg.[Id]='+ @entity+'.[ProgramID] '
        SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CUST000Master] (NOLOCK) cust ON cust.[Id]=prg.[PrgCustID]  INNER JOIN #JOBGateways GWY ON GWY.JobID='+ @entity+'.[Id] '

		print @sqlCommand
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
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
		END

		IF ((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0) ) OR ((@isNext = 1) AND (@isEnd = 0))))
		BEGIN
			IF ((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				IF ((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id <= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
			ELSE IF ((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				IF ((ISNULL(@orderBy, '') <> '') AND (CHARINDEX(',', @orderBy) = 0))
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[vwJobAdvanceReport] (NOLOCK) ' + @entity + ' WHERE (1=1) ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) + ') '
				END
				ELSE
				BEGIN
					SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id >= ' + CAST(@recordId AS NVARCHAR(50))
				END
			END
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + ISNULL(@orderBy, ''+ @entity+'.Id')

		IF (@recordId = 0 AND @IsExport = 0)
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
				IF (((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
			ELSE
			BEGIN
				IF (((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
				BEGIN
					SET @sqlCommand = @sqlCommand + ' DESC'
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[JOBDL000Master] (NOLOCK) ' + @entity

		SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' + ISNULL(@where, '') + ISNULL(@groupByWhere, '')
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
			
	DROP TABLE #JOBGateways 
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO


