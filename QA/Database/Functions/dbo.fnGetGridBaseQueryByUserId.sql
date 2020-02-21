SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               05/09/2018      
-- Description:               Get Row Count based on table
-- Execution:                 SELECT  [dbo].[fnGetBaseQueryByUserId]('CustBusinessTerm','EN')
-- Modified on:  
-- Modified Desc:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetGridBaseQueryByUserId]  
(  
 @tableName NVARCHAR(100),
 @userId BIGINT
)  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
 DECLARE @tempColumnName TABLE(ColumnName NVARCHAR(100))
 DECLARE @query NVARCHAR(MAX);  
 INSERT INTO @tempColumnName Select item from  [dbo].[fnSplitString]((select ColNotVisible from SYSTM000ColumnSettingsByUser where ColTableName=@tableName and ColUserId=@userId), ',')  
 ;WITH AllColumnNames AS
 (
	SELECT distinct col.[ColColumnName] 
	FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl  
	INNER JOIN [dbo].[SYSTM000ColumnsAlias] (NOLOCK) col ON tbl.[SysRefName] =col.ColTableName
	INNER JOIN  sys.columns c ON  c.name = col.ColColumnName AND c.object_id = OBJECT_ID(tbl.TblTableName)   
	LEFT JOIN @tempColumnName tcn ON col.ColColumnName <> tcn.ColumnName
	WHERE tbl.[SysRefName] =  @tableName AND col.[ColIsVisible] = 1 AND ISNULL(col.IsGridColumn, 0) = 1
 )
 select @query = COALESCE(@query + ', ','') + @tableName + '.' + ColColumnName  FROM AllColumnNames
RETURN @query  
END
