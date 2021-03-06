SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               11/11/2018      
-- Description:               Get Display Message for cache
-- Execution:                 EXEC [dbo].[GetEntitySubView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetEntitySubView]
	@userId BIGINT,
	@roleId BIGINT,
	@langCode NVARCHAR(10),
	@orgId BIGINT,
	@entity NVARCHAR(100),
	@fields NVARCHAR(MAX),
	@pageNo INT = 1,
	@pageSize INT = 10,
	@orderBy NVARCHAR(100) = null,
	@like NVARCHAR(MAX) = null,
	@where NVARCHAR(MAX) = null,
	@parentId BIGINT = null

AS
BEGIN TRY                
 SET NOCOUNT ON; 


 DECLARE @sqlCommand NVARCHAR(MAX);
 SET @where = ISNULL(@where, '')

IF(@entity = 'Contact')  
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.ConFullName, '+@entity+'.ConJobTitle  FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.ConFullName LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.ConJobTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '
			END
	END
ELSE IF(@entity = 'Organization')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.OrgCode, '+@entity+'.OrgTitle  FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + '  '
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.OrgCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.OrgTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '
			END
	END
ELSE IF(@entity = 'Customer')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.CustCode, '+@entity+'.CustTitle  FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.CustOrgId=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.CustCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.CustTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'SecurityByRole')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.RoleCode, '+@entity+'.SecLineOrder  FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.OrgId=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.RoleCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.SecLineOrder LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Program')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.PrgItemNumber, '+@entity+'.PrgProgramCode  FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.PrgOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.PrgItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.PrgProgramCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Job')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.JobSiteCode, '+@entity+'.JobConsigneeCode  FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID=prg.Id'
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON prg.PrgOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.JobSiteCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.JobConsigneeCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'VendDcLocation')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VdcItemNumber, '+@entity+'.VdcLocationCode  FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[VEND000Master] vend ON ' + @entity + '.VdcVendorID=vend.Id'
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON vend.VendOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VdcItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VdcLocationCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Vendor')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VendItemNumber, '+@entity+'.VendCode  FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.VendOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VendItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VendCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Table')  
	BEGIN
		SET @sqlCommand = 'SELECT ['+@entity+'].SysRefName AS RefName  FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) ['+ @entity+']'
		IF(ISNULL(@where,'') != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE [' + @entity + '].SysRefName LIKE ''%' + @where + '%'''
				
			END		
	END

	

IF(@entity = 'Table') 
BEGIN
     SET @sqlCommand = @sqlCommand + ' ORDER BY ['+@entity+'] .SysRefName OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 
END
ELSE
BEGIN

SET @sqlCommand = @sqlCommand + ' ORDER BY '+@entity+' .Id OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 
END
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @orgId BIGINT' ,
	 @orgId = @orgId,
     @pageNo = @pageNo, 
     @pageSize = @pageSize,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
