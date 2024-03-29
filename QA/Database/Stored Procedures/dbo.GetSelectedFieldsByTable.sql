SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               12/07/2018        
-- Description:               Get selected records by table    
-- Execution:                 EXEC [dbo].[GetSelectedFieldsByTable] 'EN', 1, 'Customer', 'Customer.Id,Customer.CustCode,Customer.CustTitle', 1, 100, null, null, null,null,null    
-- Modified on:				  05/29/2019( Kirty - Condition added for Status)      
-- Modified Desc:    
-- =============================================                              
CREATE PROCEDURE [dbo].[GetSelectedFieldsByTable] @langCode NVARCHAR(10)
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@fields NVARCHAR(2000)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@like NVARCHAR(500) = NULL
	,@where NVARCHAR(500) = NULL
	,@primaryKeyValue NVARCHAR(100) = NULL
	,@primaryKeyName NVARCHAR(50) = NULL
	,@userId BIGINT = NULL
	,@entityFor NVARCHAR(50) = NULL
	,@roleId BIGINT = 0
	,@parentId BIGINT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @tableName NVARCHAR(100)
	DECLARE @newPgNo INT

	SELECT @tableName = [TblTableName]
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	SET @sqlCommand = '';

	IF @entityFor = 'OrgRolesResp'
	BEGIN
		SET @entityFor = 'OrgActRole'
	END

	IF (ISNULL(@primaryKeyValue, '') <> '')
	BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName + ') as Item  ,' + @entity + '.' + @primaryKeyName + ' From ' + @tableName + ' (NOLOCK) ' + @entity

		IF COL_LENGTH(@tableName, 'StatusId') IS NOT NULL
			AND ISNULL(@primaryKeyValue, 0) = 0
		BEGIN
			IF @entity = 'VendDcLocation'
			BEGIN
			  SET @sqlCommand = @sqlCommand + ' WHERE ISNULL(' + @entity + '.StatusId, 1) =1';
			END
			ELSE
			BEGIN
			  SET @sqlCommand = @sqlCommand + ' WHERE ISNULL(' + @entity + '.StatusId, 1) In (1,2)';
			END			
		END

		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;

		EXEC sp_executesql @sqlCommand
			,N' @newPgNo int output'
			,@newPgNo OUTPUT

		SET @newPgNo = @newPgNo / @pageSize + 1;
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand = ''
	END

	IF @entityFor = 'OrgActRole'
	BEGIN
		SET @sqlCommand += 'SELECT DISTINCT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' JOIN [dbo].[ORGAN020Act_Roles] ' + @entityFor + ' ON ' + @entityFor + '.OrgRefRoleId=' + @entity + '.id' + ' JOIN [dbo].[fnGetUserStatuses](' + CAST(@userId AS VARCHAR(10)) + ') fgus ON ISNULL( ' + @entityFor + '.[StatusId], 1) = fgus.[StatusId] WHERE 1=1 AND ISNULL(' + @entityFor + '.[StatusId],1) IN (1,2) ' --AND ACTR.OrgID=' +CAST(@orgId AS VARCHAR(10))+' '
	END
	ELSE
	BEGIN
		IF (
				@entity = 'PrgShipStatusReasonCode'
				AND @entityFor = 'Job'
				)
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity
			SET @sqlCommand += ' JOIN  [dbo].[JOBDL000Master] Job ON JOB.ProgramID=' + @entity + '.PscProgramID '
			SET @sqlCommand += ' WHERE 1=1 '
		END
		ELSE IF (
				@entity = 'PrgShipApptmtReasonCode'
				AND @entityFor = 'Job'
				)
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity
			SET @sqlCommand += ' JOIN  [dbo].[JOBDL000Master] Job ON JOB.ProgramID=' + @entity + '.PacProgramID '
			SET @sqlCommand += ' WHERE 1=1 '
		END
		ELSE IF (@entity = 'TableReference')
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' WHERE 1=1'
		END
		ELSE IF (@entity = 'Customer')
		BEGIN
----------------------Based on security----------------------
		SET @sqlCommand += 'SELECT DISTINCT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity 
						
		DECLARE @JobCount BIGINT,@IsJobAdmin BIT = 0;
			IF(@userId <> 0 AND @roleId <> 0)
			BEGIN
			---------Get program access ids based on userid and role id----------
				IF OBJECT_ID('tempdb..#EntityIdProgamTemp') IS NOT NULL
				BEGIN
				DROP TABLE #EntityIdProgamTemp
				END
				
				 CREATE TABLE #EntityIdProgamTemp
				(
				EntityId BIGINT
				)
				
				INSERT INTO #EntityIdProgamTemp
				EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Program',0,1
				SELECT @JobCount = Count(ISNULL(EntityId, 0))
				FROM #EntityIdProgamTemp
				WHERE ISNULL(EntityId, 0) = -1
				IF (@JobCount = 1)
				BEGIN
					SET @IsJobAdmin = 1
				END 
			---------Get program access ids based on userid and role id----------
					IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
					BEGIN
						SET @sqlCommand	+= ' INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = ' + @entity + '.Id '
						SET @sqlCommand += ' INNER JOIN #EntityIdProgamTemp tmp ON PRG.[Id] = tmp.[EntityId] '
					END
			END
		
			SET @sqlCommand += ' WHERE 1=1 AND ISNULL(' + @entity + '.[StatusId],1) IN (1,2)'
