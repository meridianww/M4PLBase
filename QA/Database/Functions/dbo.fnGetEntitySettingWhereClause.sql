SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery1.sql|7|0|C:\Users\NIKHIL~1.CHA\AppData\Local\Temp\~vs1DBB.sql

  
-- =============================================      
-- Author       : Nikhil       
-- Create date  : 29 Jan 2018    
-- Description  : To get entity's setting where condition   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 
CREATE FUNCTION [dbo].[fnGetEntitySettingWhereClause]
(
	@userId BIGINT,
	@entity NVARCHAR(100),
	@settingName NVARCHAR(100),
	@joins NVARCHAR(MAX),
	@recordId BIGINT=NULL
)

RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @sqlCommand NVARCHAR(MAX), @whereClause NVARCHAR(MAX), @tableName NVARCHAR(100), @pKFieldName NVARCHAR(100), @itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100), @columnNames NVARCHAR(MAX);
	SELECT @tableName = sysRef.TblTableName,
			@pKFieldName = sysRef.TblPrimaryKeyName,
			@itemFieldName = sysRef.TblItemNumberFieldName,
			@parentKeyName = sysRef.TblParentIdFieldName
	FROM SYSTM000Ref_Table sysRef WHERE SysRefName = @entity
  
	SELECT @columnNames = COALESCE(@columnNames + ' + ','') + ''' '+ usys.Value + ' ''' + 
	(CASE usys.ValueType WHEN 'String' THEN  ''''' + CAST('+ usys.ColumnName +' AS NVARCHAR(MAX)) +'''''''''
	ELSE ' + CAST('+ usys.ColumnName +' AS NVARCHAR(MAX))' END)
	FROM [dbo].[fnGetUserSettings] (0, @userId , @entity, @settingName) usys

	IF(ISNULL(@joins, '') = '')
		BEGIN 
		SET @joins = '';
		END

	--SET @sqlCommand = 'SELECT @whereClause = '+  @columnNames +' FROM '+ @tableName + ' ' + @entity
	--+ @joins + ' WHERE ' + @entity + '.' +@pKFieldName  +' = CAST('+ CAST( @recordId AS  NVARCHAR(MAX) ) +' AS BIGINT)'--' = CAST(' + @recordId + 'AS NVARCHAR(MAX)) '

	--EXEC sp_executesql @sqlCommand, N'@whereClause NVARCHAR(MAX) OUTPUT',@whereClause =  @whereClause OUTPUT

	RETURN   @columnNames
END
GO
