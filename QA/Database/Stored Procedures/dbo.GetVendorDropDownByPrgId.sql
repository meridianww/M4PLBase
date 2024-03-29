SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               22/02/2019      
-- Description:               Get  vendor records for the mapped vendor location for  selected program drop down
-- =============================================                          
CREATE PROCEDURE [dbo].[GetVendorDropDownByPrgId]
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
 DECLARE @tableName NVARCHAR(100)    
 DECLARE @newPgNo INT
 SET @sqlCommand = '';


 SELECT @tableName = [TblTableName] FROM [dbo].[SYSTM000Ref_Table] Where SysRefName = @entity  
 SET @sqlCommand = '';  
 

 IF(ISNULL(@primaryKeyValue, '') <> '')  
 BEGIN  
 SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName +   
        ' From '+ @tableName +' (NOLOCK) ' + @entity  
  
 IF  COL_LENGTH(@tableName, 'StatusId') IS NOT NULL AND ISNULL(@primaryKeyValue,0)=0
  BEGIN    
     SET @sqlCommand = @sqlCommand + ' WHERE ISNULL('+ @entity +'.StatusId, 1) In (1,2)';  
  END 
   
 SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;  
 EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                      
    SET @newPgNo =  @newPgNo/@pageSize + 1;   
 SET @pageSize = @newPgNo * @pageSize;  
 SET @sqlCommand=''  
 END  

 SET @sqlCommand += 'SELECT '+ @fields +' FROM '+ @tableName + ' (NOLOCK) '+  @entity + ' WHERE 1=1 '  

   
 IF  COL_LENGTH(@tableName, 'StatusId') IS NOT NULL
 BEGIN    
    SET @sqlCommand = @sqlCommand + ' AND ISNULL(' + @entity + '.StatusId, 1) In (1,2)';  
 END  
  SET @sqlCommand = @sqlCommand  + ' AND ID IN (SELECT Distinct(PvlVendorID)  FROM [PRGRM051VendorLocations] PrgVendLocation where ISNULL(PrgVendLocation.StatusId, 1) In (1,2) '+ @where +')'
  
 IF(ISNULL(@like, '') != '')    
  BEGIN    
  SET @sqlCommand = @sqlCommand + 'AND ('    
   DECLARE @likeStmt NVARCHAR(MAX)    
    
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')      
  SET @sqlCommand = @sqlCommand + @likeStmt + ') '    
  END    
 --IF(ISNULL(@where, '') != '')    
 -- BEGIN    
 --    SET @sqlCommand = @sqlCommand + @where     
 --END    

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'     
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
