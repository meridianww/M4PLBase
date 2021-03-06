SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2019) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               12/07/2018        
-- Description:               Get Column Aliases Drop down        
-- Execution:                 EXEC [dbo].[GetColumnAliasesDropDown]     
-- Modified on:				  11/26/2018(Nikhil)      
-- Modified Desc:             Introduced roleId to support security
-- Modified on:				  08/05/2019(Nikhil)      
-- Modified Desc:             Updated it to fix issue #45286(tems in Column Alias Screen In dropdown keeps on repeating) 
-- =============================================                              
CREATE PROCEDURE  [dbo].[GetColumnAliasesDropDown]  
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
 DECLARE @sqlCommand2 NVARCHAR(MAX);
 DECLARE @tableName NVARCHAR(100)    
 DECLARE @newPgNo INT  

DECLARE @colAliasTable TABLE  
(  
 Id BIGINT,  
 ColColumnName NVARCHAR(100),  
 ColAliasName NVARCHAR(100),  
 ColCaption NVARCHAR(100),  
 ColLookupId INT,  
 ColLookupCode NVARCHAR(100),  
 DataType NVARCHAR(100),  
 [MaxLength] INT  
)  
 

SET @sqlCommand='select DISTINCT ISNULL(ColumnAlias.Id,0) as Id,  
ISNULL(ColumnAlias.ColColumnName,cols.COLUMN_NAME) as ColColumnName,  
ISNULL(ColumnAlias.ColAliasName,cols.COLUMN_NAME) as ColAliasName,  
ISNULL(ColumnAlias.ColCaption,cols.COLUMN_NAME) as ColCaption ,  
ColumnAlias.ColLookupId,  
ColumnAlias.ColLookupCode,  
cols.Data_Type as DataType,  
--CASE WHEN c.precision >  c.max_length THEN c.precision WHEN  c.max_length>200 THEN (c.max_length)/10  ELSE (c.max_length)/2 END as [MaxLength],   
''nvarchar'',  
999   
from INFORMATION_SCHEMA.TABLES tabs  
INNER JOIN INFORMATION_SCHEMA.COLUMNS cols On tabs.TABLE_NAME = cols.TABLE_NAME  
INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tabs.TABLE_NAME = tbl.TblTableName   
LEFT JOIN SYSTM000ColumnsAlias (NOLOCK) ColumnAlias ON  cols.COLUMN_NAME = ColumnAlias.ColColumnName 
AND tbl.SysRefName = ColumnAlias.ColTableName  AND ColumnAlias.[LangCode] ='''+ @langCode+''' AND ColumnAlias.StatusId=1   
INNER JOIN sys.types t ON cols.DATA_TYPE = t.name  
--INNER JOIN sys.columns c ON  c.name  = cols.COLUMN_NAME  AND c.user_type_id = t.user_type_id 
'  


  
  IF(ISNULL(@where, '') <> '')     
 BEGIN
 SET @sqlCommand=@sqlCommand+' WHERE   ColumnAlias.ColTableName = '''+@where  +''''
 END
 ELSE
 BEGIN
 SET @sqlCommand='select DISTINCT ISNULL(ColumnAlias.ColColumnName,cols.COLUMN_NAME) as ColColumnName,  
ISNULL(ColumnAlias.ColAliasName,cols.COLUMN_NAME) as ColAliasName,  
ISNULL(ColumnAlias.ColCaption,cols.COLUMN_NAME) as ColCaption ,  
ColumnAlias.ColLookupId,  
ColumnAlias.ColLookupCode
FROM SYSTM000ColumnsAlias (NOLOCK) ColumnAlias
INNER JOIN INFORMATION_SCHEMA.COLUMNS cols   ON  cols.COLUMN_NAME = ColumnAlias.ColColumnName '
 END

 --print @sqlCommand


 IF(ISNULL(@like, '') <> '')     
 BEGIN
	IF(ISNULL(@where, '') <> '')
	BEGIN
	SET @sqlCommand=@sqlCommand+ ' AND ( ColColumnName LIKE ''%' + ltrim(@like) + '%'''
     +' OR ColAliasName LIKE ''%' + @like + '%'''
     +' OR ColCaption LIKE ''%' + @like + '%'''
     +' OR ColLookupId LIKE ''%' + @like + '%'''
     +' OR ColLookupCode LIKE ''%' + @like + '%'''
	 + ') '
	END
	ELSE
	BEGIN
	SET @sqlCommand=@sqlCommand+ ' WHERE ( ColColumnName LIKE ''%' + ltrim(@like) + '%'''
     +' OR ColAliasName LIKE ''%' + @like + '%'''
     +' OR ColCaption LIKE ''%' + @like + '%'''
     +' OR ColLookupId LIKE ''%' + @like + '%'''
     +' OR ColLookupCode LIKE ''%' + @like + '%'''
	 +' ) '
	END

 
 END
SET @sqlCommand = @sqlCommand + ' ORDER BY ISNULL(ColumnAlias.ColColumnName,cols.COLUMN_NAME) OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'     
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