----------------------Based on security----------------------
		END
		ELSE IF(@entity = 'Program')
		BEGIN
			SET @sqlCommand += 'SELECT '+ @entity +'.Id, '+ @entity +'.PrgProgramCode , cust.CustCode as PrgCustomerCode  FROM ' 
			+ @tableName + ' (NOLOCK) ' + @entity + ' INNER JOIN CUST000Master Cust ON ' + @entity + '.PrgCustID = Cust.Id'
			+ ' WHERE 1=1 AND ISNULL(' + @entity + '.[StatusId],1) = 1'
			--SET @fields = REPLACE(@fields, + @entity + '.PrgCustomerCode', 'PrgCustomerCode');	
		    SET @fields = ' PrgCustomerCode, ' + @entity + '.Id,' + @entity + '.PrgProgramCode';
		END
		ELSE IF(@entity = 'PrgRefGatewayDefault')
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity + 
			' WHERE 1=1 AND ISNULL(' + @entity + '.[StatusId],1) IN (1,2)'
		END
		ELSE IF(@entity = 'VendDcLocation')
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' WHERE 1=1 AND ISNULL(' + @entity + '.[StatusId],1) =1 '
		END
		ELSE
		BEGIN
			SET @sqlCommand += 'SELECT ' + @fields + ' FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' WHERE 1=1 AND ISNULL(' + @entity + '.[StatusId],1) IN (1,2)'
		END
	END

	IF @entityFor IN (
			'VendDcLocationContact'
			,'VendContact'
			)
	BEGIN
		SET @sqlCommand = @sqlCommand + 'AND ' + @entity + '.RoleTypeId IN (SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = ''Vendor'' AND SysLookupCode = ''RoleType'' AND StatusId = 1)'
	END

	IF (@entityFor = 'SystemAccount' AND @parentId > 0)
	BEGIN
		DECLARE @conType NVARCHAR(40) = NULL;;
		SELECT @conType =SYSOPT.SysOptionName FROM CONTC000Master  CM 
		INNER JOIN SYSTM000Ref_Options SYSOPT ON CM.ConTypeId = SYSOPT.Id WHERE CM.Id = @parentId AND CM.StatusId = 1 ;	
		 IF(@conType IS NOT NULL AND @conType <> '')
		 BEGIN
			SET @sqlCommand = @sqlCommand + 'AND ' + @entity + 
			'.RoleTypeId IN (SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = '''+ @conType +''' AND SysLookupCode = ''RoleType'' AND StatusId = 1)'
		 END	 
	END

	IF @entityFor IN (
			'CustDcLocationContact'
			,'CustContact'
			)
	BEGIN
		SET @sqlCommand = @sqlCommand + 'AND ' + @entity + '.RoleTypeId IN (SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = ''Customer'' AND SysLookupCode = ''RoleType'' AND StatusId = 1)'
	END

	IF @entity = 'Program'
	BEGIN
		DECLARE @queryFil NVARCHAR(MAX) = ' CASE WHEN ' + @entity + '.PrgHierarchyLevel = 1 THEN ' + @entity + '.PrgProgramCode
                                  WHEN ' + @entity + '.PrgHierarchyLevel = 2 THEN ' + @entity + '.PrgProjectCode
							 WHEN ' + @entity + '.PrgHierarchyLevel = 3 THEN ' + @entity + '.PrgPhaseCode
							 ELSE ' + @entity + '.PrgProgramTitle END  AS PrgProgramCode '

		SET @sqlCommand = REPLACE(@sqlCommand, + @entity + '.PrgProgramCode', @queryFil);		
	END

	IF COL_LENGTH(@tableName, 'StatusId') IS NOT NULL
		AND @entity <> 'OrgRefRole' AND @entity <> 'Program'
	BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ISNULL(' + @entity + '.StatusId, 1) In (1,2)';
	END

	IF (ISNULL(@like, '') != '')
	BEGIN
		SET @sqlCommand = @sqlCommand + 'AND ('

		DECLARE @likeStmt NVARCHAR(MAX)

		SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
		FROM [dbo].[fnSplitString](@fields, ',')

		SET @sqlCommand = @sqlCommand + @likeStmt + ') '
	END

	IF (ISNULL(@where, '') != '')
	BEGIN
		SET @sqlCommand = @sqlCommand + @where
	END
	IF (@entity = 'VendDcLocation')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY VendDcLocation.VdcLocationCode ASC OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
		END
		ELSE
		BEGIN
			SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @fields + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
		END
	PRINT @sqlCommand
	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)'
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@where = @where
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
		,@pageNo
		,@ErrorMessage
		,@where
		,@sqlCommand
		,@ErrorSeverity
END CATCH


GO
