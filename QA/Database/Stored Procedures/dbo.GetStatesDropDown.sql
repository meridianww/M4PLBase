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
-- Execution:                 EXEC [dbo].[GetStatesDropDown]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================                          
CREATE PROCEDURE [dbo].[GetStatesDropDown]
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
 @primaryKeyName NVARCHAR(50) = null,
 @selectedCountry NVARCHAR(20) = NULL
AS                
BEGIN TRY                
SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @newPgNo INT;
 SET @sqlCommand = '';

 IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
					   ' From [dbo].[SYSTM000Ref_States] (NOLOCK) ' + @entity + ' JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON ' + @entity + '.[StateCountryId]=sysRef.Id WHERE '+ @entity +'.StatusId In (1,2)';
					   
	IF(ISNULL(@selectedCountry, '') != '')
	BEGIN
	  SET @sqlCommand = @sqlCommand + ' AND sysRef.SysOptionName = ''' + @selectedCountry + '''';	  
	END
	 SET @sqlCommand = @sqlCommand + ' ) t WHERE 1= 1  '  
	 IF(ISNULL(@selectedCountry, '') = '')
	 BEGIN
	   SET @sqlCommand = @sqlCommand + 'AND t.' + @primaryKeyName + '=''' + @primaryKeyValue + '''';
	 END
	EXEC sp_executesql @sqlCommand , N' @newPgNo int output',@newPgNo output  
	                  
    -- SET @newPgNo =  @newPgNo/@pageSize + 1; 
	--SET @pageSize = @newPgNo * @pageSize;
	SET @sqlCommand=''
 END

 SET @sqlCommand = 'SELECT '+ @fields +', sysRef.[SysOptionName] as Country FROM [dbo].[SYSTM000Ref_States] (NOLOCK) '+  @entity 
 SET @sqlCommand += ' JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON ' + @entity + '.[StateCountryId]=sysRef.Id WHERE 1=1 AND ' + @entity + '.StatusId In (1,2) '
 
 IF(ISNULL(@selectedCountry, '') != '')
	BEGIN
	  SET @sqlCommand = @sqlCommand + ' AND sysRef.SysOptionName = ''' + @selectedCountry + '''';
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @selectedCountry NVARCHAR(20)' ,
     @pageNo = @pageNo, 
     @pageSize = @pageSize,
     @where = @where,
	 @selectedCountry = @selectedCountry
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
