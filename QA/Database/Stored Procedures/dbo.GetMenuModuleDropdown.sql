SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               01/06/2018      
-- Description:               Get Menu driver Module Id  
-- Execution:                 EXEC [dbo].[GetMenuModuleDropdown]
-- Modified on:  
-- Modified Desc:  
-- =============================================                            
CREATE PROCEDURE [dbo].[GetMenuModuleDropdown]    
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
  
SET @sqlCommand   = 'SELECT t.*,'   
                   +'(SELECT rbn.MnuBreakdownStructure  
      from SYSTM000MenuDriver  rbn  
      LEFT JOIN SYSTM000Ref_Options refrbn On rbn.MnuModuleId = refrbn.Id   
      WHERE rbn.MnuTableName IS  NULL AND LEN(rbn.MnuBreakdownStructure) =5 AND rbn.MnuBreakdownStructure like ''01.__'' AND  rbn.MnuModuleId=t.Id ) AS RbnBreakdownStructure'  
  
     +' FROM'  
     +'( select ref.Id as Id,ref.SysOptionName as MnuTitle,mnu.MnuBreakDownStructure from SYSTM000Ref_Options  ref  
      LEFT JOIN SYSTM000MenuDriver mnu On mnu.MnuModuleId = ref.Id   
      WHERE LEN(MnuBreakdownStructure) =5  AND MnuBreakdownStructure like ''02.__''  
      ) as t'  
  
  
 IF(ISNULL(@like, '') != '')    
  BEGIN    
  SET @sqlCommand = @sqlCommand + 'AND ('    
   DECLARE @likeStmt NVARCHAR(MAX)    
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
  SET @sqlCommand = @sqlCommand + @likeStmt + ')'    
  END    
    
SET @sqlCommand = @sqlCommand + ' ORDER BY Id ';

print @sqlCommand
  
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
