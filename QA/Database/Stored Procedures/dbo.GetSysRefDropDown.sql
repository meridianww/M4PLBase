SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/07/2018      
-- Description:               Get selected records for system reference
-- Execution:                 EXEC [dbo].[GetSysRefDropDown]  
-- Modified on:  
-- Modified Desc:  
-- =============================================                         
CREATE PROCEDURE [dbo].[GetSysRefDropDown]
 @langCode NVARCHAR(10),
 @orgId BIGINT,  
 @entity NVARCHAR(100),
 @fields NVARCHAR(2000),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @like NVARCHAR(500) = NULL,
 @where NVARCHAR(500) = null,
 @primaryKeyValue NVARCHAR(100) = null,
 @primaryKeyName NVARCHAR(50) = null  
AS                
BEGIN TRY                
SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @newPgNo INT
 SET @sqlCommand = '';

 IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	IF(@langCode='EN')
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
							   ' From [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + ' WHERE '+ @entity +'.StatusId In (1,2)' +
							   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
	ELSE
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY refOpLang.SysRefId) as Item  , refOpLang.SysRefId as Id '+ 
						   ' From [dbo].[SYSTM010Ref_Options] (NOLOCK) refOpLang INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + 
						   ' ON '+ @entity +'.Id = refOpLang.SysRefId WHERE '+ @entity +'.StatusId In (1,2)' +
						   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
 END

IF(@langCode='EN')
	BEGIN
		SET @sqlCommand = 'SELECT '+ @fields + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+  @entity  + ' WHERE 1=1 '
	END
ELSE
	BEGIN
		SET @sqlCommand = 'SELECT refOpLang.SysRefId as Id,  refOp.LookupName,  refOpLang.SysLookupCode, refOpLang.SysOptionName, refOp.SysDefault, refOp. IsSysAdmin FROM [dbo].[SYSTM010Ref_Options] (NOLOCK)  refOpLang'
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + ' ON '+@entity+'.Id = refOpLang.SysRefId WHERE 1=1 '
	END

IF(ISNULL(@like, '') != '')
		BEGIN
		SET @sqlCommand = @sqlCommand + 'AND ('
		 DECLARE @likeStmt NVARCHAR(MAX)
		SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')
		SET @sqlCommand = @sqlCommand + @likeStmt + ')'
		END
IF(ISNULL(@where, '') != '')
	BEGIN
		IF(ISNULL(@like, '') != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND (' + @where +')'
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + @where 
			END
END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,
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
