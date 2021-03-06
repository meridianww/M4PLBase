SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 [dbo].[GetContactCombobox]  'EN',1,'Contact','Contact.Id,Contact.ConFullName,Contact.ConJobTitle,Contact.ConFileAs',1,30,null,null,null,null,null,10003,'VendTabsContactInfo','VendContact',7,null  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified on:				  07/23/2019( Kirty - Added condition to get driver contact for JobDriverContactInfo)    
-- Modified on:				  08/12/2019(Nikhil Chauhan)   
-- Modified Desc:             Updated to get the Driver Contacts based on vendor DC location passed.
-- =============================================                            
CREATE PROCEDURE [dbo].[GetContactCombobox] @langCode NVARCHAR(10)
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
	,@parentId BIGINT = NULL
	,@entityFor NVARCHAR(50) = NULL
	,@parentEntity NVARCHAR(50) = NULL
	,@companyId BIGINT = NULL
	,@jobSiteCode NVARCHAR(50) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @sqlCommand NVARCHAR(MAX);
	DECLARE @newPgNo INT

	SET @sqlCommand = '';

	IF (
			@entityFor = 'PPPRespGateway'
			OR @entityFor = 'PPPJobRespContact'
			OR @entityFor = 'PPPJobAnalystContact'
			OR @entityFor = 'PPPRoleCodeContact'
			OR @entityFor = 'PPPAnalystGateway'
			)
	BEGIN
		EXEC [dbo].[GetPPPGatewayContactCombobox] @langCode
			,@orgId
			,@entity
			,@fields
			,@pageNo
			,@pageSize
			,@orderBy
			,@like
			,@where
			,@primaryKeyValue
			,@primaryKeyName
			,@parentId
			,@entityFor
	END
	ELSE
	BEGIN
		IF (ISNULL(@primaryKeyValue, '') <> '')
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName + ') as Item  ,' + @entity + '.' + @primaryKeyName + ' From [dbo].[CONTC000Master] (NOLOCK)  ' + @entity;
			SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.ConOrgId =' + CAST(@orgId AS NVARCHAR(100)) + ' AND (ISNULL(' + @entity + '.StatusId, 1) In (1,2)  OR ' + @primaryKeyName + '=' + @primaryKeyValue + ')';
			SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			SET @pageSize = @pageSize + 1;

			EXEC sp_executesql @sqlCommand
				,N' @newPgNo int output'
				,@newPgNo OUTPUT

			SET @newPgNo = @newPgNo / @pageSize + 1;
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand = ''
		END

		SET @sqlCommand += 'SELECT DISTINCT ' + @fields + ' From [dbo].[CONTC000Master] (NOLOCK) ' + @entity + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpt ON refOpt.Id = ' + @entity + '.ConTypeId'

		IF (
				@parentEntity = 'Job'
				AND @entityFor = N'JobDriverContactInfo'
				)
		BEGIN
			SET @sqlCommand += ' INNER JOIN  CONTC010Bridge cb on cb.ContactMSTRID = contact.Id   and cb.ConTableName = ''VendDcLocationContact'' 
							INNER JOIN  [PRGRM051VendorLocations] PVL ON pvl.VendDCLocationId = cb.ConPrimaryRecordId  AND ISNULL(PVL.StatusId, 1) In (1,2)'

			IF (ISNULL(@jobSiteCode, '') <> '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND  pvl.PvlLocationCode = ''' + @jobSiteCode + '''';
			END
			ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1 <> 1 '
			END

			SET @sqlCommand += 'LEFT JOIN ORGAN010Ref_Roles refrole on refrole.Id = cb.ConCodeId  and refrole.OrgRoleCode = ''Driver''
							LEFT JOIN SYSTM000Ref_Options refoptRole ON refoptRole.Id = refrole.RoleTypeId  and refOpt.SysOptionName = ''Driver''  AND refoptRole.SysOptionName = ''Vendor'''
		END

		SET @sqlCommand += ' WHERE 1=1 ' + ' AND ' + @entity + '.ConOrgId =' + CAST(@orgId AS NVARCHAR(100))

		IF (ISNULL(@CompanyId, 0) <> 0)
		BEGIN
			SET @sqlCommand += ' AND ' + @entity + '.ConCompanyId =' + CAST(@companyId AS NVARCHAR(100))
		END

		IF (@parentEntity = 'OrgPocContact')
		BEGIN
			SET @sqlCommand += ' AND ' + @entity + '.ConCompanyId = ( select id  from  [COMP000Master] where CompPrimaryRecordId = ' + CAST(@orgId AS NVARCHAR(100)) + ')'
		END

		IF (ISNULL(@primaryKeyValue, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' AND (ISNULL(' + @entity + '.StatusId, 1) In (1,2)  OR  ' + @entity + '.' + @primaryKeyName + '=' + @primaryKeyValue + ')';
		END
		ELSE
		BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ISNULL(' + @entity + '.StatusId, 1) In (1,2)';
		END

		IF (ISNULL(@like, '') != '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ('

			DECLARE @likeStmt NVARCHAR(MAX)

			SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
			FROM [dbo].[fnSplitString](@fields, ',')

			SET @sqlCommand = @sqlCommand + @likeStmt + ') '
		END

		IF (ISNULL(@where, '') != '')
		BEGIN
			SET @sqlCommand = @sqlCommand + @where
		END

		PRINT @sqlCommand

		SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @fields + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'

		EXEC sp_executesql @sqlCommand
			,N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @parentId BIGINT'
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@where = @where
			,@parentId = @parentId
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
